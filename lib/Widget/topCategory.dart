import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/top_category_model.dart';
import 'package:fire_com/Model/top_service_model.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:fire_com/Widget/topCategoryWidget.dart';
import 'package:flutter/material.dart';

List<TopCategoryWidget> _topCategoryWidget = [];
bool _loading = false;

class TopCategory extends StatefulWidget {
  const TopCategory({super.key});

  @override
  State<TopCategory> createState() => _TopCategoryState();
}

class _TopCategoryState extends State<TopCategory> {
  // final List<String> items = List.generate(20, (index) => 'Item $index');
  List<TopServiceModel> service = [];
  TopServiceModel service1 =
      TopServiceModel("Casual Wear", "assets/cloths/i8.jpg");
  TopServiceModel service2 =
      TopServiceModel("Formal Attire", "assets/cloths/i7.jpg");
  TopServiceModel service3 =
      TopServiceModel("Outerwear", "assets/cloths/i6.jpg");
  TopServiceModel service4 =
      TopServiceModel("Activewear", "assets/cloths/i7.jpg");
  TopServiceModel service5 =
      TopServiceModel("Sleepwear", "assets/cloths/i7.jpg");
  TopServiceModel service6 =
      TopServiceModel("Business Casual", "assets/cloths/i7.jpg");

  List<TopCategoryModel> category = [];
  TopCategoryModel topCategory1 =
      TopCategoryModel("Casual", "assets/cloths/i8.jpg");
  TopCategoryModel topCategory2 =
      TopCategoryModel("Formal", "assets/cloths/i7.jpg");
  TopCategoryModel topCategory3 =
      TopCategoryModel("Outerwear", "assets/cloths/i8.jpg");
  TopCategoryModel topCategory4 =
      TopCategoryModel("Activewear", "assets/cloths/i7.jpg");
  TopCategoryModel topCategory5 =
      TopCategoryModel("Sleepwear", "assets/cloths/i7.jpg");
  TopCategoryModel topCategory6 =
      TopCategoryModel("Business", "assets/cloths/i7.jpg");

  @override
  void initState() {
    service.add(service1);
    service.add(service2);
    service.add(service3);
    service.add(service4);
    service.add(service5);
    service.add(service6);

    category.add(topCategory1);
    category.add(topCategory2);
    category.add(topCategory3);
    category.add(topCategory4);
    category.add(topCategory5);
    category.add(topCategory6);
    category.add(topCategory6);
    category.add(topCategory6);
    category.add(topCategory6);
    addCategory();
    super.initState();
  }

  void addCategory() {
    setState(() {
      _loading = true;
    });
    for (var loop in category) {
      setState(() {
        TopCategoryWidget category = TopCategoryWidget(loop.image, loop.name);
        _topCategoryWidget.add(category);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : service.isNotEmpty
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
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 20),
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
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 20),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Text(
                                "Shopping",
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
                        itemCount: service.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: Colors.black,
                            color: Colors.white,
                            child: Column(children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                          service[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
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
