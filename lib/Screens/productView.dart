import 'dart:convert';

import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/product.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:fire_com/Widget/cartButton.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../API/BaseURL/baseURL.dart' show baseURL;

bool _loading = false;

class ProductView extends StatefulWidget {
  Product product;

  ProductView(this.product, {super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    setState(() {
      _loading = true;
    });
    print(widget.product.description);
    // try {
    //   String formattedJson = widget.product["fullDetails"]
    //       .replaceAllMapped(RegExp(r'(\w+):'),
    //           (match) => '"${match[1]}":') // Wrap keys in quotes
    //       .replaceAllMapped(RegExp(r':\s*([a-zA-Z_]+)'),
    //           (match) => ': "${match[1]}"') // Wrap string values in quotes
    //       .replaceAll("'", '"');
    //   productMap = jsonDecode(formattedJson);
    // } catch (e) {
    //   print(e);
    // }
    setState(() {
      _loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: secondaryColor,
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: (MediaQuery.of(context).size.height / 2) -
                                  100,
                              child: Image.network(
                                  widget.product.image.toString(),
                                  errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/common/no_image.jpg', // Fallback image
                                  fit: BoxFit.cover,
                                );
                              }, fit: BoxFit.cover),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.grey.withOpacity(0.8),
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      child: Center(
                                        child: Text(
                                          widget.product.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                left: 20, top: 20, child: BackButtonWidget()),
                            Positioned(right: 20, top: 20, child: CartButton())
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  (MediaQuery.of(context).size.height / 2) + 30,
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.white, spreadRadius: 2,
                                      offset: Offset(0,
                                          -5), // Moves shadow **upwards** (top shadow)
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Description : ${widget.product.description}",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 30),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                // color: grey.withOpacity(0.6),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Price : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    widget.product.price
                                                                .toString() ==
                                                            "null"
                                                        ? "\$0.00"
                                                        : "\$${widget.product.price.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                // color: grey.withOpacity(0.6),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    widget.product.discount
                                                                .toString() ==
                                                            "null"
                                                        ? "0.00"
                                                        : "${widget.product.discount.toStringAsFixed(2)} OFF",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   height: 45,
                              //   width: 200,
                              //   decoration: BoxDecoration(
                              //       color: navigationIcon,
                              //       borderRadius: BorderRadius.circular(10)),
                              //   child: Center(
                              //       child: Text(
                              //     "Add to cart ",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   )),
                              // ),

                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  http.Response response2 = await http.get(
                                    Uri.parse(
                                        "${baseURL}api/v1/cart/${jsonDecode(prefs.getString("user").toString())["id"]}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                                    },
                                  );

                                  if (response2.statusCode == 200) {
                                    if (jsonDecode(response2.body).length ==
                                        0) {
                                      http.Response response = await http.post(
                                        body: jsonEncode({
                                          "productId": widget.product.id,
                                          "qty": 1,
                                          "userId": jsonDecode(prefs
                                                  .getString("user")
                                                  .toString())["id"]
                                              .toString(),
                                        }),
                                        Uri.parse(baseURL + "api/v1/cart"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization":
                                              "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                                        },
                                      );

                                      if (response.statusCode == 200) {
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Added successfully !'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Something went wrong !'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } else if (widget.product.createdUser ==

                                            jsonDecode(response2.body)[0]
                                                    ["product"]["createdUser"]
                                                .toString()) {
                                      http.Response response = await http.post(
                                        body: jsonEncode({
                                          "productId": widget.product.id,
                                          "qty": 1,
                                          "userId": jsonDecode(prefs
                                                  .getString("user")
                                                  .toString())["id"]
                                              .toString(),
                                        }),
                                        Uri.parse(baseURL + "api/v1/cart"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization":
                                              "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                                        },
                                      );
                                      if (response.statusCode == 200) {
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Added successfully !'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Something went wrong !'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } else {
                                      Future<bool> showConfirmationDialog(
                                          BuildContext context,
                                          String title,
                                          String message) async {
                                        return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(title,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  content: Text(message),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator
                                                              .of(context)
                                                          .pop(
                                                              false), // User pressed No
                                                      child: Text("No",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        await http.get(
                                                          Uri.parse(
                                                              "${baseURL}api/v1/cart/clear/${jsonDecode(prefs.getString("user").toString())["id"]}"),
                                                          headers: {
                                                            "Content-Type":
                                                                "application/json",
                                                            "Authorization":
                                                                "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                                                          },
                                                        );

                                                        //   add

                                                        http.Response response =
                                                            await http.post(
                                                          body: jsonEncode({
                                                            "productId": widget
                                                                .product.id,
                                                            "qty": 1,
                                                            "userId": jsonDecode(prefs
                                                                    .getString(
                                                                        "user")
                                                                    .toString())["id"]
                                                                .toString(),
                                                          }),
                                                          Uri.parse(baseURL +
                                                              "api/v1/cart"),
                                                          headers: {
                                                            "Content-Type":
                                                                "application/json",
                                                            "Authorization":
                                                                "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                                                          },
                                                        );
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          const snackBar = SnackBar(
                                                              content: Text(
                                                                  'Added successfully !'));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        } else {
                                                          const snackBar = SnackBar(
                                                              content: Text(
                                                                  'Something went wrong !'));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      }, // User pressed Yes
                                                      child: Text("Yes"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            false; // Returns false if dialog is dismissed
                                      }

                                      showConfirmationDialog(
                                          context,
                                          "Are you sure?",
                                          "Multiple vendors are not supported for delivery. Do you want to clear the cart and add this item instead?");
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: navigationIcon,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 3)),
                                  width: 200,
                                  height: 45,
                                  child: Center(
                                      child: Text(
                                    "Add to Cart",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
