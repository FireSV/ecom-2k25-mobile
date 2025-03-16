import 'dart:convert';
import 'package:fire_com/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Screens/productView.dart';
import 'package:fire_com/Widget/cartButton.dart';

bool _initialLoad = false;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> productList = [];
  TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  bool _isFetchingMore = false;
  int _page = -1;
  final int _pageSize = 10;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetch() async {
    setState(() {
      _initialLoad = false;
    });
    await fetchProducts();
    setState(() {
      _initialLoad = true;
    });
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (_loading || _isFetchingMore) return;
    setState(() {
      if (isLoadMore) {
        _isFetchingMore = true;
      } else {
        _loading = true;
        productList.clear();
        _page = 0;
      }
    });
    setState(() {
      _loading = false;
      _isFetchingMore = false;
      if (isLoadMore) _page++;
    });
    if ((_page == 0 && !_initialLoad) || _page != 0) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token =
            jsonDecode(prefs.getString("user").toString())["accessToken"];

        final response = await http.post(
          Uri.parse(baseURL + "api/v1/product/search/$_page/$_pageSize"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer $token",
          },
          body: {"name": _searchController.text},
        );

        print(response.body);

        if (response.statusCode == 200) {
          List<dynamic> jsonData = jsonDecode(response.body);

          setState(() {
            productList = jsonData
                .map((item) => Product.fromJson(item as Map<String, dynamic>))
                .toList();
          });
        } else {
          print("Failed to fetch data: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  // Scroll listener to load more data when reaching the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isFetchingMore) {
      fetchProducts(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      setState(() {
                        _page = -1;
                        _initialLoad = false;
                      });
                      await fetchProducts();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : productList.isEmpty
                      ? Center(child: Text("No products available"))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: productList.length + 1,
                          // +1 for loader
                          itemBuilder: (context, index) {
                            if (index == productList.length) {
                              return _isFetchingMore
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox(); // Empty space when no more data
                            }

                            Product product = productList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductView(product),
                                  ),
                                );
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
                                          productList[index].image,
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
                                            productList[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "${(productList[index].price == null || productList[index].price == "null") ? "0.00" : productList[index].price}",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          Text(
                                            "Shop : ${product.user.firstName}",
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
            // Positioned(top: 20, right: 20, child: CartButton()),
          ],
        ),
      ),
    );
  }
}
