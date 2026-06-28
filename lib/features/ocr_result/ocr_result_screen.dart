import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ocr_provider.dart';
import '../../providers/ai_provider.dart';
import '../../models/scan_record.dart';
import '../ai_analysis/ai_analysis_screen.dart';

class OcrResultScreen extends ConsumerWidget {
  const OcrResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrProvider);
    final selectedMode = ref.watch(selectedModeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Extracted Text'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Extracted text box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Extracted Text',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: ocrState.extractedText,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Extracted text will appear here...',
                    ),
                    onChanged: (value) {
                      ref.read(ocrProvider.notifier).updateText(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mode selection title
            const Text(
              'Select AI Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),

            const SizedBox(height: 12),

            // Mode chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ScanMode.values.map((mode) {
                final isSelected = selectedMode == mode;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${mode.emoji} ${mode.label}'),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedModeProvider.notifier).state = mode;
                    },
                    selectedColor: const Color(0xFF6C63FF),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Analyze button
            ElevatedButton.icon(
              onPressed: ocrState.hasText
                  ? () => _analyze(context, ref, ocrState, selectedMode)
                  : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analyze with AI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Error message
            if (ocrState.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                ocrState.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _analyze(
    BuildContext context,
    WidgetRef ref,
    OcrState ocrState,
    ScanMode mode,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiAnalysisScreen(
          ocrText: ocrState.extractedText,
          mode: mode,
        ),
      ),
    );
  }
}