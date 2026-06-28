import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqApiService {
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  Future<String> generateContent(String prompt) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.1-8b-instant',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful document analysis assistant. '
                'Respond in clear, well-formatted markdown.',
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': 1024,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['choices'][0]['message']['content'] as String;
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit — wait a moment and retry.');
    } else {
      throw Exception('Groq error: ${response.statusCode} ${response.body}');
    }
  }
}