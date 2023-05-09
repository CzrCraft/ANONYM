import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import 'package:http/http.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'pages.dart';

class _EditPage extends StatefulWidget {
  const _EditPage({super.key});

  @override
  State<_EditPage> createState() => __EditPageState();
}

class __EditPageState extends State<_EditPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        children: [
          
        ],
      )
    );
  }
}

void _choseBlueprint(int printify_id, BuildContext context) async {
  debugPrint("$printify_id");
  debugPrint((await get_blueprint(api_token, printify_id.toString())).body);
  Navigator.push(context, animatedRoute(const _EditPage()));
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
      // ^ this is going to be the title after the animation is finnished
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
    width: 120,
    cacheWidth: 100,
    cacheHeight: 100,
  );
  @override
  State<_BlueprintWidget> createState() => __BlueprintWidgetState();
}

class __BlueprintWidgetState extends State<_BlueprintWidget> {
  @override
  void didChangeDependencies() {
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
