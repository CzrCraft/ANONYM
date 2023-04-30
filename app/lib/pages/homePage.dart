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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(//for some reason or another the MaterialApp widget doesn't get recognised so i have to use a Material widget
        color: secondaryColor,
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                  ),
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.shopping_bag,
                            color: secondaryColor,
                            size: getFromPercent("vertical", 5, context),
                          ),
                          onPressed: () {
                            print("1");
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add_circle,
                            color: secondaryColor,
                            size: getFromPercent("vertical", 5, context),
                          ),
                          onPressed: () {
                            print("2");
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.account_circle,
                            color: secondaryColor,
                            size: getFromPercent("vertical", 5, context),
                          ),
                          onPressed: () {
                            print("3");
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                ),
                height: getFromPercent("vertical", 7, context),
                width: getFromPercent("horizontal", 50, context),
              ),
              bottom: getFromPercent("vertical", 5, context),
              left: getFromPercent("horizontal", 25, context),
            ),
          ],
        ),
      )
    );
  }
}
