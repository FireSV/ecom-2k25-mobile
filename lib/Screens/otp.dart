import 'dart:convert';

import 'package:fire_com/Screens/login.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import '../API/BaseURL/baseURL.dart' show baseURL;
import '../Colors/ColorsLocal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/dashboard.dart';
import 'home.dart';

bool _loading = false;
String _otp = "";
String _otpText = "";
bool error = false;

class Otp extends StatefulWidget {
  http.Response? response;
  String email;
  String password;
  bool forget;

  Otp(this.response, this.email, this.password, this.forget, {super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  void initState() {
    setState(() {
      _loading = false;
      _otp = "";
      _otpText = "";
    });
    if (widget.forget) {
      sendOtpForForget();
    } else {
      sendOtp();
    }
    super.initState();
  }

  Future<void> sendOtp() async {
    http.Response response = await http.post(
      Uri.parse("${baseURL}api/auth/otp"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "email": jsonDecode(widget.response!.body)["email"].toString(),
        // Add form parameters here
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _otp = response.body;
        error = false;
      });
    } else {
      setState(() {
        error = true;
      });
    }
  }

  Future<void> sendOtpForForget() async {
    http.Response response = await http.post(
      Uri.parse("${baseURL}api/auth/otp"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "email": widget.email,
        // Add form parameters here
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _otp = response.body;
        error = false;
      });
    } else {
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: BackButtonWidget(),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OtpTextField(
                          numberOfFields: 6,
                          focusedBorderColor: Colors.green,
                          enabledBorderColor: navigationIcon,
                          borderColor: navigationIcon,
                          //set to true to show as box or false to show as dash
                          showFieldAsBox: true,
                          //runs when a code is typed in
                          onCodeChanged: (String code) {
                            setState(() {
                              _otpText = code;
                            });
                          },
                          onSubmit: (String verificationCode) {
                            setState(() {
                              _otpText = verificationCode;
                            });
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         title: Text("Verification Code"),
                            //         content: Text(
                            //             'Code entered is $verificationCode'),
                            //       );
                            //     });
                          }, // end onSubmit
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            if (!widget.forget) {
                              if (_otp == _otpText) {
                                _prefs.setString("user", widget.response!.body);
                                _prefs.setString(
                                    "refreshToken",
                                    jsonDecode(
                                        widget.response!.body)["refreshToken"]);
                                _prefs.setString(
                                    "accessToken",
                                    jsonDecode(
                                        widget.response!.body)["accessToken"]);
                                if (jsonDecode(widget.response!.body)["roles"]
                                            [0]
                                        .toString() ==
                                    "ROLE_ADMIN") {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }

                                const snackBar = SnackBar(
                                  content: Text('successfully !'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('Invalid Code '),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              if (_otp == _otpText) {
                                http.Response response = await http.post(
                                  Uri.parse("${baseURL}api/auth/reset"),
                                  headers: {
                                    "Content-Type": "application/json",
                                  },
                                  body: jsonEncode({
                                    "username": widget.email,
                                    "password": widget.password,
                                    // Add form parameters here
                                  }),
                                );
                                print(response.statusCode);
                                if (response.statusCode == 200) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                      (route) => false);
                                  const snackBar = SnackBar(
                                    content: Text('Password Reset Complete !'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text('Something went wrong !'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('Invalid OTP !'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: navigationIcon,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                            width: 250,
                            height: 45,
                            child: Center(
                                child: Text(
                              "Continue",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        )
                      ],
                    ),
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
