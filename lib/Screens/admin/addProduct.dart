import 'dart:convert';
import 'dart:io';
import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _loading = false;
List<Product> _productList = [];
int _id = 0;

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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

  List<String> categories = [];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _edit(Product product) async {
    // _id
    setState(() {
      _id = int.tryParse(product.id)!;
      nameController.text = product.name;
      descriptionController.text = product.description;
      colorController.text = product.color;
      priceController.text = product.price.toString();
      discountController.text = product.discount.toString();
      selectedCategory = product.categoryId.toString();
    });
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_id == 0) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token =
              jsonDecode(prefs.getString("user") ?? "{}")["accessToken"] ?? "";

          var request = http.MultipartRequest(
              "POST", Uri.parse("${baseURL}api/v1/product"));
          request.headers["Authorization"] = "Bearer $token";

          request.fields["name"] = nameController.text;
          request.fields["createdUser"] =
              jsonDecode(prefs.getString("user").toString())["id"].toString();
          request.fields["description"] = descriptionController.text;
          request.fields["color"] = colorController.text;
          request.fields["price"] = priceController.text;
          request.fields["discount"] = discountController.text;
          request.fields["categoryId"] = selectedCategory!;

          if (_imageFile != null) {
            request.files.add(await http.MultipartFile.fromPath(
                "imageFile", _imageFile!.path));
          }

          var response = await request.send();

          if (response.statusCode == 200) {
            await getProduct();
            setState(() {
              _id = 0;
              nameController.text = "";
              descriptionController.text = "";
              colorController.text = "";
              priceController.text = "";
              discountController.text = "";
              selectedCategory = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product added successfully!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to add product.")));
          }
        } catch (e) {
          print("Error: $e");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Something went wrong.")));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token =
              jsonDecode(prefs.getString("user") ?? "{}")["accessToken"] ?? "";

          var request = http.MultipartRequest(
              "PUT", Uri.parse("${baseURL}api/v1/product"));
          request.headers["Authorization"] = "Bearer $token";

          request.fields["id"] = _id.toString();
          request.fields["name"] = nameController.text;
          request.fields["createdUser"] =
              jsonDecode(prefs.getString("user").toString())["id"].toString();
          request.fields["description"] = descriptionController.text;
          request.fields["color"] = colorController.text;
          request.fields["price"] = priceController.text;
          request.fields["discount"] = discountController.text;
          request.fields["categoryId"] = selectedCategory!;

          if (_imageFile != null) {
            request.files.add(await http.MultipartFile.fromPath(
                "imageFile", _imageFile!.path));
          }

          var response = await request.send();

          if (response.statusCode == 200) {
            await getProduct();
            setState(() {
              _id = 0;
              nameController.text = "";
              descriptionController.text = "";
              colorController.text = "";
              priceController.text = "";
              discountController.text = "";
              selectedCategory = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product update successfully!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to add product.")));
          }
        } catch (e) {
          print("Error: $e");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Something went wrong.")));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
        setState(() {
          _id = 0;
        });
      }
    }
  }

  @override
  void initState() {
    category();
    getProduct();
    setState(() {
      _id = 0;
      selectedCategory = null;
    });
    super.initState();
  }

  Future<void> getProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      Uri.parse(baseURL +
          "api/v1/product/user/${jsonDecode(prefs.getString("user").toString())["id"]}/0/10"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> jsonData = jsonDecode(response.body)["content"];

        setState(() {
          _productList = jsonData
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        });
      });
    }
  }

  Future<void> category() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        categories.clear();
      });

      setState(() {
        categories.addAll(
          (jsonDecode(response.body)["content"] as List)
              .map((res) => "${res["name"]} - ${res["id"]}")
              .toList(),
        );
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BackButtonWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        // Product Name
                        TextFormField(
                          controller: nameController,
                          decoration:
                              InputDecoration(labelText: "Product Name"),
                          validator: (value) =>
                              value!.isEmpty ? "Enter product name" : null,
                        ),
                        SizedBox(height: 10),

                        // Description
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: 3,
                          validator: (value) =>
                              value!.isEmpty ? "Enter description" : null,
                        ),
                        SizedBox(height: 10),

                        // Color
                        TextFormField(
                          controller: colorController,
                          decoration: InputDecoration(labelText: "Color"),
                          validator: (value) =>
                              value!.isEmpty ? "Enter color" : null,
                        ),
                        SizedBox(height: 10),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: "Category"),
                          value: selectedCategory,
                          onChanged: (value) =>
                              setState(() => selectedCategory = value),
                          validator: (value) =>
                              value == null ? "Select a category" : null,
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category.split(" - ")[1],
                              child: Text(category.split(" - ")[0]),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),

                        // Price
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(labelText: "Price"),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Enter price" : null,
                        ),
                        SizedBox(height: 10),

                        // Discount
                        TextFormField(
                          controller: discountController,
                          decoration:
                              InputDecoration(labelText: "Discount (%)"),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Enter discount or 0" : null,
                        ),
                        SizedBox(height: 10),

                        // Image Picker
                        Row(
                          children: [
                            InkWell(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: navigationIcon,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                    Border.all(color: Colors.white, width: 3)),
                                width: 150,
                                height: 45,
                                child: Center(
                                    child: Text(
                                      "Upload Image",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                            // ElevatedButton.icon(
                            //   onPressed: _pickImage,
                            //   icon: Icon(Icons.image),
                            //   label: Text("Upload Image"),
                            // ),
                            SizedBox(width: 10),
                            _imageFile != null
                                ? Image.file(_imageFile!,
                                    width: 100, height: 100, fit: BoxFit.cover)
                                : Text("No image selected"),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Submit Button
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: isLoading ? null : _submitProduct,
                        //     child: isLoading
                        //         ? CircularProgressIndicator(color: Colors.white)
                        //         : Text(_id == 0
                        //             ? "Add Product"
                        //             : "Update Product"),
                        //   ),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: isLoading ? null : _submitProduct,
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
                                  _id == 0 ? "Add Product" : "Update Product",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: _productList
                          .map((product) => ListTile(
                              title: Text(product.name),
                              subtitle: Text("Price: \$${product.price}"),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _edit(product))))
                          .toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
