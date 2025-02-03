import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';

import '../Widget/homeAds.dart';
import '../Widget/topCategory.dart';

class WelcomePage extends StatefulWidget {
  Function openDrawer;
  WelcomePage(this.openDrawer, {super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: headerNavigation,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(
                         1000),
                      onTap: () => {
                        widget.openDrawer()
                      },
                      child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: navigationIcon,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 20,),
                              ],
                            borderRadius: BorderRadius.circular(
                                1000),),
                          child: Icon(Icons.menu,size: 18,)),
                    ),
                    // Container(
                    //     height: 45,
                    //     width: 250,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black12, blurRadius: 20),
                    //         ],
                    //         borderRadius: BorderRadius.only(
                    //             bottomLeft: Radius.circular(10),
                    //             topLeft: Radius.circular(10))),
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    //       child: Text(
                    //         "Welcome to FireStore Sandun",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: text4,
                    //         ),
                    //       ),
                    //     )),
                    // Container(
                    //     height: 45,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black12, blurRadius: 20),
                    //         ],
                    //         borderRadius: BorderRadius.only(
                    //             bottomLeft: Radius.circular(10),
                    //             topLeft: Radius.circular(10))),
                    //     child: Center(
                    //         child: Text(
                    //       "FIRE STORE",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: text2,
                    //           fontSize: 20),
                    //     ))),
                  ],
                ),
              ),
              HomeAds(),
              TopCategory()
            ],
          ),
        ),
      ),
    );
  }
}
