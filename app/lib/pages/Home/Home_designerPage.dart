// ignore_for_file: use_build_context_synchronously

import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import 'package:http/http.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'pages.dart';

// dirty solution to get the images to scale with the screen
// not proud of it, but it'l work
late BuildContext _listViewContext;
late String _selectedSize;
late String _selectedColor;
late List<dynamic> _variantsList;
class _EditPage extends StatefulWidget {
  const _EditPage({super.key});

  @override
  State<_EditPage> createState() => __EditPageState();
}

class __EditPageState extends State<_EditPage> {
  @override
  Widget build(BuildContext context) {
    print(_selectedColor);
    print(_selectedSize);
    return Container(
      color: secondaryColor,
    );
  }
}

class _ChoseVariantPage extends StatefulWidget {
  _ChoseVariantPage({super.key, this.blueprintID = 0});
  int blueprintID;
  @override
  State<_ChoseVariantPage> createState() => __ChoseVariantPageState();
}

class __ChoseVariantPageState extends State<_ChoseVariantPage> {
  @override
  List<String> colorDropdownItems = List<String>.empty(growable: true);
  late String colorDropdownValue;
  List<String> sizeDropdownItems = List<String>.empty(growable: true);
  late String sizeDropdownValue;

  @override
  int finishedLoading = 0;
  void initState() {
    get_variants(api_token, widget.blueprintID.toString(), (String res) async {
      if (res != "") {
        List<dynamic> variantList = jsonDecode(res);
        _variantsList = variantList;
        await Future.forEach(variantList, (value) async {
          if (!colorDropdownItems.contains(value[1])) {
            colorDropdownItems.add(value[1]);
          }
          if (!sizeDropdownItems.contains(value[2])) {
            sizeDropdownItems.add(value[2]);
          }
          debugPrint(value.toString());
        });
        colorDropdownValue = colorDropdownItems.first;
        sizeDropdownValue = sizeDropdownItems.first;
        setState(() {
          finishedLoading = 1;
        });
      } else {
        debugPrint("Res == ''");
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    if (finishedLoading == 0) {
      return LoadingDots(
        lightMode: false,
      );
    } else {
      return Material(
          child: Container(
              color: primaryColor,
              child: Center(
                  child: Container(
                height: getFromPercent("vertical", 25, context),
                width: getFromPercent("horizontal", 80, context),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text(
                      "Pick a color and size",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontSize: getFromPercent("horizontal", 8, context)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButton<String>(
                            items: colorDropdownItems
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600)),
                              );
                            }).toList(),
                            value: colorDropdownValue,
                            underline: SizedBox(),
                            dropdownColor: primaryColor,
                            iconEnabledColor: secondaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                colorDropdownValue = value!;
                              });
                              debugPrint(value);
                            },
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButton<String>(
                            items: sizeDropdownItems
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600)),
                              );
                            }).toList(),
                            value: sizeDropdownValue,
                            underline: SizedBox(),
                            dropdownColor: primaryColor,
                            iconEnabledColor: secondaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                sizeDropdownValue = value!;
                              });
                            },
                            )))),
                  TextButton(
                    onPressed: (){
                      _selectedColor = colorDropdownValue;
                      _selectedSize = sizeDropdownValue;
                      Navigator.push(context,animatedRoute(_EditPage()));
                    }, 
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Text("Next", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.w700, fontSize: getFromPercent("horizontal", 5, context)))
                  )
                ],
              ),
            )
          )
        )
      );
    }
  }
}

void _choseBlueprint(int printifyId, BuildContext context) async {
  Navigator.push(
      context,
      animatedRoute(_ChoseVariantPage(
        blueprintID: printifyId,
      )));
}

void _get_blueprints(Function callback) async {
  Response result = await get_blueprints(api_token);
  if (result.statusCode != 200) {
    print(result.statusCode);
  } else {
    List<Widget> resWidgetList = List.empty(growable: true);
    List<dynamic> blueprintList = jsonDecode(result.body);
    blueprintList.forEach((value) {
      if (value["images"][0] != null) {
        resWidgetList.add(_BlueprintWidget(
          printify_id: value["id"],
          title: value["title"],
          description: value["description"],
          image_link: value["images"][0],
        ));
      } else {
        resWidgetList.add(_BlueprintWidget(
          printify_id: value["id"],
          title: value["title"],
          description: value["description"],
        ));
      }
    });
    callback(resWidgetList);
  }
}

class DesignerPage extends StatefulWidget {
  const DesignerPage({super.key});

