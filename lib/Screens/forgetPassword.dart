import 'dart:convert';

import 'package:fire_com/API/login.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Google/AuthService.dart';
import 'package:fire_com/Screens/admin/dashboard.dart';
import 'package:fire_com/Screens/home.dart';
import 'package:fire_com/Screens/otp.dart';
import 'package:fire_com/Screens/signUp.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool _loading = false;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  void initState() {
    setState(() {
      _loading = false;
      _password.text = "";
      _email.text = "";
    });
    super.initState();
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
                            "Forget Password",
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Otp(
                                                null,
                                                _email.text,
                                                _password.text,
                                                true)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: navigationIcon,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    width: 250,
                                    height: 45,
                                    child: Center(
                                        child: Text(
                                      "Forget Password",
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
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: navigationIcon,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    width: 250,
                                    height: 45,
                                    child: Center(
                                        child: Text(
                                      "Back",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
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
