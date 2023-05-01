import 'package:Stylr/main.dart';
import 'package:Stylr/utilities/miscellaneous.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';

class DesignerPage extends StatefulWidget {
  const DesignerPage({super.key});

  @override
  State<DesignerPage> createState() => _DesignerPageState();
}

class _DesignerPageState extends State<DesignerPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("second page"));
  }
}