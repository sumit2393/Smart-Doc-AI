import '../core/api/groq_api_service.dart';
import '../models/scan_record.dart';

class GroqRepository {
  final GroqApiService _groqService;

  GroqRepository(this._groqService);

  Future<String> analyzeText(String ocrText, ScanMode mode) async {
    try {
      final prompt = _buildPrompt(ocrText, mode);
      final result = await _groqService.generateContent(prompt);
      return result;
    } catch (e) {
      throw Exception('Analysis failed: $e');
    }
  }

  String _buildPrompt(String ocrText, ScanMode mode) {
    switch (mode) {
      case ScanMode.summarize:
        return '''You are a document analysis expert.
Summarize the following document in clear bullet points.
Highlight the most important information.
Be concise and accurate.

Document:
$ocrText''';

      case ScanMode.translate:
        return '''You are a translation expert.
1. Detect the language of the following text
2. Translate it to English
3. Provide a brief summary in bullet points

Text:
$ocrText''';

      case ScanMode.qa:
        return '''You are a document analysis expert.
Analyze the following document and answer:
- Who is involved?
- What is it about?
- When? (dates/deadlines)
- Where? (locations)
- Any action items or important points?

Document:
$ocrText''';
    }
  }

  void dispose() {}
}