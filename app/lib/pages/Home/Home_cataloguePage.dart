// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';

class _DesignWidget extends StatefulWidget {
  _DesignWidget({required this.properties, required this.designID, required this.name, required this.author, required this.like_count, required this.thumbnailId, this.isLiked = false, super.key});
  String name;
  String author;
  String designID;
  int like_count;
  bool isLiked = false;
  String thumbnailId;
  Map<String, dynamic> properties;
  @override
  State<_DesignWidget> createState() => __DesignWidgetState();
}

class __DesignWidgetState extends State<_DesignWidget> {
  @override
  Widget build(BuildContext context) {
    Widget iconWidget1;
    if(widget.isLiked){
      iconWidget1 = Icon(Icons.thumb_up, color: primaryColor);
    }else{
      iconWidget1 = Icon(Icons.thumb_up_alt_outlined, color: primaryColor);
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
                child: getImageFromApi(widget.thumbnailId, height: getFromPercent("vertical", 28, context), width: getFromPercent("horizontal", 38, context), api_token),
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
                                  // liking logic
                                  if(widget.isLiked){
                                      dislikeDesign(widget.designID, api_token, (bool result){
                                        if(result){
                                          setState(() {
                                            widget.isLiked = false;
                                          });
                                        }else{
                                          print("e");
                                        }
                                      });
                                  }else{
                                    setState(() {
                                      likeDesign(widget.designID, api_token, (bool result){
                                        if(result){
                                          setState(() {
                                            widget.isLiked = true;
                                          });
                                        }
                                      });
                                    });
                                  }
                                },
                              ),
                              Center(
                                child: ElevatedButton(
                                  child: Text("View", style: TextStyle(color: secondaryColor)),
                                  onPressed: (){
                                    // changing to _ViewPage widget
                                    print("tapped");
                                      Navigator.push(context, animatedRoute(_ViewPage(designID: widget.designID,)));
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
  List<Widget> designList = List.empty(growable: true);
  bool ran = false;
  @override
  // fuck this code
  // dont change important
  // rlly bad hack tho
  Widget build(BuildContext context) {
    setThemeColors(true);
    void setup(String apiData) async{
      if(!ran){
        List<dynamic> jsonApiData = jsonDecode(apiData);
        // really shitty solution but idgaf
        List<String> designIDs = List.empty(growable: true);
        for(var design in jsonApiData){
          // RLLY IMPORTANT DON'T CHANGE
          String designName = "";
          String designAuthor = "";
          String designID = "";
          String thumbnailId = "";
          bool isLiked = false;
          int likeCount = 0;
          Map<String, dynamic> designFeatures = {};
          // loop through the values in the response
          // DONT CHANGE THIS 
          bool doPush = true;
          for(var entry in design.entries){
            var key = entry.key;
            var value = entry.value;
            // asign each value to a variable
            // don't ask why i did it this way
            // it wrote this at 2:03 am
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
                if((designIDs.contains(designID))){
                  doPush = false;
                }
                break;
              case "liked_by":
                // fucking pain in the ass to get working
                // spent like 3 hours debugging this shit
                String username = await getUsername(api_token);
                  if(value.contains("," + username)){
                    print("e");
                    isLiked = true;
                    break;
                  }else{
                    break;
                  }
            }
          }
          if(doPush){
            // add the design to the ListView widget that's going to be shown on the screen
            designList.add(_DesignWidget(properties: designFeatures, name: designName, author: designAuthor, like_count: likeCount, thumbnailId: thumbnailId, isLiked: isLiked,designID: designID,));
          }else{
            doPush = true;
          }
          
        }
        setState(() {
          // DONT CHANGE THIS 
          // VERY IMPORTANT
          ran = true;
        });
      }

    }
    return FutureBuilder(
      future: getDesigns(api_token),
      builder: (context, snapshot){
          if(snapshot.hasData) {
          // setup designs
          // have to use seperate function because i need to use await
          // when it's done it calls setState() with the widgets put in the ListView
          setup(snapshot.data.body.replaceAll(RegExp(r"\\"), ""));
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
// the _ char means that this widget is local
// so that i don't fuck everything up
class _ViewPage extends StatefulWidget {
  _ViewPage({required this.designID, super.key});
  String designID;
  bool isLiked = false;
  @override
  State<_ViewPage> createState() => __ViewPageState();
}

class __ViewPageState extends State<_ViewPage> {
  // gonna request the design again
  // because this time it's going to contain all
  // the designs properties
  String designName = "testNamen";
  String designAuthor = "testAuthor";
  var thumbnailID = "";
  bool ran = false;
  // ^ is rlly shitty solution to a stupid problem but really easy to implement
  // i've only got two days left to finnish this
  late Map<String, dynamic> properties;
  @override
  Widget build(BuildContext context) {
    // just started making this and it's already a pain in the ass
    // fucking sizedbox ignores size
    // already broke a monitor cuz of shitty ass flutter
    void setupLikeButton(var value) async {
      // recycling old code cuz why write new one 
      if(!ran){
      String username = await getUsername(api_token);
        if(value.contains("," + username)){
          print("e");
          setState(() {
            widget.isLiked = true;
            ran = true;
          });
        }
      }
    }
    Widget iconWidget1;
    if(widget.isLiked){
      iconWidget1 = Icon(Icons.thumb_up, color: primaryColor);
    }else{
      iconWidget1 = Icon(Icons.thumb_up_alt_outlined, color: primaryColor);
    }
    return FutureBuilder(
      future: getDesign(widget.designID, api_token),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          var responseData = jsonDecode(snapshot.data.body);
          designName = responseData["designName"];
          designAuthor = responseData["author"];
          properties = responseData["properties"]["print_areas"];
          thumbnailID = responseData["thumbnail_id"];
          setupLikeButton(responseData["liked_by"]);
          print(responseData);
          return Container(
            color: primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: getFromPercent("vertical", 6, context)),
              child: Column(
                children: [
                  Container(
                    width: getFromPercent("horizontal", 90, context),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Center(
                      child: Column(children: [
                        AutoSizeText(
                          designName,
                          style: TextStyle(
                            color: primaryColor,
                            decoration: TextDecoration.none,
                          ),
                          maxFontSize: getFromPercent("horizontal", 12, context).floorToDouble(),
                          minFontSize: getFromPercent("horizontal", 7, context).floorToDouble(),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          "By $designAuthor",
                          style: TextStyle(
                            color: primaryColor,
                            decoration: TextDecoration.none,
                          ),
                          maxFontSize: getFromPercent("horizontal", 6, context).floorToDouble(),
                          maxLines: 1,
                        )
                      ])
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: getFromPercent("vertical", 2, context)),
                    // VERY IMPORTANT DON'T REMOVE CONTAINER
                    // IT STRETCHES THE IMAGE HORIZONTALLY SO THAT IT
                    // ALIGNS WITH THE TEXT ABOVE IT
                    child: Container(
                      width: getFromPercent("horizontal", 90, context),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: ClipRRect(child: Image.network(apiIP + "/api/files/" + thumbnailID, height: getFromPercent("vertical", 65, context), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12.0), ),
                    ), 
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: getFromPercent("vertical", 2, context)),
                    child: Container(
                      width: getFromPercent("horizontal", 40, context),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child:Row(
                        children: [
                          TextButton(
                            child: iconWidget1, 
                            onPressed: (){
                              // liking logic
                              if(widget.isLiked){
                                  dislikeDesign(widget.designID, api_token, (bool result){
                                    if(result){
                                      setState(() {
                                        widget.isLiked = false;
                                      });
                                    }
                                  });
                              }else{
                                setState(() {
                                  likeDesign(widget.designID, api_token, (bool result){
                                    if(result){
                                      setState(() {
                                        widget.isLiked = true;
                                      });
                                    }
                                  });
                                });
                              }
                            },
                          ),
                          TextButton(
                            child: Text("Order", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 5, context), fontWeight: FontWeight.w600),),
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor
                            ),
                            onPressed: (){
                              print("b");
                              // TODO: ADD ORDERING LOGIC
                            },
                          ),
                        ],
                      )
                    )
                  )
                ]
              ), 
            ),
          );
        }else{
          return LoadingDots();
        }
      },
    );
  }
}