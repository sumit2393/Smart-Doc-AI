import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  Future<String> generateContent(String prompt) async {
    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    }),
  );
if (response.statusCode == 429) {
  throw Exception(
    'Rate limit exceeded. Wait 1 minute and try again.',
  );
}

if (response.statusCode != 200) {
  throw Exception('Gemini error: ${response.statusCode} ${response.body}');
}
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['candidates'][0]['content']['parts'][0]['text'] as String;
  } else {
    throw Exception('Gemini error: ${response.statusCode} ${response.body}');
  }
}
}