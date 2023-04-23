// ignore_for_file: sort_child_properties_last

import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';

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
          animationStage = 1;
        });
      });
    } else if (animationStage == 1) {
      Future.delayed(const Duration(milliseconds: 1100), () {
        setState(() {
          animationStage = 2;
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
                animatedTexts: [
                  TyperAnimatedText("Okay, what is your name?",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: 25.0,
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
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText("Okay, what is your name?",
                      speed: const Duration(milliseconds: 45),
                      textStyle: TextStyle(
                          fontSize: 25.0,
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
              ),
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
                              username = input;
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
                            fontSize: 25),
                        showCursor: false,
                      ),
                    ),
                    Positioned(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText("........................",
                                speed: const Duration(milliseconds: 45),
                                textStyle: TextStyle(
                                    fontSize: 25.0,
                                    color: secondaryColor,
                                    decoration: TextDecoration.none,
                                    backgroundColor: Colors.transparent)),
                          ],
                          totalRepeatCount: 1,
                          onFinished: () {
                            setState(() {
                              animationStage = 2;
                            });
                          },
                          repeatForever: false,
                          pause: const Duration(milliseconds: 1100),
                        ),
                        top: 30,
                        left: 20)
                  ]),
                  padding: EdgeInsets.only(top: 15)),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
        break;
      case 3:
        return Container(child: Center(child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText("Hello " + username,
                                speed: const Duration(milliseconds: 45),
                                textStyle: TextStyle(
                                    fontSize: 25.0,
                                    color: secondaryColor,
                                    decoration: TextDecoration.none,
                                    backgroundColor: Colors.transparent)),
                          ],
                          totalRepeatCount: 1,

                          repeatForever: false,
                          pause: const Duration(milliseconds: 1100),
                        )), color: primaryColor);
        break;
    }
    return Container(color: primaryColor);
  }
}
