// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'package:Stylr/main.dart';
import 'package:Stylr/pages/Home/Home_profilePage.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';
import 'pages.dart';

class HomePage extends StatefulWidget {
  HomePage(this.childPageID, {super.key});
  int childPageID;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Widget childPage = Container();
  // Everytime the user switches between lets say the catalogue and their profile a new HomePage
  // widget will be created with the right child page so that there is no need for multiple Navigators
  // and the code remains somewhat clean
  @override
  void initState() {
    // when the widget is initialised it sets it's child page based on the id passed as a param
    switch (widget.childPageID) {
      case 0:
        childPage = CataloguePage(key: GlobalKey());
        break;
      case 1:
        childPage = CataloguePage(key: GlobalKey());
        break;
      case 2:
        childPage = DesignerPage(key: GlobalKey());
        break;
      case 3:
        childPage = ProfilePage(key: GlobalKey());
        break;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    switch(widget.childPageID){
      case 0:
        return Material(
          child: Container(
            //for some reason or another the MaterialApp widget doesn't get recognised so i have to use a Material widget
            color: secondaryColor,
            child: Stack(
              children: [
                childPage,
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.shopping_bag,
                                color: primaryColor,
                                size: getFromPercent("vertical", 5, context),
                              ),
                              onPressed: () {
                                Navigator.push(context, createBasicRoute(HomePage(1)));
                              },
                            )
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.add_circle,
                              color: secondaryColor,
                              size: getFromPercent("vertical", 5, context),
                            ),
                            onPressed: () {
                              Navigator.push(context, createBasicRoute(HomePage(2)));
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
                              Navigator.push(context, createBasicRoute(HomePage(3)));
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
          ));
      case 1:
        return Material(
          child: Container(
            //for some reason or another the MaterialApp widget doesn't get recognised so i have to use a Material widget
            color: secondaryColor,
            child: Stack(
              children: [
                childPage,
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.shopping_bag,
                                color: primaryColor,
                                size: getFromPercent("vertical", 5, context),
                              ),
                              onPressed: () {
                                Navigator.push(context, createBasicRoute(HomePage(1)));
                              },
                            )
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.add_circle,
                              color: secondaryColor,
                              size: getFromPercent("vertical", 5, context),
                            ),
                            onPressed: () {
                              Navigator.push(context, createBasicRoute(HomePage(2)));
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
                              Navigator.push(context, createBasicRoute(HomePage(3)));
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
          ));
      case 2:
        return Material(
          child: Container(
            //for some reason or another the MaterialApp widget doesn't get recognised so i have to use a Material widget
            color: secondaryColor,
            child: Stack(
              children: [
                childPage,
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
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
                              Navigator.push(context, createBasicRoute(HomePage(1)));
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                                size: getFromPercent("vertical", 5, context),
                              ),
                              onPressed: () {
                                Navigator.push(context, createBasicRoute(HomePage(2)));
                              },
                            )
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.account_circle,
                              color: secondaryColor,
                              size: getFromPercent("vertical", 5, context),
                            ),
                            onPressed: () {
                              Navigator.push(context, createBasicRoute(HomePage(3)));
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
          ));
      case 3:
        return Material(
          child: Container(
            //for some reason or another the MaterialApp widget doesn't get recognised so i have to use a Material widget
            color: secondaryColor,
            child: Stack(
              children: [
                childPage,
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
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
                              Navigator.push(context, createBasicRoute(HomePage(1)));
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
                              Navigator.push(context, createBasicRoute(HomePage(2)));
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.account_circle,
                                color: primaryColor,
                                size: getFromPercent("vertical", 5, context),
                              ),
                              onPressed: () {
                                Navigator.push(context, createBasicRoute(HomePage(3)));
                              },
                            )
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
          ));
    }
    return LoadingDots(lightMode: true,);
  }
}
