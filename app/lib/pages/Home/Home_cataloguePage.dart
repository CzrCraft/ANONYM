import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';

class _DesignWidget extends StatefulWidget {
  _DesignWidget({required this.designID, required this.name, required this.author, required this.like_count, required this.thumbnailId, this.isLiked = false, this.isDisliked = false, super.key});
  String name;
  String author;
  String designID;
  int like_count;
  bool isLiked = false;
  bool isDisliked = false;
  String thumbnailId;
  @override
  State<_DesignWidget> createState() => __DesignWidgetState();
}

class __DesignWidgetState extends State<_DesignWidget> {
  @override
  Widget build(BuildContext context) {
    Widget iconWidget1;
    Widget iconWidget2;
    if(widget.isLiked){
      iconWidget1 = Icon(Icons.thumb_up, color: primaryColor);
    }else{
      if(widget.isDisliked){
        iconWidget1 = Icon(Icons.thumb_up_alt_outlined, color: primaryColor);
      }else{
        iconWidget1 = Icon(Icons.thumb_up_alt_outlined, color: primaryColor);
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getFromPercent("horizontal", 1.2, context), vertical: getFromPercent("vertical", 1, context)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor, width: getFromPercent("horizontal", 1.3, context)),
          color: secondaryColor
        ),
        height: getFromPercent("vertical", 30, context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getFromPercent("horizontal", 1, context)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: getImageFromApi(widget.thumbnailId, getFromPercent("vertical", 28, context), getFromPercent("horizontal", 38, context), api_token),
              ),
              Expanded(
                child: Center(
                  //padding: EdgeInsets.symmetric(horizontal: getFromPercent("horizontal", 15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: getFromPercent("vertical", 1, context)),
                        child: AutoSizeText(
                          widget.name, 
                          style: TextStyle(backgroundColor: Colors.transparent, color: primaryColor, fontWeight: FontWeight.w700, fontSize: 25),
                          minFontSize: 13,
                          maxFontSize: 25,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getFromPercent("vertical", .1, context)),
                        child: AutoSizeText(
                          widget.author, 
                          style: TextStyle(backgroundColor: Colors.transparent, color: primaryColor, fontWeight: FontWeight.w700, fontSize: 18),
                          minFontSize: 13,
                          maxFontSize: 15,
                          maxLines: 1,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getFromPercent("vertical", 13, context), right: getFromPercent("horizontal", 6, context)),
                        child: Center(
                          child: ButtonBar(
                            children: [
                              TextButton(
                                child: iconWidget1, 
                                onPressed: (){
                                  if(widget.isLiked){
                                    dislikeDesign(widget.designID, api_token, (bool result){
                                      if(result){
                                        setState(() {
                                          widget.isLiked = false;
                                        });
                                      }
                                    });
                                  }else{
                                    likeDesign(widget.designID, api_token, (bool result){
                                      if(result){
                                        setState(() {
                                          widget.isLiked = true;
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                              Center(
                                child: ElevatedButton(
                                  child: Text("View", style: TextStyle(color: secondaryColor)),
                                  onPressed: (){
                                    print("tapped");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shadowColor: Colors.transparent,
                                  )
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ],
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}
class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    setThemeColors(true);
    return FutureBuilder(
      future: getDesigns(api_token),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          String apiData = snapshot.data.body.replaceAll(RegExp(r"\\"), "");
          List<dynamic> jsonApiData = jsonDecode(apiData);
          List<Widget> designList = List.empty(growable: true);
          print(jsonApiData);
          jsonApiData.forEach((design) {
            String designName = "";
            String designAuthor = "";
            String designID = "";
            String thumbnailId = "";
            bool isLiked = false;
            int likeCount = 0;
            Map<String, dynamic> designFeatures;
            design.forEach((key, value){
              switch(key){
                case "like_count":
                  likeCount = value;
                  break;
                case "author":
                  designAuthor = value;
                  break;
                case "designName":
                  designName = value;
                  break;
                case "properties":
                  designFeatures = value;
                  break;
                case "thumbnail_id":
                  thumbnailId = value;
                  break;
                case "design_id":
                  designID = value;
                  break;
                case "liked_by":
                  if(value.contains("," + username)){
                    isLiked = true;
                  }
                  break;
              }
            });
            designList.add(_DesignWidget(name: designName, author: designAuthor, like_count: likeCount, thumbnailId: thumbnailId, isLiked: isLiked,designID: designID,));
          },);
          return Center(child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: getFromPercent("vertical", 3, context), left: getFromPercent("horizontal", 3, context), right: getFromPercent("horizontal", 3, context)),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 3.0)
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(                    
                      color: primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: primaryColor,
                  ),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500
                  ),
                  cursorColor: primaryColor,
                  onSubmitted: (input){
                    print(input);
                  },
                ),
              ),
              Column(children: designList),
            ],
          ));
        }else{
          return LoadingDots(lightMode: true,);
        }
      },
    );
  }
}
