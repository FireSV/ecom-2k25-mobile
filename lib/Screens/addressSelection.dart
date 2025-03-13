import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/address.dart';
import 'package:fire_com/Model/cart.dart';
import 'package:fire_com/Screens/PaymentGatewayWebView.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<Address> _addressList = [];
bool _loading = false;

class AddressSelection extends StatefulWidget {
  String method;
  List<Cart> _cartList ;
  AddressSelection(this.method,this._cartList);

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  Future<void> getAll() async {
    setState(() {
      _loading = true;
      _addressList.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      Uri.parse(baseURL + "api/v1/address/0/50"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      for (var res in jsonDecode(response.body)["content"]) {
        print(res);
        setState(() {
          try {
            _addressList.add(Address(
                res["id"],
                res["street"].toString(),
                res["city"].toString(),
                res["state"].toString(),
                res["postalCode"].toString(),
                res["country"].toString(),
                res["user"]["id"]));
          } catch (e) {}
        });
      }
      print(response.body);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  BackButtonWidget(),
                ],
              ),
            ),
            Text(
              "Select Delivery Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _addressList.length,
                itemBuilder: (context, index) {
                  var item = _addressList[index];
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PaymentGatewayWebView(widget.method.toString(), _addressList[index].id.toString())));
                      //


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentGatewayWebView(widget.method.toString(), _addressList[index].id.toString(),widget._cartList)));

                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Street : ${item.street}",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text("City : ${item.city}",
                                  style: TextStyle(fontSize: 18)),
                              Text("State : ${item.state}",
                                  style: TextStyle(fontSize: 18)),
                              Text("Postal Code : ${item.postalCode}",
                                  style: TextStyle(fontSize: 18)),
                              Text("Country : ${item.country}",
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
