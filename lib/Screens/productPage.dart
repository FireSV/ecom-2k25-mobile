import 'package:fire_com/Screens/productView.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:fire_com/Widget/cartButton.dart';
import 'package:flutter/material.dart';
import 'package:fire_com/Model/top_service_model.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final TopServiceModel topServiceModel;

  const ProductPage(this.topServiceModel, {super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      productList = [];
    });
    try {
      for (var res in widget.topServiceModel?.res["product"]) {
        setState(() {
          productList.add({
            "id": res["id"].toString(),
            "name": res["name"].toString(),
            "image": res["image"],
            "price": "\$${res["price"]}",
            "fullDetails": "${res}"
          });
        });
      }
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0], // Gradient transition points
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    widget.topServiceModel.image,
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/common/no_image.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  // left: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: Colors.black54,
                    child: Text(
                      widget.topServiceModel.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(top: 20, left: 20, child: BackButtonWidget()),
                Positioned(top: 20, right: 20, child: CartButton()),
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productList.isEmpty
                      ? Center(child: Text("No products available"))
                      : GridView.builder(
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 10, // Space between columns
                            mainAxisSpacing: 10, // Space between rows
                            childAspectRatio:
                                0.75, // Adjust to control card size
                          ),
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> product = productList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductView(product)));
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: Image.network(
                                          product["image"],
                                          width: double.infinity,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/common/no_image.jpg',
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Text(
                                            product["name"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            product["price"],
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
