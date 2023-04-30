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
  // using a ticker to check every frame if login() func has returned a result
  // and if so act accordingly

  @override
  int animationStage = 0;
  String username = "";
  String password = "";
  late Ticker _ticker;
  void initState() {
    super.initState();
    _resultState = 0;
    _ticker = super.createTicker((Duration elapsedTime) {
      if (_resultState == 1) {
        _ticker.stop();
        Navigator.push(context, animatedRoute(new HomePage()));
      } else if (_resultState == 2) {
        try {
          if (Navigator.canPop(context)) {
            _ticker.stop();
            Navigator.pop(context);
          }
        } catch (err) {
          print(err);
        }
      }
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
        break;
      case 2:
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
        break;
      case 4:
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
          return _SignUp(username, password);
        } catch (err) {
          print(err);
          return const LoadingDots();
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
  _SignUp(@required this.username, @required this.password, {super.key});

  @override
  State<_SignUp> createState() => __SignUpState();
}

class __SignUpState extends State<_SignUp> {
  @override
  late Future signupFuture;
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
          return const LoadingDots();
        }
        return const LoadingDots();
      },
      future: signupFuture,
    );
  }
}
