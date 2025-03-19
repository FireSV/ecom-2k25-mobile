import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/cart.dart';
import 'package:fire_com/Screens/deliveryMethod.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<Cart> _cartList = [];
bool _loading = false;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double getTotalPrice() {
    return _cartList.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void updateQuantity(int index, int change, Cart cartList) {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (_cartList[index].quantity + change > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        http.Response response = await http.post(
          body: jsonEncode({
            "id": _cartList[index].id.toString(),
            "productId": cartList.productId.toString(),
            "qty": _cartList[index].quantity + change,
            "userId":
                jsonDecode(prefs.getString("user").toString())["id"].toString(),
          }),
          Uri.parse(baseURL + "api/v1/cart"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
          },
        );
        if (response.statusCode == 200) {
          setState(() {
            _cartList[index].quantity += change;
          });
          const snackBar = SnackBar(content: Text('Update successfully !'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(content: Text('Something went wrong !'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  void removeItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = _cartList[index].id.toString();

    try {
      http.Response response = await http.delete(
        Uri.parse("${baseURL}api/v1/cart/remove/${id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
        },
      );
      print("response.body");
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _cartList.removeAt(index);
        });
      } else {
        print("Failed to remove item: ${response.body}");
      }
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      Uri.parse(
          "${baseURL}api/v1/cart/${jsonDecode(prefs.getString("user").toString())["id"]}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _cartList.clear();
      });
      for (var item in jsonDecode(response.body)) {
        setState(() {
          try {
            _cartList.add(Cart(
                item["id"],
                item["product"]["id"],
                item["product"]["name"].toString(),
                item["product"]["price"] == null
                    ? 0.00
                    : double.parse(item["product"]["price"].toString()),
                double.parse(item["qty"].toString()),
                item["product"]["image"].toString()));
          } catch (e) {
            print("Error: $e");
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: _cartList.length == 0
            ? Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cart is empty !",
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
                                "Go to Shopping",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, top: 20),
                        child: BackButtonWidget(),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartList.length,
                      itemBuilder: (context, index) {
                        var item = _cartList[index];
                        return Card(
                          color: Colors.white,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/common/no_image.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            title: Text(item.title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            subtitle:
                                Text("\$${item.price.toStringAsFixed(2)}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () => updateQuantity(
                                      index, -1, _cartList[index]),
                                ),
                                Text("${item.quantity}",
                                    style: TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () => updateQuantity(
                                      index, 1, _cartList[index]),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeItem(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 25,
                      bottom: 30,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white, // Top color
                          Colors.grey[300]!, // Bottom color
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("\$${getTotalPrice().toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ],
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryMethod(_cartList)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: navigationIcon,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                            width: 300,
                            height: 45,
                            child: Center(
                                child: Text(
                              "Checkout",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Read Terms and conditions ! ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
