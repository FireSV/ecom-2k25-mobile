import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      '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';
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<int> getCategoryID(String category) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {
              "role": "user",
              "content":
                  "Assign a numeric category ID to: $category. Only return the ID as a number."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String reply = data['choices'][0]['message']['content'];
        return int.tryParse(reply) ?? -1;
      } else {
        throw Exception('Failed to fetch category ID');
      }
    } catch (e) {
      print(e);
      return -1; // Error case
    }
  }
}
