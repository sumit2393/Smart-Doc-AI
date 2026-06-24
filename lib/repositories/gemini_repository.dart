import '../core/api/gemini_api_service.dart';
import '../models/scan_record.dart';

class GeminiRepository {
  // Use dynamic to avoid strict dependency on exact method name in GeminiApiService
  final dynamic _geminiService;

  GeminiRepository(this._geminiService);

  Future<String> analyzeText(String ocrText, ScanMode mode) async {
    try {
      final prompt = _buildPrompt(ocrText, mode);
      final result = await _geminiService.generateContent(prompt);
      return result;
    } catch (e) {
      throw Exception('Analysis failed: $e');
    }
  }

  void dispose() {
    // No resources to dispose in this repository, but method is here for consistency
  }
}

String _buildPrompt(String ocrText, ScanMode mode) {
  switch (mode) {
    case ScanMode.summarize:
      return 'Summarize the following text in clear bullet points:\n\n$ocrText';
    
    case ScanMode.translate:
      return 'Detect the language and translate to English, then summarize:\n\n$ocrText';
    
    case ScanMode.qa:
      return 'Analyze this text and answer: Who? What? When? Where? Any action items?\n\n$ocrText';
  }
  }
