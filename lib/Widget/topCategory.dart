import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/top_service.dart';
import 'package:flutter/material.dart';

class TopCategory extends StatefulWidget {
  const TopCategory({super.key});

  @override
  State<TopCategory> createState() => _TopCategoryState();
}

class _TopCategoryState extends State<TopCategory> {
  // final List<String> items = List.generate(20, (index) => 'Item $index');
  List<TopService> items = [];
  TopService service1 = TopService("Casual Wear", "assets/cloths/i1.jpg");
  TopService service2 = TopService("Formal Attire", "assets/cloths/i2.jpg");
  TopService service3 = TopService("Outerwear", "assets/cloths/i3.jpg");
  TopService service4 = TopService("Activewear", "assets/cloths/i4.jpg");
  TopService service5 = TopService("Sleepwear", "assets/cloths/i5.jpg");
  TopService service6 = TopService("Business Casual", "assets/cloths/i5.jpg");

  @override
  void initState() {
    items.add(service1);
    items.add(service2);
    items.add(service3);
    items.add(service4);
    items.add(service5);
    items.add(service6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return items.length > 0
        ? Container(
            decoration: BoxDecoration(
                color: headerNavigation,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Container(
                          height: 45,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 20),
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "TOP CATEGORY",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: text2,
                                fontSize: 20),
                          ))),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items per row
                      crossAxisSpacing: 10.0, // Space between columns
                      mainAxisSpacing: 10.0, // Space between rows
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: Column(children: [
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                items[index].image,
                                fit: BoxFit.cover,
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
