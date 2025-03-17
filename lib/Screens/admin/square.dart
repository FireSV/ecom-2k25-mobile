import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int _id = 0;

class Square extends StatefulWidget {
  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  List<dynamic> squareKeysList = [];
  bool isLoading = true;

  @override
  void initState() {
    setState(() {
      _id = 0;
    });
    super.initState();
    fetchSquareKeys();
  }

  Future<void> fetchSquareKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        "${baseURL}api/v1/square/user/${jsonDecode(prefs.getString("user").toString())["id"]}";
    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        // Convert object to list if it's a single entry
        if (jsonResponse is Map<String, dynamic>) {
          squareKeysList = [jsonResponse]; // Wrap it in a list
        } else if (jsonResponse is List) {
          squareKeysList = jsonResponse; // Assign directly
        } else {
          squareKeysList = [];
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data")),
      );
    }
  }

  Future<void> deleteSquareKey(int id) async {}

  void showForm({Map<String, dynamic>? data}) {
    // TextEditingController userIdController =
    // TextEditingController(text: data?['userId']?.toString() ?? "");
    setState(() {
      try {
        _id = data?["id"];

      } catch (e) {
        _id = 0;
      }
    });
    TextEditingController locationIdController =
        TextEditingController(text: data?['locationId'] ?? "");
    TextEditingController accessTokenController =
        TextEditingController(text: data?['accessToken'] ?? "");
    TextEditingController currencyController =
        TextEditingController(text: data?['currency'] ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data == null ? "Add Square Key" : "Edit Square Key",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // TextFormField(
              //   controller: userIdController,
              //   decoration: InputDecoration(labelText: "User ID"),
              //   keyboardType: TextInputType.number,
              // ),
              TextFormField(
                controller: locationIdController,
                decoration: InputDecoration(labelText: "Location ID"),
              ),
              TextFormField(
                controller: accessTokenController,
                decoration: InputDecoration(labelText: "Access Token"),
              ),
              TextFormField(
                controller: currencyController,
                decoration: InputDecoration(labelText: "Currency"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  final Map<String, dynamic> formData = {
                    "id":_id,
                    "userId":
                        "${jsonDecode(prefs.getString("user").toString())["id"]}",
                    "locationId": locationIdController.text,
                    "accessToken": accessTokenController.text,
                    "currency": currencyController.text
                  };
                  print(formData);

                  // if (data == null) {
                    // Add new record
                    final response = await http.post(
                      Uri.parse("${baseURL}api/v1/square"),
                      body: jsonEncode(formData),
                      headers: {"Content-Type": "application/json",
                        "Authorization":
                        "Bearer ${jsonDecode(prefs.getString("user").toString())["accessToken"]}",
                      },
                    );
                    print('aaa');
                    print(response.statusCode);
                    print(response.body);
                    if (response.statusCode == 200) {
                      const snackBar = SnackBar(
                        content: Text('successfully !'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      fetchSquareKeys();
                      Navigator.pop(context);

                    }else{
                      const snackBar = SnackBar(
                        content: Text('Failed !'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }
                  // } else {
                  //   // Update existing record
                  //   final response = await http.post(
                  //     Uri.parse("${baseURL}api/v1/square"),
                  //     body: jsonEncode(formData),
                  //     headers: {"Content-Type": "application/json"},
                  //   );
                  //   print('aaa');
                  //   if (response.statusCode == 200) {
                  //     fetchSquareKeys();
                  //     Navigator.pop(context);
                  //   }
                  // }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Square Keys")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : squareKeysList.isEmpty
              ? Center(child: Text("No Square Keys Found"))
              : ListView.builder(
                  itemCount: squareKeysList.length,
                  itemBuilder: (context, index) {
                    final item = squareKeysList[index];
                    return Card(
                      child: ListTile(
                        title: Text("User ID: ${item['userId']}"),
                        subtitle: Text("Currency: ${item['currency']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showForm(data: item),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
