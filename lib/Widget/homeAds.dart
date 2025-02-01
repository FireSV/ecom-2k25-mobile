import 'dart:async';

import 'package:flutter/material.dart';

final List<String> images = [
  'assets/images/e1.png',
  'assets/images/e2.png',
  'assets/images/e3.png',
];

class HomeAds extends StatefulWidget {
  const HomeAds({super.key});

  @override
  State<HomeAds> createState() => _HomeAdsState();
}

class _HomeAdsState extends State<HomeAds> {
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 8), (Timer timer) {
      try{
        int nextPage = controller.page!.round() + 1;
        if (nextPage < images.length) {
          controller.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          controller.animateToPage(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }catch(e){}

    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 20,spreadRadius: 10),
              ],
            ),
            height: 250,
            alignment: Alignment.topCenter,
            child: PageView.builder(
              controller: controller,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            )),
      ),
    );
  }
}
