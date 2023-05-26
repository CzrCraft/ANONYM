// ignore_for_file: sort_child_properties_last

import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'utilities.dart';
import 'pages.dart';
import 'package:flutter/scheduler.dart';

int _resultState =
    0; //using local variable because it would be way to complicated to use GlobalKey's

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // using a ticker to check every frame if login() func has returned a result
  // and if so act accordingly
  // this prevents FutureBuilder sending multiple requests slowing down the API
  // this problem reappears throughout the app though cuz no time :(
  int animationStage =
      0; // i use this for keeping track at what stage of the "animation" the widget is currently at
  String username =
      ""; // ex: when you input your username its at stage 2, etc..
  String password = "";
  late Ticker _ticker;
  @override
  void initState() {
    super.initState();
    _resultState = 0;
    // this callback func is going to be called every time flutter renders a new frame
    // all it does is check if you have logged in succsesfully
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
            _ticker.stop();
            Navigator.pop(context);
          }
        } catch (err) {
          print(err);
        }
      } else if (_resultState == 3) {
        try {
          if (Navigator.canPop(context)) {
            _ticker.stop();
            Navigator.pop(context);
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
                  TyperAnimatedText("Okay, what is your name?",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: getFromPercent("horizontal", 6, context),
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
        break;
      case 2:
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              Text("Okay, what is your name?",
                  style: TextStyle(
                      fontSize: getFromPercent("horizontal", 6, context),
                      color: secondaryColor,
                      decoration: TextDecoration.none)),
              Padding(
                  child: Stack(
                    children: [
                      Material(
                        child: TextField(
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
                          ),
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.center,
                          cursorColor: secondaryColor,
                          maxLength: 20,
                          onSubmitted: (String input) {
                            input = input.trim();
                            if (input != null && input != "") {
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
                        top: getFromPercent("vertical", 2.2, context),
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
        break;

      case 3:
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText("Great! Now, what's your password?",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: getFromPercent("horizontal", 4.7, context),
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
        break;
      case 4:
        return Container(
          color: primaryColor,
          child: Column(
            children: [
              Text("Great! Now, what's your password?",
                  style: TextStyle(
                      fontSize: getFromPercent("horizontal", 4.8, context),
                      color: secondaryColor,
                      decoration: TextDecoration.none)),
              Padding(
                  child: Stack(children: [
                    Material(
                      child: TextField(
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
                        ),
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.center,
                        cursorColor: secondaryColor,
                        maxLength: 20,
                        onSubmitted: (String input) {
                          input = input.trim();
                          if (input != null && input != "") {
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
        break;
      case 5:
        try {
          return _Login(username, password, this);
        } catch (err) {
          print(err);
          return Placeholder();
        }
    }
    return Container(color: primaryColor);
  }
}

//i use this method of loging in because including the FutureBuilder inside the LoginPage widget will
//cause a bug where the Future(login()) will get called mutliple times solicting the api too much
//and i can't declare the Future in initState() because the login() function reuqires an username and a password
//that are acquired later
//so i use this seperate local widget that i declare the Future inside its initState() function
//avoiding this weird bug.

class _Login extends StatefulWidget {
  final String username;
  final String password;
  final State parent;
  _Login(
      @required this.username, @required this.password, @required this.parent,
      {super.key});

  @override
  State<_Login> createState() => __LoginState();
}

//TODO: add error messages for logging in
class __LoginState extends State<_Login> {
  @override
  late Future signupFuture;
  void initState() {
    super.initState();
    signupFuture = login(widget.username, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.username);
    print(widget.password);
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            print(snapshot.data?.body);
            if (snapshot.data!.body != "USER DOESN'T EXIST") {
              if (snapshot.data!.body != "WRONG PASSWORD") {
                api_token = snapshot.data!.body;
                _resultState = 1;
              } else {
                _resultState = 2;
              }
            } else {
              _resultState = 3;
            }
            return LoadingDots();
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
