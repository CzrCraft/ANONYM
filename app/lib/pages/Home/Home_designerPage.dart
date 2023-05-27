// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, override_on_non_overriding_member
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import 'package:http/http.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Stylr/pages.dart';
// dirty solution to get the images to scale with the screen
// not proud of it, but it'l work
late BuildContext _listViewContext;
late String _selectedSize;
late String _selectedColor;
late List<dynamic> _variantsList;
late int _maxFrontHeight;
late int _maxFrontWidth;
late int _blueprintID;
late int _selectedPrintProvider;
GlobalKey _editPageKey = GlobalKey();

List<Widget> _frontShirtImages = List.empty(growable: true);
List<GlobalKey<__shirtImageState>> _frontShirtImageKeys = List.empty(growable: true);
List<Widget> _backShirtImages = List.empty(growable: true);
List<GlobalKey<__shirtImageState>> _backShirtImageKeys = List.empty(growable: true);

void clearAll(){
  _selectedColor = "";
  _selectedSize = "";
  _variantsList.clear();
  _maxFrontHeight = 0;
  _maxFrontWidth = 0;
  _blueprintID = 0;
  _selectedPrintProvider = 0;
  _editPageKey = GlobalKey();
  _frontShirtImageKeys.clear();
  _backShirtImageKeys.clear();
  _frontShirtImages.clear();
  _backShirtImages.clear();
}

_updateAnImage(String property, double value, GlobalKey<__shirtImageState> imgKey){
  switch(property){
    case "scale":
      imgKey.currentState!.setScale(imgKey.currentState!.getScale() + value);
      break;
    case "posX":
      imgKey.currentState!.setX(imgKey.currentState!.getX() + value);
      break;
    case "posY":
      imgKey.currentState!.setY(imgKey.currentState!.getY() + value);
      break;
  }
}

GlobalKey<__shirtImageState>? _getSelectedImage(){
  for(GlobalKey<__shirtImageState> element in _frontShirtImageKeys) {
    if(element.currentState!.isSelected()){
      return element;
    }
  }
  return null;
}

void _updateSelectedImage(Widget img, bool frontImages, BuildContext context){
  if(frontImages){
    _frontShirtImageKeys.forEach((GlobalKey<__shirtImageState> element) {
      if(element.currentWidget == img){
        element.currentState?.select();
      }else{
        if(element.currentState!.isSelected() == true){
          element.currentState?.deselect();
        }
      }
    });
  }
}

void _removeImage(Widget image, bool frontImages){
  if(frontImages){
    _frontShirtImages.remove(image);
    _frontShirtImageKeys.remove(image.key);
    // ignore: invalid_use_of_protected_member
    _editPageKey.currentState?.setState(() {
      
    });
  }
}

class _customImage extends StatefulWidget {
  _customImage({required this.imgKey, required this.imgID, super.key});
  //Image.network(apiIP + "/api/files/" + value, width: getFromPercent("horizontal", 20, context), height: getFromPercent("vertical", 10, context), fit: BoxFit.cover, key: key);
  double scale = 0.2;
  double orgHeight = 200;
  double orgWidth = 200;
  String imgID;
  GlobalKey imgKey;
  @override
  State<_customImage> createState() => __customImageState();
}

