import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:snuggle_tales/secrets/api_key.dart';

// Constants for API
const String openApiBaseUrl = 'https://api.openai.com/v1/';
const Map<String, String> openApiHeaders = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $openApiKey',
};

// Function to get a response from the ChatGPT model
Future<String> getChatGPTResponse(String userMessage) async {
  try {
    final response = await http.post(
      Uri.parse("${openApiBaseUrl}chat/completions"),
      headers: openApiHeaders,
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'max_tokens': 500,
        'messages': [
          {"role": "system", "content": "You are a storyteller for children"},
          {
            "role": "user",
            "content":
                "Short bed time story less than 200 words for children. $userMessage. no index. use paragraphs. add a title, but don't use the text Title:"
          },
        ],
      }),
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String story = data['choices'][0]['message']['content'];
      return story;
    } else {
      // Handle failure to load response (non-200 status code)
      if (kDebugMode) {
        print(
            'Failed to load ChatGPT response. Status code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to load ChatGPT response');
    }
  } catch (e) {
    // Handle general errors
    if (kDebugMode) {
      print('Error getting ChatGPT response: $e');
    }
    rethrow; // Re-throw the exception for further handling if needed
  }
}

Future<String> getImageResponse(String query) async {
  try {
    final response = await http.post(
      Uri.parse('${openApiBaseUrl}images/generations'),
      headers: openApiHeaders,
      body: jsonEncode({
        'model': 'dall-e-3',
        'n': 1,
        'style': 'vivid',
        'response_format': 'b64_json',
        'prompt': query,
      }),
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("image generated successfully");
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'][0]['b64_json'];
    } else {
      // Handle failure to load response (non-200 status code)
      if (kDebugMode) {
        print('Failed to create image. Status code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to create image');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error getting Dall-e response: $e');
    }
    rethrow;
  }
}
