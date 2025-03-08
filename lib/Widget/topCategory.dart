import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/top_category_model.dart';
import 'package:fire_com/Model/top_service_model.dart';
import 'package:fire_com/Screens/cartView.dart';
import 'package:fire_com/Screens/productList.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:fire_com/Widget/topCategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<TopCategoryWidget> _topCategoryWidget = [];
bool _loading = false;

class TopCategory extends StatefulWidget {
  const TopCategory({super.key});

  @override
  State<TopCategory> createState() => _TopCategoryState();
}

class _TopCategoryState extends State<TopCategory> {
  List<TopServiceModel> categoryList = [];
  List<TopCategoryModel> topCategoryList = [];


  @override
  void initState() {

    addCategory();
    addTopCategory();
    super.initState();
  }

  void addTopCategory() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("user"));
    http.Response response = await http.get(
      Uri.parse(baseURL + "api/v1/top-category/0/10"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      for (var loop in jsonDecode(response.body)["content"]) {
        setState(() {
          try {
            _topCategoryWidget.add(TopCategoryWidget(
                loop["category"]["imageUrl"].toString(),
                loop["category"]["name"].toString()));
          } catch (e) {
            print(e);
          }
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void addCategory() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("user"));
    http.Response response = await http.get(
      Uri.parse(baseURL + "api/v1/category/0/10"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      for (var loop in jsonDecode(response.body)["content"]) {
        setState(() {
          try {
            // _topCategoryWidget.add(category);
            categoryList.add(TopServiceModel(
                loop["name"].toString(), loop["imageUrl"].toString(), 100.22));
          } catch (e) {
            print(e);
          }
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : categoryList.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3), blurRadius: 20)
                    ],
                    color: headerNavigation,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: grey.withAlpha(100),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search",
                                hintStyle: TextStyle(color: grey),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: grey,
                                )),
                          ),
                        ),
                      ),
                    ),
                    if (_topCategoryWidget.length > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, top: 20, left: 20),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                    // color: Colors.white,
                                    boxShadow: [
                                      // BoxShadow(
                                      //     color: Colors.black12,
                                      //     blurRadius: 20),
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Text(
                                  "Top Category",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: text4,
                                      fontSize: 20),
                                )),
                          ),
                        ],
                      ),
                    if (_topCategoryWidget.length > 0)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _topCategoryWidget,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 20, top: 20),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                  // color: Colors.white,
                                  boxShadow: [
                                    // BoxShadow(
                                    //     color: Colors.black12, blurRadius: 20),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Text(
                                "Category",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: text4,
                                    fontSize: 20),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of items per row
                          crossAxisSpacing: 10.0, // Space between columns
                          mainAxisSpacing: 10.0, // Space between rows
                        ),
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: Colors.black,
                            color: Colors.white,
                            child: Column(children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductList(categoryList[index])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.3))
                                        ]),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.asset(
                                            categoryList[index].image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/common/no_image.jpg',
                                                // Fallback image
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox();
  }
}
