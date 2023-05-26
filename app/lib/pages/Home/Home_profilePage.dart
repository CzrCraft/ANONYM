// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:Stylr/main.dart';
import 'package:Stylr/pages/utilities.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  @override
  void initState() {
    // don't change
    // result is supposed to be nullable
    getUsername(api_token, callback: (String? result){
      if(result != null){
        // i use setState because the callback is going to be called after it renders
        // due to net lag
        setState(() {
          username = result;
        });
      }
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: getFromPercent("vertical", 3, context)),
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: getFromPercent("horizontal", 40, context),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: primaryColor
              ),
              width: getFromPercent("horizontal", 85, context),
              child: AutoSizeText(
                username,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: getFromPercent("horizontal", 12, context)
                ),
                maxLines: 1,
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: getFromPercent("vertical", 10, context)),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: secondaryColor,
                ),
                child: Text("Reset your password", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 8.5, context)),),
                onPressed: () {
                  Navigator.push(context,animatedRoute(_ChangePassword()));
                },
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: getFromPercent("vertical", 2, context)),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: secondaryColor,
                ),
                child: Text("Logout", style: TextStyle(color: secondaryColor, fontSize: getFromPercent("horizontal", 8.5, context)),),
                onPressed: () async {
                  logout(api_token);
                  api_token = "";
                  RootWidgetKey = GlobalKey();
                  // move the user to the start page and clear the token so that a new one is created
                  // and reset navigator history
                  Navigator.pushAndRemoveUntil(context, animatedRoute(RootWidget(key: RootWidgetKey, readToken: false,)), ModalRoute.withName('/'));
                },
              )
            )
        ])
      )
    );
  }
}

class _ChangePassword extends StatefulWidget {
  const _ChangePassword({super.key});

  @override
  State<_ChangePassword> createState() => __ChangePasswordState();
}

class __ChangePasswordState extends State<_ChangePassword> {
  final passwordFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: primaryColor,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: getFromPercent("vertical", 50, context), left: getFromPercent("horizontal", 3, context), right: getFromPercent("horizontal", 3, context)),
                child: TextFormField(
                  controller: passwordFieldController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide(color: secondaryColor, width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide(color: secondaryColor, width: 4)),
                    hintText: "Enter your new password",
                    hintStyle: TextStyle(
                      color: secondaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w600
                    ),
                    suffixIcon: TextButton(
                      child: Icon(Icons.send, color: secondaryColor), 
                      onPressed: () async {
                        print(passwordFieldController.text);
                        var result = await resetPassword(api_token, passwordFieldController.text);
                        var newPass = passwordFieldController.text;
                        newPass.trim();
                        // TODO: ADD ERROR MESSAGES
                        if(newPass != ""){
                          if(result){
                            api_token = "";
                            RootWidgetKey = GlobalKey();
                            // move the user to the start page and clear the token so that a new one is created
                            // and reset navigator history
                            Navigator.pushAndRemoveUntil(context, animatedRoute(RootWidget(key: RootWidgetKey, readToken: false,)), ModalRoute.withName('/'));
                          }else{
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                        }else{
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                        }

                      },
                      style: TextButton.styleFrom(
                        foregroundColor: secondaryColor,
                      )
                    ),
                  ),
                  cursorColor: secondaryColor,
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600
                  ),
                  
                ),
              )
            ],
          )
        )
      )
    );
  }
}