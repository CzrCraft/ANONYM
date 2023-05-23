// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import 'package:http/http.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'pages.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:draggable_widget/draggable_widget.dart';
// dirty solution to get the images to scale with the screen
// not proud of it, but it'l work
late BuildContext _listViewContext;
late String _selectedSize;
late String _selectedColor;
late List<dynamic> _variantsList;
late int _maxFrontHeight;
late int _maxFrontWidth;

GlobalKey _editPageKey = GlobalKey();

List<Widget> _frontShirtImages = List.empty(growable: true);
List<GlobalKey<__shirtImageState>> _frontShirtImageKeys = List.empty(growable: true);
List<Widget> _backShirtImages = List.empty(growable: true);
List<GlobalKey<__shirtImageState>> _backShirtImageKeys = List.empty(growable: true);

void _updateSelectedImage(Widget img, bool frontImages){
  if(frontImages){
    _frontShirtImageKeys.forEach((GlobalKey<__shirtImageState> element) {
      if(element.currentWidget == img){
        element.currentState?.select();
      }else{
        element.currentState?.deselect();
      }
    });
  }
}

void _removeImage(Widget image, bool frontImages){
  if(frontImages){
    _frontShirtImages.remove(image);
    _frontShirtImageKeys.remove(image.key);
    _editPageKey.currentState?.setState(() {
      
    });
  }
}

class _shirtImage extends StatefulWidget {
  _shirtImage(this.imgX, this.imgY, this.imgId, this.image,{super.key});
  double imgX;
  double imgY;
  String imgId;
  Widget image;
  bool selected = false;
  @override
  State<_shirtImage> createState() => __shirtImageState();
}

class __shirtImageState extends State<_shirtImage> {
  @override


  void _onHorizontalDragStartHandler(DragStartDetails details) {
    setState(() {
      widget.imgX = details.globalPosition.dx.floorToDouble();
      widget.imgY = getFromPercent("vertical", 45, context) - details.globalPosition.dy.floorToDouble();
    });
  }

  /// Track starting point of a vertical gesture
  void _onVerticalDragStartHandler(DragStartDetails details) {
    setState(() {
      widget.imgX = details.globalPosition.dx.floorToDouble();
      widget.imgY = getFromPercent("vertical", 45, context) - details.globalPosition.dy.floorToDouble();
    });
  }

  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      widget.imgX = details.globalPosition.dx.floorToDouble();
      widget.imgY = getFromPercent("vertical", 45, context) - details.globalPosition.dy.floorToDouble();
    });
  }

  /// Track current point of a gesture
  void _onHorizontalDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      widget.imgX = details.globalPosition.dx.floorToDouble();
      widget.imgY = getFromPercent("vertical", 45, context) - details.globalPosition.dy.floorToDouble();
    });
  }

  /// Track current point of a gesture
  void _onVerticalDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      widget.imgX = details.globalPosition.dx.floorToDouble();
      widget.imgY = getFromPercent("vertical", 45, context) - details.globalPosition.dy.floorToDouble();
    });
  }

  Widget build(BuildContext context) {
    debugPrint(widget.imgX.toString());
    debugPrint(widget.imgY.toString());
    if(!widget.selected){
      return Positioned(
        bottom: widget.imgY,
        left: widget.imgX,
        child: GestureDetector(
          onTap: (){
            setState(() {
              _updateSelectedImage(widget , true);
            });
          },
          behavior: HitTestBehavior.translucent,
          child: widget.image,
        ),
      );
    }else{
      return Positioned(
        bottom: widget.imgY,
        left: widget.imgX,
        child: GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStartHandler,
          onVerticalDragStart: _onVerticalDragStartHandler,
          onHorizontalDragUpdate: _onDragUpdateHandler,
          onVerticalDragUpdate: _onDragUpdateHandler,
          onLongPress: (){
              setState(() {
                _removeImage(widget, true);
                debugPrint("e");
              });
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(getFromPercent("horizontal", 1, context)),
              child: widget.image,
            ),
          ),
        ),
      );
    }
  
  }
  void select(){
    setState(() {
      widget.selected = true;
    });
  }
  void deselect(){
    setState(() {
      widget.selected = false;
    });
  }
  String getID(){
    return widget.imgId;
  }
}

