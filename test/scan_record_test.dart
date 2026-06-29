import 'package:flutter_test/flutter_test.dart';
import 'package:smart_doc_ai/models/scan_record.dart';

void main() {
  group('ScanRecord', () {
    test('creates a preview from raw OCR text', () {
      final record = ScanRecord(
        id: '1',
        rawText: 'This is a sample OCR string for testing.',
        aiResult: 'Summary generated',
        mode: ScanMode.summarize,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(record.textPreview, contains('sample OCR string'));
      expect(record.textPreview.length, lessThanOrEqualTo(80));
    });

    test('cleans markdown markers from AI preview', () {
      final record = ScanRecord(
        id: '2',
        rawText: 'Some text',
        aiResult: '## Important\n*bullet* `code`',
        mode: ScanMode.qa,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(record.aiPreview, contains('Important'));
      expect(record.aiPreview, isNot(contains('#')));
      expect(record.aiPreview, isNot(contains('*')));
      expect(record.aiPreview, isNot(contains('`')));
    });

    test('buildPrompt returns mode-specific instructions', () {
      final prompt = ScanMode.translate.buildPrompt('hola');

      expect(prompt, contains('translate it to English'));
      expect(prompt, contains('hola'));
    });
  });
}
