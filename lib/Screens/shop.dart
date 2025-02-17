import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';
import 'package:deepseek/deepseek.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: headerNavigation,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  style: TextStyle(color: text3),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(color: textHint),
                      suffixIcon: InkWell(
                        onTap: () async {
                          final deepSeek = DeepSeek("sk-b7f7cf5d547f4821bd1f914c709216df");
                          print('ss');

                          // try {
                          //   // 🔹 Create a chat completion -> https://api-docs.deepseek.com/api/create-chat-completion
                          //   Completion response = await deepSeek.createChat(
                          //     messages: [Message(role: "user", content: "Hello, how are you?")],
                          //     model: Models.chat,
                          //     options: {
                          //       "temperature": 1.0,
                          //       "max_tokens": 4096,
                          //     },
                          //   );
                          //   print("Chat Response: ${response.text}");
                          //
                          //   // 🔹 List available models
                          //   List<Models> models = await deepSeek.listModels();
                          //   print("Available Models: $models");
                          //
                          //   // 🔹 Get user balance
                          //   Balance balance = await deepSeek.getUserBalance();
                          //   print("User Balance: ${balance.info}");
                          // } catch (e) {
                          //   print("Error: $e");
                          // }


                          Gemini.instance.prompt(parts: [
                            Part.text('one plus three ?'),
                          ]).then((value) {
                            print(value?.output);
                          }).catchError((e) {
                            print('error ${e}');
                          });
                        },
                        child: Icon(
                          Icons.search,
                          color: text3,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