class _EditPage extends StatefulWidget {
  _EditPage({super.key});
  @override
  State<_EditPage> createState() => __EditPageState();
}

class __EditPageState extends State<_EditPage> {
  @override

  @override
  void initState() {
    _frontShirtImages.clear();
    _backShirtImages.clear();
    super.initState();
  }

  Widget getImageToUse(String value, bool detectGestures, {key}){
    if(detectGestures){
      if(key != null){
        return GestureDetector(child: Image.network(apiIP + "/api/files/" + value, width: getFromPercent("horizontal", 20, context), height: getFromPercent("vertical", 10, context), fit: BoxFit.cover, key: key), onLongPress: (){pickedImage(value);},);
      }else{
        return GestureDetector(child: Image.network(apiIP + "/api/files/" + value, width: getFromPercent("horizontal", 20, context), height: getFromPercent("vertical", 10, context), fit: BoxFit.cover), onLongPress: (){pickedImage(value);},);
      }
    }else{
      if(key != null){
        return Image.network(apiIP + "/api/files/" + value, width: getFromPercent("horizontal", 20, context), height: getFromPercent("vertical", 10, context), fit: BoxFit.cover, key: key);
      }else{
        return Image.network(apiIP + "/api/files/" + value, width: getFromPercent("horizontal", 20, context), height: getFromPercent("vertical", 10, context), fit: BoxFit.cover);
      }
    }
  }

  void pickedImage(String imageId){
    if(shirtSide == 0){
      setState(() {
        GlobalKey<__shirtImageState> tempKey = GlobalKey();
        _frontShirtImages.add(_shirtImage(getFromPercent("horizontal", 35, context), getFromPercent("vertical", 20, context), imageId, getImageToUse(imageId, false), key: tempKey));
        _frontShirtImageKeys.add(tempKey);
      });
    }else if (shirtSide == 1){
      setState(() {
        GlobalKey<__shirtImageState> tempKey = GlobalKey();
        _backShirtImages.add(_shirtImage(0, 0, imageId, getImageToUse(imageId, false), key: tempKey));
        _backShirtImageKeys.add(tempKey);
      });
    }
  }

