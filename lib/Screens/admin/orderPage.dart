import 'dart:convert';
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/order.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
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

    setState(() => isLoading = true);

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
            hasMore = false;
          } else {
            orders.addAll(fetchedOrders);
            page++; // Increment page for next load
          }
        });
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      print("Network Error: $e");
      setState(() {
        hasMore = false;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchOrders();
    }
  }

  void _showChangeStatusDialog(Order order) {
    print(order.status);
    String? selectedStatus = (order.status == null || order.status == "null")
        ? "Preparing"
        : order.status == "1"
            ? "Preparing"
            : order.status == "2"
                ? "Shipped"
                : order.status == "3"
                    ? "Delivered"
                    : "Cancelled";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Change Order Status"),
              content: DropdownButton<String>(
                value: selectedStatus,
                onChanged: (newStatus) {
                  setDialogState(() {
                    selectedStatus = newStatus!;
                  });
                },
                items: ["Preparing", "Shipped", "Delivered", "Cancelled"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print(selectedStatus);
                    await _updateOrderStatus(
                        order.id,
                        selectedStatus == "Preparing"
                            ? 1
                            : selectedStatus == "Shipped"
                                ? 2
                                : selectedStatus == "Delivered"
                                    ? 3
                                    : 4);
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateOrderStatus(int orderId, int newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String accessToken =
          jsonDecode(prefs.getString("user") ?? '{}')["accessToken"] ?? '';

      final response = await http.get(
        Uri.parse("${baseURL}api/v1/order/status/$orderId/$newStatus"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          orders.firstWhere((order) => order.id == orderId).status =
              newStatus.toString();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated successfully!")),
        );
      } else {
        throw Exception(
            "Failed to update order status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order: $e")),
      );
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: BackButtonWidget(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "My Orders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: orders.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == orders.length) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(

                      ),
                    );
                  }
                  final order = orders[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          "Order #${order.id} - ${(order.status == null || order.status == "1") ? "Preparing" : order.status == "2" ? "Shipped" : order.status == "3" ? "Delivered" : "Cancelled"}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "Total: \$${order.total.toStringAsFixed(2)}\nOrder Date: ${order.createdAt}"),
                        leading:
                             Icon(Icons.shopping_bag, color: navigationIcon),
                        onExpansionChanged: (expanded) {
                          if (expanded) _showChangeStatusDialog(order);
                        },
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
      ),
    );
  }
}
