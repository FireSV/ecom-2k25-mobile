import 'dart:convert';

import 'package:fire_com/API/BaseURL/baseURL.dart';
import 'package:http/http.dart' as http;

Future<http.Response> signup(
    username, password, firstName, lastName, String? selectedRole) async {
  print({
    "username": username,
    "email": username,
    "role": selectedRole == null ? ["user"] : [selectedRole.toString().toLowerCase()],
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": "string",
    "address": "string",
    "postalCode": "string",
    "password": password
  });
  http.Response response = await http.post(
    Uri.parse(baseURL + "api/auth/signup"),
    body: jsonEncode({
      "username": username,
      "email": username,
      "role": selectedRole == null ? ["user"] : [selectedRole.toString().toLowerCase()],
      "firstName": firstName,
      "lastName": lastName,
      "mobileNumber": "string",
      "address": "string",
      "postalCode": "string",
      "password": password
    }),
    headers: {
      "Content-Type": "application/json",
    },
  );
  return response;
}

Future<http.Response> login(username, password) async {
  http.Response response = await http.post(
    Uri.parse(baseURL + "api/auth/signin"),
    body: jsonEncode({"username": username, "password": password}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  return response;
}

Future<http.Response> refreshToken(token) async {
  http.Response response = await http.post(
    Uri.parse(baseURL + "api/auth/refreshtoken"),
    body: jsonEncode({"refreshToken": token}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  return response;
}
