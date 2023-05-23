import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';

class _DesignWidget extends StatelessWidget {
  _DesignWidget({required this.name, required this.author, required this.like_count, required this.thumbnailId, super.key});
  String name;
  String author;
  int like_count;
  String thumbnailId;
  @override
  Widget build(BuildContext context) {
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
                child: getImageFromApi(thumbnailId, getFromPercent("vertical", 28, context), getFromPercent("horizontal", 38, context), api_token),
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
                          name, 
                          style: TextStyle(backgroundColor: Colors.transparent, color: primaryColor, fontWeight: FontWeight.w700, fontSize: 25),
                          minFontSize: 13,
                          maxFontSize: 25,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getFromPercent("vertical", .1, context)),
                        child: AutoSizeText(
                          author, 
                          style: TextStyle(backgroundColor: Colors.transparent, color: primaryColor, fontWeight: FontWeight.w700, fontSize: 18),
                          minFontSize: 13,
                          maxFontSize: 15,
                          maxLines: 1,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: getFromPercent("vertical", 3, context)),
                        child: Center(
                          child: ButtonBar(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: getFromPercent("horizontal", 5, context)),
                                child: Icon(Icons.thumb_up, color: primaryColor)
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: getFromPercent("horizontal", 14.5, context)),
                                child: Icon(Icons.thumb_down, color: primaryColor)
                              ),
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
            String thumbnailId = "";
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
              }
            });
          },);
          designList.add(_DesignWidget(name: "testName", author: "testAuthor", like_count: 0, thumbnailId: "9bvd2KSW8F9AmvNPHcVAJhc0NXGvrrlCwQ2fj06xZmGGYpnXHy",));
          return Center(child: Column(
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
              Column(children:designList),
            ],
          ));
        }else{
          return LoadingDots(lightMode: true,);
        }
      },
    );
  }
}
