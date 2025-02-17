import 'dart:convert';

import 'package:fire_com/API/login.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Screens/home.dart';
import 'package:fire_com/Screens/signUp.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool _loading = false;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    setState(() {
      _loading = false;
    });
    checkCredentials();
    super.initState();
  }

  Future<void> checkCredentials() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    http.Response response =
        await refreshToken(_prefs.getString("refreshToken"));
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false, // Removes all previous routes
      );
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
          child: _loading
              ? Loading()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        "assets/icons/logo1.png",
                        scale: 3,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome back ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: TextField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: TextField(
                                  obscureText: true,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _loading = true;
                                    });
                                    http.Response response = await login(
                                        _email.text, _password.text);
                                    print(response.body);
                                    if (response.statusCode == 200) {
                                      // setState(() {
                                      //   _loading=false;
                                      // });
                                      SharedPreferences _prefs =
                                          await SharedPreferences.getInstance();
                                      _prefs.setString("user", response.body);
                                      _prefs.setString(
                                          "refreshToken",
                                          jsonDecode(
                                              response.body)["refreshToken"]);
                                      _prefs.setString(
                                          "accessToken",
                                          jsonDecode(
                                              response.body)["accessToken"]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()));
                                      const snackBar = SnackBar(
                                        content: Text('Login successfully !'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      const snackBar = SnackBar(
                                        content: Text('Login Failed !'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    setState(() {
                                      _loading = false;
                                    });
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
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Not a member ? ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: Text(
                                    "Sign up ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: linkColors),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
