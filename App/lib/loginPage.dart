// ignore_for_file: sort_child_properties_last

import 'package:Stylr/main.dart';
import 'package:Stylr/utilities/miscellaneous.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  int animationStage = 0;
  String username = "";
  String password = "";
  Widget build(BuildContext context) {
    if (animationStage == 0) {
      Future.delayed(const Duration(milliseconds: 455), () {
        setState(() {
          animationStage =
              1; // delay so that the animation waits for the circle transition to finnish
        });
      });
    } else if (animationStage == 1) {
      Future.delayed(const Duration(milliseconds: 1100), () {
        setState(() {
          animationStage =
              2; // delay so that the animation waits for the first one to finnish
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
                pause: const Duration(milliseconds: 1100),
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
                        ),
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
                        ),
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
          return _Login(username, password);
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
  _Login(@required this.username, @required this.password, {super.key});

  @override
  State<_Login> createState() => __LoginState();
}

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
            return Container(
                child: Center(
                    child: AnimatedTextKit(
                  key: GlobalKey(),
                  animatedTexts: [
                    TyperAnimatedText(
                        "Hi ${widget.username}!\nSecurity token: ${snapshot.data!.body}",
                        speed: const Duration(milliseconds: 45),
                        textStyle: TextStyle(
                            fontSize: 25.0,
                            color: secondaryColor,
                            decoration: TextDecoration.none,
                            backgroundColor: Colors.transparent))
                  ],
                  repeatForever: false,
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 0),
                )),
                color: primaryColor);
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
