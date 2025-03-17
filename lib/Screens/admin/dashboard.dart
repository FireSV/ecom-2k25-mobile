import 'dart:convert' show jsonDecode;

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Screens/admin/addProduct.dart';
import 'package:fire_com/Screens/admin/orderPage.dart';
import 'package:fire_com/Screens/admin/square.dart';
import 'package:fire_com/Screens/login.dart' show Login;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalOrders = 0;
  int totalProducts = 0;

  // Example data for the current month
  double currentMonthSales = 0.0;
  int currentMonthOrders = 0;

  List<PieChartData> orderDistribution = [
    PieChartData('Electronics', 35, Colors.blue),
    PieChartData('Fashion', 25, Colors.red),
    PieChartData('Home & Kitchen', 20, Colors.green),
    PieChartData('Books', 10, Colors.orange),
    PieChartData('Other', 10, Colors.purple),
  ];

  Future<void> getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      Uri.parse(
          "${baseURL}api/v1/dashboard/${jsonDecode(prefs.getString("user").toString())["id"]}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        try {
          totalOrders =
              int.parse(jsonDecode(response.body)["totalOrder"].toString());
        } catch (e) {}
        try {
          totalProducts =
              int.parse(jsonDecode(response.body)["totalProduct"].toString());
        } catch (e) {}
        try {
          currentMonthSales = double.parse(
              jsonDecode(response.body)["thisMonthSales"].toString());
        } catch (e) {}
        try {
          currentMonthOrders =
              int.parse(jsonDecode(response.body)["thisMonthOrder"].toString());
        } catch (e) {}
      });
    }
  }

  @override
  void initState() {
    getDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await getDashboardData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await getDashboardData();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: navigationIcon,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                          width: 200,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              Center(
                                  child: Text(
                                "Refresh",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Dashboard Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoCard("Total Orders", totalOrders.toString(),
                          Icons.shopping_cart),
                      _infoCard("Total Products", totalProducts.toString(),
                          Icons.category),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Current Month's Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoCard("This Month's Orders",
                          currentMonthOrders.toString(), Icons.receipt_long),
                      _infoCard(
                          "This Month's Sales",
                          "\$${currentMonthSales.toStringAsFixed(2)}",
                          Icons.attach_money),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text("Order Distribution",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  // Pie Chart for Order Distribution
                  Container(
                    height: 300,
                    child: SfCircularChart(
                      legend: Legend(
                          isVisible: true, position: LegendPosition.bottom),
                      series: <CircularSeries>[
                        PieSeries<PieChartData, String>(
                          dataSource: orderDistribution,
                          xValueMapper: (PieChartData data, _) => data.category,
                          yValueMapper: (PieChartData data, _) =>
                              data.percentage,
                          pointColorMapper: (PieChartData data, _) =>
                              data.color,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Buttons for Adding Products and Viewing Orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _addProduct(),
                        icon: Icon(Icons.add),
                        label: Text("Add Product"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _viewOrders(),
                        icon: Icon(Icons.list),
                        label: Text("View Orders"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          _prefs.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                          );
                        },
                        icon: Icon(Icons.logout),
                        label: Text("Logout"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Square()));
                          },
                          icon: Icon(Icons.settings))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddProduct()));
  }

  void _viewOrders() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderPage()));
  }
}

/// Pie Chart Data Model
class PieChartData {
  final String category;
  final double percentage;
  final Color color;

  PieChartData(this.category, this.percentage, this.color);
}
