import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Screens/welcomePage.dart';
import 'package:fire_com/Widget/backButtonWidget.dart' show BackButtonWidget;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

String _orderId = "";

class OrderComplete extends StatefulWidget {
  String id;

  OrderComplete(this.id);

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  @override
  void initState() {
    orderCheck();
    super.initState();
  }

  Future<void> orderCheck() async {
    print(widget.id);
    String id = widget.id.substring(0, widget.id.length - 1);
    await addOrder(id.split("/").last);

    // deleteCart();
  }

  Future<void> addOrder(String tempId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.post(Uri.parse("${baseURL}api/v1/order"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
            },
            body: jsonEncode({"tempId": tempId}));
    if (response.statusCode == 200) {
      setState(() {
        _orderId = jsonDecode(response.body)["id"].toString();
      });
    }
  }

  Future<void> deleteCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      Uri.parse(
          "${baseURL}api/v1/cart/clear/${jsonDecode(prefs.getString("user").toString())["id"]}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)], // Green gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 20),
              //       child: BackButtonWidget(),
              //     ),
              //   ],
              // ),
              Container(
                height: MediaQuery.sizeOf(context).height - 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/success.json', // Use a Lottie success animation
                      width: 200,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Order Placed Successfully!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      // "Order ID: #${widget.orderId}",
                      "Order ID: #${_orderId}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        // orderCheck();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false,
                        );
                      },
                      child: const Text("Back to Home"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
