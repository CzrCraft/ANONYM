import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';

double getFromPercent(String type, double percent, BuildContext context) {
  type = type.toLowerCase();
  if (type == "vertical") {
    return MediaQuery.of(context).size.height * percent / 100;
  } else if (type == "horizontal") {
    return MediaQuery.of(context).size.width * percent / 100;
  }
  throw "incorrect getFromPercent parameters. Parameter structure is (String type: vertical/horizontal, int percent: 0 <-> 100, BuildContext context)";
  return 0;
}