  int shirtSide = 0;
  late Widget shirtImage;
  Widget build(BuildContext context) {
    print(_selectedColor);
    print(_selectedSize);
    List<Widget> tempList = List.empty(growable: true);
    if(shirtSide == 0){
      tempList.add(IgnorePointer(child: Image.asset('assets/graphics/shirt_front_no_bg.png')));
      tempList.addAll(_frontShirtImages);
      shirtImage = Stack(
        clipBehavior: Clip.antiAlias,
        children: tempList
      );
    }else{
      tempList.addAll(_backShirtImages);
      tempList.add(Image.asset('assets/graphics/shirt_back_no_bg.png'));
      shirtImage = Stack(
        children: tempList,
        clipBehavior: Clip.none
      );
    }
    return Material(child: Container(
      color: primaryColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: getFromPercent("vertical", 5, context)),
            child: Container(
              height: getFromPercent("vertical", 45, context),
              width: getFromPercent("horizontal", 95, context),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(7)
              ),
              child: shirtImage
            ), 
          ),
          Padding(
            padding: EdgeInsets.only(top: getFromPercent("vertical", 2, context)),
            child: Container(
              height: getFromPercent("vertical", 45, context),
              width: getFromPercent("horizontal", 95, context),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Padding(
                padding: EdgeInsets.only(top: getFromPercent("vertical", 0.5, context)),
                child: ContainedTabBarView(
                  tabs: [
                    Tab(
                      child: Text("Upload", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.w600))
                    ),
                    Tab(
                      child: Text("Cloud", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.w600))
                    )
                  ],
                  views: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text("Upload an image", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 5, context))),
                            onPressed: ()async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image
                              );
                              if (result != null) {
                                sendFileToApi(result.files.first.path!, api_token, (){
                                  setState(() {});
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor
                            ),
                          ),
                          TextButton(
                            child: Text("Publish your design", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 8, context))),
                            onPressed: ()async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image
                              );
                              if (result != null) {
                                sendFileToApi(result.files.first.path!, api_token, (){
                                  setState(() {});
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor
                            ),
                          ),
                        ]
                      )
                    ),
                    FutureBuilder(
                      future: getUsersFilesFromApi(api_token),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        List<Widget> childWidgets = List.empty(growable: true);
                        if(snapshot.hasData){
                          int temp = 1;
                          List<Widget> tempRow = List.empty(growable: true);
                          int maxImages = 5;
                          bool didFirstRow = false;
                          for(String value in snapshot.data!.body.split(",")){
                            debugPrint(temp.toString());
                            if(temp >= maxImages){
                              if(didFirstRow == false){
                                temp = 1;
                                childWidgets.add(Row(children: tempRow.toList()));
                                tempRow.clear();
                                tempRow.add(getImageToUse(value, true));
                                didFirstRow = true;
                                maxImages -= 1;
                              }else {
                                temp = 1;
                                childWidgets.add(Row(children: tempRow.toList()));
                                tempRow.clear();
                                tempRow.add(getImageToUse(value, true));
                              }
                              
                            }else{
                              tempRow.add(getImageToUse(value, true));
                              temp += 1;
                            }
                          }
                          debugPrint("a " + temp.toString());
                          if(temp <= maxImages){
                            childWidgets.add(Row(children: tempRow.toList()));
                          }
                          return Center(child: ListView(children: childWidgets, padding: EdgeInsets.symmetric(horizontal: getFromPercent("horizontal", 7, context))));
                        }else{
                          return LoadingDots(lightMode: true,);
                        }
                      },
                      key: GlobalKey() 
                    )
                  ],
                  tabBarProperties: TabBarProperties(
                    background: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(11)
                      ),
                    ),
                    width: getFromPercent("horizontal", 93, context),
                    height: getFromPercent("vertical", 4.5, context),
                    indicatorColor: secondaryColor,
                    indicatorPadding: EdgeInsets.all(1),
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                )
              )
            ), 
          ),
        ],
      )
    ));
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
  int maxFrontHeight = 1000000000;
  int maxFrontWidth = 1000000000;
  @override
  int finishedLoading = 0;
  void initState() {
    get_variants(api_token, widget.blueprintID.toString(), (String res) async {
      if (res != "") {
        // response is gonna be [id, color, size, canPrintOnTheFront, canPrintOnTheBack, frontHeight, frontWidth, backHeight, backWidth]
        List<dynamic> variantList = jsonDecode(res);
        _variantsList = variantList;
        await Future.forEach(variantList, (value) async {
          if(value[6] < maxFrontHeight){
            maxFrontHeight = value[6];
          }
          if(value[7] < maxFrontWidth){
            maxFrontHeight = value[7];
          }
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
        _maxFrontHeight = maxFrontHeight;
        _maxFrontWidth = maxFrontWidth;
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
                      padding: EdgeInsets.symmetric(vertical: getFromPercent("vertical", 0.5, context)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: getFromPercent("vertical", 0.5, context)),
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
                      padding: EdgeInsets.symmetric(vertical: getFromPercent("vertical", 0.5, context)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: getFromPercent("vertical", 0.5, context)),
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
                      _editPageKey = GlobalKey();
                      Navigator.push(context,animatedRoute(_EditPage(key: _editPageKey,)));
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
                      padding: EdgeInsets.symmetric(
                          horizontal: getFromPercent("horizontal", 0.3, _listViewContext), vertical: getFromPercent("horizontal", 0.7, _listViewContext)),
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
    setThemeColors(false);
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
