// ignore_for_file: sort_child_properties_last

import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'utilities.dart';
import 'pages.dart';
import 'package:flutter/scheduler.dart';

int _resultState = 0;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  int animationStage = 0;
  String username = "";
  String password = "";
  late Ticker _ticker;
  @override
  void initState() {
    super.initState();
    _resultState = 0;
    // this callback func is going to be called every time flutter renders a new frame
    // all it does is check if you have signed in succsesfully
    // and if so switch to the next page and terminate the ticker
    _ticker = super.createTicker((Duration elapsedTime) {
      if (_resultState == 1) {
        _ticker.stop();
        writeValue("apiToken", api_token);
        Navigator.push(context, animatedRoute(new HomePage(0)));
      } else if (_resultState == 2) {
        try {
          // this is to avoid crashing the app if it can't pop the widget
          if (Navigator.canPop(context)) {
            showDialog(context: context, 
              builder: (context) => AlertDialog(
                title: Text("The users already exists", style: TextStyle(color: primaryColor),),
                backgroundColor: secondaryColor,
                actions: [
                  TextButton(
                    onPressed: () {
                      _ticker.stop();
                      Navigator.pop(context, 'Ok');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Ok', style: TextStyle(color: primaryColor)),
                  ),
                ],
              )
            );
          }
        } catch (err) {
          print(err);
        }
      }
      // this is to make sure that it doesnt go to that page twice
      _resultState = 0;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (animationStage == 0) {
      Future.delayed(const Duration(milliseconds: 455), () {
        setState(() {
          animationStage =
              1; // delay so that the animation waits for the circle transition to finnish
        });
      });
    }

    switch (animationStage) {
      case 1:
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              AnimatedTextKit(
                key: GlobalKey(),
                animatedTexts: [
                  TyperAnimatedText("First off, we need your username",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: getFromPercent("horizontal", 5, context),
                          color: secondaryColor,
                          decoration: TextDecoration.none)),
                ],
                totalRepeatCount: 1,
                onFinished: () {
                  setState(() {
                    animationStage = 2;
                  });
                },
                repeatForever: false,
                pause: const Duration(milliseconds: 20),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      case 2:
        TextEditingController textFieldController = TextEditingController();
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              Text("First off, we need your username",
                  style: TextStyle(
                      fontSize: getFromPercent("horizontal", 5, context),
                      color: secondaryColor,
                      decoration: TextDecoration.none)),
              Padding(
                  child: Stack(
                    children: [
                      Material(
                        child: TextField(
                          controller: textFieldController,
                          decoration: InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            fillColor: primaryColor,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            hintText: "Type here...",
                            hintStyle: TextStyle(color: secondaryColor.withOpacity(0.5)),
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.send, color: secondaryColor),
                              onTap: (){
                                // copy and pasting code :)
                                // NOT FROM STACK OVERFLOW💀💀
                                String input = textFieldController.text;
                                input = input.trim();
                                if (input != "") {
                                  setState(() {
                                    print(input);
                                    username = input;
                                    animationStage = 3;
                                  });
                                  setState(() {
                                    animationStage = 3;
                                  });
                                }
                              },
                            )
                          ),
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.center,
                          cursorColor: secondaryColor,
                          maxLength: 20,
                          onSubmitted: (String input) {
                            input = input.trim();
                            if (input != "") {
                              setState(() {
                                print(input);
                                username = input;
                                animationStage = 3;
                              });
                              setState(() {
                                animationStage = 3;
                              });
                            }
                          },
                          buildCounter: (
                            BuildContext context, {
                            required int currentLength,
                            int? maxLength,
                            required bool isFocused,
                          }) =>
                              null,
                          style: TextStyle(
                              backgroundColor: primaryColor,
                              color: secondaryColor,
                              fontSize:
                                  getFromPercent("horizontal", 6, context)),
                          showCursor: false,
                        ),
                        borderOnForeground: false,
                      ),
                      Positioned(
                        child: IgnorePointer(
                            child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText("........................",
                                speed: const Duration(milliseconds: 45),
                                textStyle: TextStyle(
                                    fontSize: getFromPercent(
                                        "horizontal", 7, context),
                                    color: secondaryColor,
                                    decoration: TextDecoration.none,
                                    backgroundColor: Colors.transparent)),
                          ],
                          totalRepeatCount: 1,
                          repeatForever: false,
                          pause: const Duration(milliseconds: 1100),
                        )),
                        top: getFromPercent("vertical", 2.7, context),
                        left: getFromPercent("horizontal", 2.6, context),
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(
                      top: getFromPercent("vertical", 1.1, context))),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      case 3:
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText("Okay, now you need to set your password.",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: getFromPercent("horizontal", 4, context),
                          color: secondaryColor,
                          decoration: TextDecoration.none)),
                ],
                totalRepeatCount: 1,
                onFinished: () {
                  setState(() {
                    animationStage = 4;
                  });
                },
                repeatForever: false,
                pause: const Duration(milliseconds: 0),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      case 4:
        TextEditingController textFieldController = TextEditingController();
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              Text("Okay, now you need to set your password.",
                  style: TextStyle(
                      fontSize: getFromPercent("horizontal", 4, context),
                      color: secondaryColor,
                      decoration: TextDecoration.none)),
              Padding(
                  child: Stack(children: [
                    Material(
                      child: TextField(
                        controller: textFieldController,
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          fillColor: primaryColor,
                          hoverColor: secondaryColor,
                          focusColor: secondaryColor,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintText: "Type here...",
                          hintStyle: TextStyle(color: secondaryColor.withOpacity(0.5)),
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.send, color: secondaryColor),
                            onTap: (){
                              // copy and pasting code :)
                              // NOT FROM STACK OVERFLOW💀💀
                              String input = textFieldController.text;
                              input = input.trim();
                              if (input != "") {
                                setState(() {
                                  password = input;
                                  animationStage = 5;
                                });
                                setState(() {
                                  animationStage = 5;
                                });
                              }
                            },
                          )
                        ),
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.center,
                        cursorColor: secondaryColor,
                        maxLength: 20,
                        onSubmitted: (String input) {
                          input = input.trim();
                          if (input != "") {
                            setState(() {
                              password = input;
                              animationStage = 5;
                            });
                            setState(() {
                              animationStage = 5;
                            });
                          }
                        },
                        buildCounter: (
                          BuildContext context, {
                          required int currentLength,
                          int? maxLength,
                          required bool isFocused,
                        }) =>
                            null,
                        style: TextStyle(
                            backgroundColor: primaryColor,
                            color: secondaryColor,
                            fontSize: getFromPercent("horizontal", 6, context)),
                        showCursor: false,
                      ),
                      borderOnForeground: false,
                    ),
                    Positioned(
                        child: IgnorePointer(
                            child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText("........................",
                                speed: const Duration(milliseconds: 45),
                                textStyle: TextStyle(
                                    fontSize: getFromPercent(
                                        "horizontal", 7, context),
                                    color: secondaryColor,
                                    decoration: TextDecoration.none,
                                    backgroundColor: Colors.transparent)),
                          ],
                          totalRepeatCount: 1,
                          repeatForever: false,
                          pause: const Duration(milliseconds: 1100),
                        )),
                        top: getFromPercent("vertical", 2.2, context),
                        left: getFromPercent("horizontal", 2.6, context))
                  ]),
                  padding: EdgeInsets.only(
                      top: getFromPercent("horizontal", 2.6, context))),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
        
      case 5:
        try {
          return _SignUp(username, password);
        } catch (err) {
          print(err);
          return LoadingDots();
        }
    }
    return Container(color: primaryColor);
  }
}

