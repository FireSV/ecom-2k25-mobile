import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Model/cart.dart' show Cart;
import 'package:fire_com/Screens/orderComplete.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors/ColorsLocal.dart' show navigationIcon, secondaryColor;

bool _loading = false;
bool _error = false;

class PaymentGatewayWebView extends StatefulWidget {
  String method;
  String id;
  List<Cart> _cartList;

  PaymentGatewayWebView(this.method, this.id, this._cartList);

  @override
  State<PaymentGatewayWebView> createState() => _PaymentGatewayWebViewState();
}

class _PaymentGatewayWebViewState extends State<PaymentGatewayWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    getSquareURL();
  }

  Future<void> getSquareURL() async {
    setState(() {
      _loading = true;
    });
    List list = [];
    for (var res in widget._cartList) {
      print("res");
      print(res.id);

      list.add({
        "itemId": res.productId,
        "name": res.title,
        "qty": res.quantity,
        "price": res.price
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.post(
      body: jsonEncode({
        "id": 0,
        "userId":
            jsonDecode(prefs.getString("user").toString())["id"].toString(),
        "squareId": "string",
        "addressId": widget.id,
        "tempPaymentLineList": list
      }),
      Uri.parse(baseURL + "api/v1/temp"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        loadURL(response.body);
        _error = false;
      });
    } else {
      setState(() {
        _error = true;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void loadURL(url) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (url.startsWith("https://fire.com/payment-success/") ||
                url.startsWith("https://www.fire.com/payment-success/")) {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => OrderComplete(url.split("/").last)));

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderComplete(url,widget.id)));
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: secondaryColor,
            body: SafeArea(
                child: _error
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Something Went wrong !",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                                  "Go Back",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(children: [
                        WebViewWidget(controller: _controller),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: BackButtonWidget(),
                        )
                      ])));
  }
}
