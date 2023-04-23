// ignore_for_file: file_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:Stylr/main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  bool finished_animation = false;
  bool finished_second_animation = false;
  Widget build(BuildContext context) {
    if (!finished_animation) {
      return Container(
        color: secondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText("Welcome back",
                    speed: const Duration(milliseconds: 45),
                    textStyle: TextStyle(
                        fontSize: 30.0,
                        color: primaryColor,
                        decoration: TextDecoration.none)),
                TyperAnimatedText("Do you have an account?",
                    speed: const Duration(milliseconds: 45),
                    textStyle: TextStyle(
                        fontSize: 25.0,
                        color: primaryColor,
                        decoration: TextDecoration.none)),
              ],
              totalRepeatCount: 1,
              onFinished: () {
                setState(() {
                  finished_animation = true;
                });
              },
              repeatForever: false,
              pause: Duration(milliseconds: 1100),
            ),
          ],
        ),
      );
    } else {
      if (!finished_second_animation) {
        return Container(
          color: secondaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Do you have an account?",
                style: TextStyle(
                    fontSize: 25.0,
                    color: primaryColor,
                    decoration: TextDecoration.none),
              ),
              // ignore: sort_child_properties_last
              Padding(
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText("Yes",
                            speed: const Duration(milliseconds: 45),
                            textStyle: TextStyle(
                              fontSize: 30.0,
                              color: secondaryColor,
                            )),
                      ],
                      totalRepeatCount: 1,
                      repeatForever: false,
                      pause: const Duration(milliseconds: 150),
                      onFinished: () {
                        setState(() {
                          finished_second_animation = true;
                        });
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor),
                ),
                padding: const EdgeInsets.only(top: 15.0, bottom: 12),
              ),
            ],
          ),
        );
      } else {
        return Container(
          color: secondaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Do you have an account?",
                style: TextStyle(
                    fontSize: 25.0,
                    color: primaryColor,
                    decoration: TextDecoration.none),
              ),
              // ignore: sort_child_properties_last
              Padding(
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: IgnorePointer(child: Text("Yes",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: secondaryColor,
                        decoration: TextDecoration.none),
                    )),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor),
                ),
                padding: const EdgeInsets.only(top: 15.0, bottom: 12),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: IgnorePointer(child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText("No",
                          speed: const Duration(milliseconds: 45),
                          textStyle: TextStyle(
                            fontSize: 30.0,
                            color: secondaryColor,
                          )),
                    ],
                    totalRepeatCount: 1,
                    repeatForever: false,
                    pause: const Duration(milliseconds: 0),
                  )),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor),
              ),
            ],
          ),
        );
      }
    }
  }
}
