import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/address.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<Address> _addressList = [];
bool _loading = false;
int _id = 0;

class UserAddress extends StatefulWidget {
  const UserAddress({super.key});

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
        body: jsonEncode({
          "id": _id,
          "street": _streetController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "postalCode": _postalCodeController.text,
          "country": _countryController.text,
          "userId":
              jsonDecode(prefs.getString("user").toString())["id"].toString(),
          "street": _streetController.text,
        }),
        Uri.parse(baseURL + "api/v1/address"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _id = 0;
          _streetController.text = "";
          _cityController.text = "";
          _stateController.text = "";
          _postalCodeController.text = "";
          _countryController.text = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address saved successfully!')),
        );
        await getAll();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong !')),
        );
      }
    }
  }

  Future<void> removeAddress(int id) async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.delete(
      Uri.parse(baseURL + "api/v1/address/${id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete successfully !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong !')),
      );
    }
    await getAll();
    setState(() {
      _loading = false;
    });
  }

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
                res["userId"]));
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
    setState(() {
      _id = 0;
    });
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: secondaryColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BackButtonWidget(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                      _buildTextField(
                          _streetController, 'Street', Icons.location_on),
                      _buildTextField(
                          _cityController, 'City', Icons.location_city),
                      _buildTextField(_stateController, 'State', Icons.map),
                      _buildTextField(_postalCodeController, 'Postal Code',
                          Icons.markunread_mailbox),
                      _buildTextField(
                          _countryController, 'Country', Icons.flag),
                      SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: _saveAddress,
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   child: Text('Save Address', style: TextStyle(fontSize: 18)),
                      // ),

                      InkWell(
                        onTap: () async {
                          _saveAddress();
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
                            _id == 0 ? "Add" : "Update",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: _addressList.length,
                          itemBuilder: (context, index) {
                            var item = _addressList[index];
                            return InkWell(
                              onTap: () {
                                setState(() {

                                  _id = _addressList[index].id;
                                  _streetController.text =
                                      _addressList[index].street;
                                  _cityController.text = _addressList[index].city;
                                  _stateController.text =
                                      _addressList[index].state;
                                  _postalCodeController.text =
                                      _addressList[index].postalCode;
                                  _countryController.text =
                                      _addressList[index].country;
                                });
                              },
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: Text(item.street,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(item.city),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => removeAddress(
                                            _addressList[index].id),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          prefixIcon: Icon(
            icon,
            color: navigationIcon,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: navigationIcon, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: navigationIcon, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: navigationIcon, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