class __customImageState extends State<_customImage> {
  @override
  GlobalKey childKey = GlobalKey();
  late Image childImage = Image.network(apiIP + "/api/files/" + widget.imgID,scale: widget.scale, key: childKey,);
  void initState() {
    widget.orgHeight = childImage.height!;
    widget.orgWidth = childImage.height!;
    super.initState();
  }
  @override
  void setScale(double newScale){
    setState(() {
      widget.scale = newScale;
      print(newScale);
      childKey.currentState!.setState(() {
        print("something");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return childImage;
  }
}

class _shirtImage extends StatefulWidget {
  _shirtImage(this.imageKey, this.imgX, this.imgY, this.imgID, this.image,{super.key});
  double imgX;
  double imgY;
  String imgID;
  Widget image;
  GlobalKey<__customImageState> imageKey;
  double scale = 9;
  bool selected = false;
  @override
  State<_shirtImage> createState() => __shirtImageState();
}

class __shirtImageState extends State<_shirtImage> {
  @override
  Widget build(BuildContext context) {
    widget.image = Image.network(apiIP + "/api/files/" + widget.imgID, scale: widget.scale);
    debugPrint(widget.imgX.toString());
    debugPrint(widget.imgY.toString());
    if(!widget.selected){
      return Positioned(
        bottom: widget.imgY,
        left: widget.imgX,
        child: GestureDetector(
          onTap: (){
            setState(() {
              _updateSelectedImage(widget , true, context);
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
          onLongPress: (){
              setState(() {
                _removeImage(widget, true);
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
  double getScale(){
    return widget.scale;
  }
  void setScale(double newScale){
    setState(() {
      widget.scale = newScale;
    });
  }
  double getX(){
    return widget.imgX;
  }
  double getY(){
    return widget.imgY;
  }
  void setX(double newX){
    setState(() {
      widget.imgX = newX;
    });
  }
  void setY(double newY){
    setState(() {
      widget.imgY = newY;
    });
  }
  void select(){
    setState(() {
      setX(getX() - getFromPercent("horizontal", 0.5, context));
      setY(getY() - getFromPercent("horizontal", 0.5, context));
      widget.selected = true;
    });
  }
  void deselect(){
    setState(() {
      setX(getX() + getFromPercent("horizontal", 0.5, context));
      setY(getY() + getFromPercent("horizontal", 0.5, context));
      widget.selected = false;
    });
  }
  bool isSelected(){
    return widget.selected;
  }
  String getID(){
    return widget.imgID;
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
    _frontShirtImageKeys.clear();
    _backShirtImages.clear();
    _backShirtImageKeys.clear();
    super.initState();
  }

  void handleEditActions(String action){
    double moveUp = 5;
    double moveSide = 5;
    double scaleRatio = 0.7;
    switch(action){
      case "up":
        if(_getSelectedImage() != null){
          _updateAnImage("posY", moveUp, _getSelectedImage()!);
        }
        break;
      case "down":
        if(_getSelectedImage() != null){
          _updateAnImage("posY", -moveUp, _getSelectedImage()!);
        }
        break;
      case "left":
        if(_getSelectedImage() != null){
          _updateAnImage("posX", -moveSide, _getSelectedImage()!);
        }
        break;
      case "right":
        if(_getSelectedImage() != null){
          _updateAnImage("posX", moveSide, _getSelectedImage()!);
        }
        break;
      case "scaleUp":
        if(_getSelectedImage() != null){
          _updateAnImage("scale", -scaleRatio, _getSelectedImage()!);
        }
        break;
      case "scaleDown":
        if(_getSelectedImage() != null){
          _updateAnImage("scale", scaleRatio, _getSelectedImage()!);
        }
        break;
    }
  }

  Widget getImageToUse(String value, bool detectGestures, {dontScale = false, key}){
    if(value != ""){
      if(!dontScale){
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
      }else{
        if(detectGestures){
          if(key != null){
            return GestureDetector(child: Image.network(apiIP + "/api/files/" + value, key: key), onLongPress: (){pickedImage(value);},);
          }else{
            return GestureDetector(child: Image.network(apiIP + "/api/files/" + value), onLongPress: (){pickedImage(value);},);
          }
        }else{
          if(key != null){
            return _customImage(imgID: value, key: key, imgKey: GlobalKey(),);
          }else{
            return _customImage(imgID: value, imgKey: GlobalKey(),);
          }
        }
      }

    }else{
      return Container();
    }
  }

  void pickedImage(String imageId){
    if(shirtSide == 0){
      setState(() {
        GlobalKey<__shirtImageState> tempKey = GlobalKey();
        GlobalKey<__customImageState> imgKey = GlobalKey();
        _frontShirtImages.add(_shirtImage(imgKey, getFromPercent("horizontal", 35, context), getFromPercent("vertical", 20, context), imageId, getImageToUse(imageId, false, dontScale: true, key: imgKey), key: tempKey));
        _frontShirtImageKeys.add(tempKey);
      });
    }else if (shirtSide == 1){
      setState(() {
        GlobalKey<__shirtImageState> tempKey = GlobalKey();
        GlobalKey<__customImageState> imgKey = GlobalKey();
        _backShirtImages.add(_shirtImage(imgKey, 0, 0, imageId, getImageToUse(imageId, false), key: tempKey));
        _backShirtImageKeys.add(tempKey);
      });
    }
  }

  int shirtSide = 0;
  late Widget shirtImage;
  late Size widgetSize;
  Widget build(BuildContext context) {
  void getWidgetSize(){
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      widgetSize = size;
    }
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
              child: Center(child: shirtImage)
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
                    ),
                    Tab(
                      child: Text("Edit", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.w600))
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
                                  setState(() {
                                    showDialog(context: context, 
                                    builder: (context) => 
                                      AlertDialog(
                                        title: Text("Uploaded your image!", style: TextStyle(color: primaryColor),),
                                        backgroundColor: secondaryColor,
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Ok'),
                                            child: Text('Ok', style: TextStyle(color: primaryColor)),
                                          ),
                                        ],
                                      )
                                    );
                                  });
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
                              getWidgetSize();
                              Map<String, String> designHeaders = {};
                              designHeaders["print_provider"] = _selectedPrintProvider.toString();
                              designHeaders["blueprint_id"] = _blueprintID.toString();
                              for(var variant in _variantsList){
                                if(variant[1] == _selectedColor && variant[2] == _selectedSize){
                                  designHeaders["variant_id"] = variant[0].toString();
                                }
                              }
                              Map<String, dynamic> designBody = {};
                              List<dynamic> printAreas = List.empty(growable: true);
                              final myController = TextEditingController(); 
                              showDialog(
                                context: context, 
                                builder: (context) => AlertDialog(
                                  title: Text("Please enter a name for your design", style: TextStyle(color: primaryColor),),
                                  content: TextFormField(
                                    controller: myController, 
                                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2.5)),
                                    ),
                                    cursorColor: primaryColor,
                                  ),
                                  backgroundColor: secondaryColor,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        designHeaders["design_name"] = myController.text;
                                        Navigator.pop(context, 'Submit');
                                        showDialog(
                                        context: context, 
                                        builder: (context) => AlertDialog(
                                          title: Text("Please upload a thumbnail", style: TextStyle(color: primaryColor),),
                                          backgroundColor: secondaryColor,
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  type: FileType.image
                                                );
                                                if (result != null) {
                                                  sendFileToApi(result.files.first.path!, api_token, returnToken: true, (String fileID){
                                                    designHeaders["thumbnail"] = fileID;
                                                    setState(() {
                                                      showDialog(context: context, 
                                                      builder: (context) => 
                                                        AlertDialog(
                                                          title: Text("Uploaded your image!", style: TextStyle(color: primaryColor),),
                                                          backgroundColor: secondaryColor,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () async {
                                                                double orgWidth = widgetSize.width;
                                                                double orgHeight = widgetSize.height;
                                                                bool elementsPresent = false;
                                                                for(GlobalKey<__shirtImageState> element in _frontShirtImageKeys){
                                                                  elementsPresent = true;
                                                                  if(element.currentState!.isSelected()){
                                                                    element.currentState!.deselect();
                                                                  }
                                                                  printAreas.add({
                                                                    "src": element.currentState!.getID(), 
                                                                    "scale": element.currentState!.getScale(),
                                                                    "x": element.currentState!.getX() / orgWidth,
                                                                    "y": element.currentState!.getY() / orgHeight,
                                                                  });
                                                                }
                                                                designBody["print_areas"] = Map<String, dynamic>.from({"front": printAreas});
                                                                if(elementsPresent){
                                                                  designBody["orgHeight"] = orgHeight;
                                                                  designBody["orgWidth"] = orgWidth;
                                                                  if(await sendDesignToApi(headers: designHeaders, designBody: designBody, securityToken: api_token)){
                                                                    Navigator.pop(context, 'Ok');
                                                                    showDialog(context: context, 
                                                                      builder: (context) => AlertDialog(
                                                                        title: Text("Published your design!", style: TextStyle(color: primaryColor),),
                                                                        backgroundColor: secondaryColor,
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              clearAll();
                                                                              Navigator.pop(context, 'Hooray');
                                                                              Navigator.push(context, animatedRoute(HomePage(0)));
                                                                            },
                                                                            child: Text('Hooray', style: TextStyle(color: primaryColor)),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    );
                                                                  }else{
                                                                    Navigator.pop(context, 'Ok');
                                                                    showDialog(context: context, 
                                                                      builder: (context) => AlertDialog(
                                                                        title: Text("Something went wrong", style: TextStyle(color: primaryColor),),
                                                                        backgroundColor: secondaryColor,
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.pop(context, 'Ok');
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              Navigator.push(context, animatedRoute(new HomePage(0)));
                                                                            },
                                                                            child: Text('Ok', style: TextStyle(color: primaryColor)),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    );
                                                                  }
                                                                }else{
                                                                  Navigator.pop(context, 'Ok');
                                                                  showDialog(context: context, 
                                                                    builder: (context) => AlertDialog(
                                                                      title: Text("Please add something to the design before publishing!", style: TextStyle(color: primaryColor),),
                                                                      backgroundColor: secondaryColor,
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context, 'Ok');
                                                                          },
                                                                          child: Text('Ok', style: TextStyle(color: primaryColor)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  );
                                                                }
                                                              },
                                                              child: Text('Ok', style: TextStyle(color: primaryColor)),
                                                            ),
                                                          ],
                                                        )
                                                      );
                                                    });
                                                  });
                                                }
                                                Navigator.pop(context, 'Upload');
                                              },
                                              child: Text('Upload', style: TextStyle(color: primaryColor)),
                                            ),
                                          ],
                                        )
                                      );
                                      },
                                      child: Text('Submit', style: TextStyle(color: primaryColor)),
                                    ),
                                  ],
                                )
                              );
                              
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
                    ),
                    Stack(
                        children: [ 
                          Positioned(
                            bottom: getFromPercent("vertical", 26, context),
                            left: getFromPercent("horizontal", 38, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("up");
                              },
                              child: Icon(Icons.keyboard_arrow_up, color: secondaryColor, size: getFromPercent("horizontal", 12, context),),
                            ),
                          ),
                          Positioned(
                            bottom: getFromPercent("vertical", 8, context),
                            left: getFromPercent("horizontal", 38, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("down");
                              },
                              child: Icon(Icons.keyboard_arrow_down, color: secondaryColor, size: getFromPercent("horizontal", 12, context),),
                            ),
                          ),
                          Positioned(
                            bottom: getFromPercent("vertical", 17, context),
                            left: getFromPercent("horizontal", 58, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("right");
                              },
                              child: Icon(Icons.keyboard_arrow_right, color: secondaryColor, size: getFromPercent("horizontal", 12, context),),
                            ),
                          ),
                          Positioned(
                            bottom: getFromPercent("vertical", 17, context),
                            left: getFromPercent("horizontal", 18, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("left");
                              },
                              child: Icon(Icons.keyboard_arrow_left, color: secondaryColor, size: getFromPercent("horizontal", 12, context),),
                            ),
                          ),
                          Positioned(
                            bottom: getFromPercent("vertical", 30, context),
                            left: getFromPercent("horizontal", 4, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("scaleDown");
                              },
                              child: Text("-", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 10, context),)),
                            ),
                          ),
                          Positioned(
                            bottom: getFromPercent("vertical", 30, context),
                            left: getFromPercent("horizontal", 73, context),
                            child: TextButton(
                              style:TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: secondaryColor,
                              ),
                              onPressed: (){
                                handleEditActions("scaleUp");
                              },
                              child: Text("+", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 10, context),)),
                            ),
                          ),
                        ],
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
  int printProviderID = 0;
  int maxFrontHeight = 1000000000;
  int maxFrontWidth = 1000000000;
  @override
  int finishedLoading = 0;
  void initState() {
    _blueprintID = widget.blueprintID;
    get_variants(api_token, widget.blueprintID.toString(), (String res) async {
      if (res != "") {
        // response is gonna be [id, color, size, canPrintOnTheFront, canPrintOnTheBack, frontHeight, frontWidth, backHeight, backWidth, printProviderId]
        List<dynamic> variantList = jsonDecode(res);
        _variantsList = variantList;
        int maxIterations = _variantsList.length;
        int _i = 0;
        for(dynamic value in variantList){
          if(_i < maxIterations){
            printProviderID = value[9];
            if(value[5] < maxFrontHeight){
              maxFrontHeight = value[5];
            }
            if(value[6] < maxFrontWidth){
              maxFrontHeight = value[6];
            }
            if (!colorDropdownItems.contains(value[1])) {
              colorDropdownItems.add(value[1]);
            }
            if (!sizeDropdownItems.contains(value[2])) {
              sizeDropdownItems.add(value[2]);
            }
          }else{
            
          }
        }
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
                      _selectedPrintProvider = printProviderID;
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