//i use this method of signing up because including the FutureBuilder inside the SignUpPage widget will
//cause a bug where the Future(signUp()) will get called mutliple times solicting the api too much
//and i can't declare the Future in initState() because the signUp() function reuqires a username and password
//that are acquired later
//so i use this seperate local widget that i declare the Future inside its initState() function
//avoiding this weird bug.
//TODO: add error messages for signing up
class _SignUp extends StatefulWidget {
  final String username;
  final String password;
  _SignUp(this.username, this.password, {super.key});

  @override
  State<_SignUp> createState() => __SignUpState();
}

class __SignUpState extends State<_SignUp> {
  late Future signupFuture;
  @override
  void initState() {
    super.initState();
    signupFuture = signup(widget.username, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.username);
    print(widget.password);
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            print(snapshot.data!.body);
            if (snapshot.data!.body != "USER ALREADY EXISTS") {
              api_token = snapshot.data!.body;
              _resultState = 1;
            } else {
              _resultState = 2;
            }
            return LoadingDots();
            // leaving this code in here as a form of comments because it will make debugging in the future esaier
            //
            // return Container(
            //     child: Center(
            //         child: AnimatedTextKit(
            //       key: GlobalKey(),
            //       animatedTexts: [
            //         TyperAnimatedText(
            //             "Hi ${widget.username}!\nSecurity token: ${snapshot.data!.body}",
            //             speed: const Duration(milliseconds: 45),
            //             textStyle: TextStyle(
            //                 fontSize: 25.0,
            //                 color: secondaryColor,
            //                 decoration: TextDecoration.none,
            //                 backgroundColor: Colors.transparent))
            //       ],
            //       repeatForever: false,
            //       totalRepeatCount: 1,
            //       pause: const Duration(milliseconds: 0),
            //     )),
            //     color: primaryColor);
          }
        } else {
          return LoadingDots();
        }
        return LoadingDots();
      },
      future: signupFuture,
    );
  }
}
