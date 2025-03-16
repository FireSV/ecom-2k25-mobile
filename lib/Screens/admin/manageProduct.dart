import 'dart:convert';
import 'dart:io';
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  String? selectedCategory;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  bool isUpdating = false;
  int? selectedProductId;

  List<String> categories = [];
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    fetchCategories();
    fetchProducts();
    super.initState();
  }

  /// Fetch product categories
  Future<void> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(
      Uri.parse(baseURL + "api/v1/category/0/50"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        categories = (jsonDecode(response.body)["content"] as List)
            .map((res) => "${res["name"]} - ${res["id"]}")
            .toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Fetch products from API
  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(
      Uri.parse(baseURL + "api/v1/product/0/50"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        productList = List<Map<String, dynamic>>.from(
            jsonDecode(response.body)["content"]);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Pick Image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Submit or Update Product
  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token =
            jsonDecode(prefs.getString("user") ?? "{}")["accessToken"] ?? "";

        var request = http.MultipartRequest(
          isUpdating ? "PUT" : "POST",
          Uri.parse(baseURL + "api/v1/product"),
        );

        request.headers["Authorization"] = "Bearer $token";

        if (isUpdating) {
          request.fields["id"] = selectedProductId.toString();
        }

        request.fields["name"] = nameController.text;
        request.fields["createdUser"] =
            jsonDecode(prefs.getString("user").toString())["id"].toString();
        request.fields["description"] = descriptionController.text;
        request.fields["color"] = colorController.text;
        request.fields["price"] = priceController.text;
        request.fields["discount"] = discountController.text;
        request.fields["categoryId"] = selectedCategory!;

        if (_imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath("imageFile", _imageFile!.path));
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(isUpdating ? "Product updated successfully!" : "Product added successfully!")));
          fetchProducts();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Failed to save product.")));
        }
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
          isUpdating = false;
          _resetForm();
        });
      }
    }
  }

  /// Delete Product
  Future<void> deleteProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    var response = await http.delete(
      Uri.parse(baseURL + "api/v1/product/$productId"),
      headers: {
        "Authorization": "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully!")));
      fetchProducts();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete product.")));
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Reset Form
  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    colorController.clear();
    priceController.clear();
    discountController.clear();
    selectedCategory = null;
    _imageFile = null;
    selectedProductId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(title: Text("Manage Products")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                var product = productList[index];
                return ListTile(
                  title: Text(product["name"]),
                  subtitle: Text("Price: \$${product["price"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            nameController.text = product["name"];
                            descriptionController.text = product["description"];
                            colorController.text = product["color"];
                            priceController.text = product["price"].toString();
                            discountController.text = product["discount"].toString();
                            selectedCategory = product["categoryId"].toString();
                            selectedProductId = product["id"];
                            isUpdating = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteProduct(product["id"]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submitProduct,
            child: Text(isUpdating ? "Update Product" : "Add Product"),
          ),
        ],
      ),
    );
  }
}
