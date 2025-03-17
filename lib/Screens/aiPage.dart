import 'dart:convert';

import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

TextEditingController _aiSearch = TextEditingController();

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                "Work With AI",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: _aiSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write what do you need ...",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              final String apiKey = '';
              final String apiUrl = 'https://api.openai.com/v1/chat/completions';

              final List<Map<String, String>> categories = [
                {"id": "1", "name": "kitchen"},
                {"id": "2", "name": "watch"},
                {"id": "3", "name": "computer"},
              ];

              try {
                final response = await http.post(
                  Uri.parse(apiUrl),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $apiKey',
                  },
                  body: jsonEncode({
                    "model": "gpt-3.5-turbo",
                    "messages": [
                      {"role": "system", "content": "Match user input to the closest category name and return only the numeric category ID."},
                      {"role": "user", "content": "User input: '${_aiSearch.text}'. Categories: ${jsonEncode(categories)}. Return only the matching category ID as a number."}
                    ]
                  }),
                );
                print(response.body);
                print(response.statusCode);
                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  final String reply = data['choices'][0]['message']['content'];
                  // return int.tryParse(reply) ?? -1;
                  print(int.tryParse(reply) ?? -1);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.body)),
                  );
                  throw Exception('Failed to get category ID');
                }
              } catch (e) {

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("${e}")),
                // );
                //
                print(e); // Log error
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: navigationIcon,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 3)),
              width: 200,
              height: 45,
              child: Center(
                  child: Text(
                "Let's Go",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
          )
        ],
      )),
    );
  }
}
