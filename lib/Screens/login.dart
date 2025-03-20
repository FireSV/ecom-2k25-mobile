import 'dart:convert';

import 'package:fire_com/API/login.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Google/AuthService.dart';
import 'package:fire_com/Screens/admin/dashboard.dart';
import 'package:fire_com/Screens/forgetPassword.dart';
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
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if (jsonDecode(response.body)["user"]["roles"][0]["name"].toString() ==
          "ROLE_ADMIN") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
      }
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
                                      _password.text = "";
                                      _email.text = "";
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Otp(
                                                  response, "", "", false)));
                                      // setState(() {
                                      //   _loading=false;
                                      // });
                                      // SharedPreferences _prefs =
                                      //     await SharedPreferences.getInstance();
                                      // _prefs.setString("user", response.body);
                                      // _prefs.setString(
                                      //     "refreshToken",
                                      //     jsonDecode(
                                      //         response.body)["refreshToken"]);
                                      // _prefs.setString(
                                      //     "accessToken",
                                      //     jsonDecode(
                                      //         response.body)["accessToken"]);
                                      //
                                      // if (jsonDecode(response.body)["roles"][0]
                                      //         .toString() ==
                                      //     "ROLE_ADMIN") {
                                      //   Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Dashboard()),
                                      //     (route) => false,
                                      //   );
                                      // } else {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => Home()));
                                      // }
                                      //
                                      // const snackBar = SnackBar(
                                      //   content: Text('Login successfully !'),
                                      // );
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackBar);
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
                                    width: 250,
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
                                InkWell(
                                  onTap: () async {
                                    // final AuthService _authService =
                                    //     AuthService();
                                    //
                                    // await _authService.signOut();
                                    final AuthService _authService =
                                        AuthService();

                                    User? user =
                                        await _authService.signInWithGoogle();
                                    if (user != null) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      http.Response response =
                                          await login(user.email, user.uid);

                                      if (response.statusCode == 200) {
                                        SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefs.setString("user", response.body);
                                        _prefs.setString(
                                            "refreshToken",
                                            jsonDecode(
                                                response.body)["refreshToken"]);
                                        _prefs.setString(
                                            "accessToken",
                                            jsonDecode(
                                                response.body)["accessToken"]);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()),
                                          (route) => false,
                                        );
                                      } else {
                                        http.Response response = await signup(
                                            user.email,
                                            user.uid,
                                            user.displayName,
                                            "",
                                            "user");
                                        if (response.statusCode == 200) {
                                          http.Response response =
                                              await login(user.email, user.uid);

                                          if (response.statusCode == 200) {
                                            SharedPreferences _prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            _prefs.setString(
                                                "user", response.body);
                                            _prefs.setString(
                                                "refreshToken",
                                                jsonDecode(response.body)[
                                                    "refreshToken"]);
                                            _prefs.setString(
                                                "accessToken",
                                                jsonDecode(response.body)[
                                                    "accessToken"]);

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home()),
                                              (route) => false,
                                            );
                                          }
                                        } else {
                                          const snackBar = SnackBar(
                                            content:
                                                Text('Something went wrong !'),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    }
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
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/icons/google.png",
                                          scale: 40,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Google",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPassword()));
                                  },
                                  child: Text(
                                    "Forget Password",
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
