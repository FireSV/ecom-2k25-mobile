import 'package:fire_com/API/login.dart';
import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Screens/login.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:fire_com/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _firstName = TextEditingController();
TextEditingController _lastName = TextEditingController();
bool _loading = false;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    setState(() {
      _lastName.text = "";
      _firstName.text = "";
      _password.text = "";
      _email.text = "";
      _loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  _loading
        ? Loading()
        :Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: BackButtonWidget(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
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
                        "Sign UP",
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _firstName,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
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
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _lastName,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
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
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async {
                                setState(() {
                                  _loading = true;
                                });
                                http.Response response = await signup(
                                    _email.text,
                                    _password.text,
                                    _firstName.text,
                                    _lastName.text);
                                print(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                  const snackBar = SnackBar(
                                    content: Text('Register successfully !'),
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
                                  "Register",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
