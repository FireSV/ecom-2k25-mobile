import 'dart:convert';
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/order.dart' show Order;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orders = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 0;
  int pageSize = 10;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchOrders() async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse("${baseURL}api/v1/order/$page/$pageSize"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${jsonDecode(prefs.getString("user") ?? '{}')["accessToken"] ?? ''}",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> data = responseData["content"] ?? [];

        List<Order> fetchedOrders =
            data.map((json) => Order.fromJson(json)).toList();

        setState(() {
          if (fetchedOrders.isEmpty) {
            hasMore = false; // No more data
          } else {
            orders.addAll(fetchedOrders);
            page++; // Increase page number
          }
          isLoading = false;
        });
      } else {
        print("API Error: ${response.statusCode}");
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      print("Network Error: $e");
      setState(() {
        isLoading = false;
        hasMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "My Orders",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: orders.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == orders.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final order = orders[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: Text(
                          "Order #${order.id}  ${(order.status == "null" || order.status == null || order.status == "1") ? "Preparing" : order.status == "2" ? "Shipped" : order.status == "3" ? "Delivered" : "Cancelled"} \nTotal : ${order.total.toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Order Date : ${order.createdAt}"),
                      leading: Icon(Icons.shopping_bag, color: navigationIcon),
                      children: order.orderLines.map((orderLine) {
                        return ListTile(
                          title: Text(orderLine.itemName),
                          subtitle: Text("Quantity: ${orderLine.quantity}"),
                          trailing:
                              Text("\$${orderLine.price.toStringAsFixed(2)}"),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
