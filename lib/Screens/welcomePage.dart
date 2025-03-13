import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';

import '../Widget/homeAds.dart';
import '../Widget/topCategory.dart';

bool _loading = false;

class WelcomePage extends StatefulWidget {
  Function openDrawer;

  WelcomePage(this.openDrawer, {super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> refresh() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: headerNavigation,
      child: RefreshIndicator(
        onRefresh: () async {
          await refresh();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(1000),
                      onTap: () => {widget.openDrawer()},
                      child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: navigationIcon,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Icon(
                            Icons.menu,
                            size: 18,
                          )),
                    ),
                  ],
                ),
              ),
              if (!_loading) HomeAds(),
              if (!_loading) TopCategory()
            ],
          ),
        ),
      ),
    );
  }
}
