import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snuggle_tales/secrets/api_key.dart';

Future<String> getChatGPTResponse(String userMessage) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo', // Specify the model here
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print('Failed to load response. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load response');
    }
  } catch (e) {
    print('Error getting ChatGPT response: $e');
    throw e; // Re-throw the exception for further handling if needed
  }
}