  @override
  State<DesignerPage> createState() => _DesignerPageState();
}

class _DesignerPageState extends State<DesignerPage> {
  Widget childWidget = LoadingDots(
    lightMode: true,
  );

  @override
  void initState() {
    // get all the blueprints from the API, then arrange them into rows and the rows into the ListView
    // also precache the images
    _get_blueprints((List<Widget> widgetList) async {
      List<Widget> tempChildWidgets = List.empty(growable: true);
      // ^ this is going to be the title after the animation is finished
      // it's a much cleaner solution to involve the title in the list view because
      // putting a list view in other widgets is much harder
      Widget tempWidget =
          Center(child: ListView(children: tempChildWidgets, shrinkWrap: true));
      List<Widget> reuseableList = List.empty(growable: true);
      // using a reusable list to store widgets until the row count is met, then store those in the form of
      // a row inside the tempChildWidgets list
      int rowCounter = 0;
      for (Widget element in widgetList) {
        if (rowCounter == 3) {
          tempChildWidgets.add(Row(
            children: List.from(reuseableList)
                .map((widget) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.5, vertical: 3),
                      child: widget,
                    ))
                .toList(),
          ));
          reuseableList.clear();
          rowCounter = 0;
        } else {
          reuseableList.add(element);
          rowCounter += 1;
        }
      }
      setState(() {
        childWidget = tempWidget;
      });
    });
    super.initState();
  }

  int animationState = 0;
  bool isDoneTyping = false;
  Widget build(BuildContext context) {
    _listViewContext = context;
    switch (animationState) {
      case 0:
        return AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            top: isDoneTyping
                ? getFromPercent("vertical", 6, context)
                : getFromPercent("vertical", 50, context),
            left: getFromPercent("horizontal", 6, context),
            onEnd: () {
              setState(() {
                animationState = 1;
              });
            },
            curve: Curves.fastOutSlowIn,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText("First you need to pick a blueprint to edit",
                    speed: const Duration(milliseconds: 45),
                    textStyle: TextStyle(
                        fontSize: getFromPercent("horizontal", 5, context),
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        decoration: TextDecoration.none,
                        backgroundColor: Colors.transparent)),
              ],
              totalRepeatCount: 1,
              repeatForever: false,
              pause: const Duration(milliseconds: 200),
              onFinished: () {
                setState(() {
                  isDoneTyping = true;
                });
              },
            ));
      case 1:
        return Stack(
          children: [
            childWidget,
            Positioned(
                top: getFromPercent("vertical", 5.3, context),
                left: getFromPercent("horizontal", 4.5, context),
                child: Container(
                    height: getFromPercent("vertical", 4, context),
                    width: getFromPercent("horizontal", 92, context),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: secondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: secondaryColor,
                    ),
                    child: Center(
                        child: Text(
                            "First you need to pick a blueprint to edit",
                            style: TextStyle(
                                fontSize:
                                    getFromPercent("horizontal", 5, context),
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                decoration: TextDecoration.none,
                                backgroundColor: Colors.transparent)))))
          ],
        );
    }
    return childWidget;
  }
}

class _BlueprintWidget extends StatefulWidget {
  _BlueprintWidget(
      {super.key,
      this.printify_id = 0,
      this.title = "Error",
      this.description = "Error",
      this.image_link =
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png"});
  int printify_id;
  String title;
  String description;
  String image_link;
  late Image theImage = Image.network(
    image_link,
    fit: BoxFit.fill,
    width: getFromPercent("horizontal", 29, _listViewContext),
    cacheWidth: 200,
    cacheHeight: 200,
  );
  @override
  State<_BlueprintWidget> createState() => __BlueprintWidgetState();
}

class __BlueprintWidgetState extends State<_BlueprintWidget> {
  @override
  void didChangeDependencies() async {
    precacheImage(widget.theImage.image, context);
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _choseBlueprint(widget.printify_id, context);
        },
        child: Container(
          height: getFromPercent("horizontal", 45, context),
          width: getFromPercent("vertical", 15, context),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: getFromPercent("horizontal", 40, context),
            width: getFromPercent("vertical", 15, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: getFromPercent("vertical", 1.1, context)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.theImage)),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: getFromPercent("vertical", 2, context)),
                  child: AutoSizeText(widget.title,
                      style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: getFromPercent("horizontal", 10, context)),
                      maxLines: 1,
                      maxFontSize: 30,
                      minFontSize: 10),
                )
              ],
            ),
          ),
        ));
  }
}
