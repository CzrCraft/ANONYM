import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:Stylr/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void readValue(String key, Function callback) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? valueRead = prefs.getString(key);
    if (valueRead != null) {
      callback(valueRead);
    } else {
      callback("");
    }
  } catch (err) {
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? valueRead = prefs.getString(key);
  if (valueRead != null) {
    callback(valueRead);
  } else {
    callback("");
  }
}

void writeValue(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
