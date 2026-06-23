import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ocr_provider.dart';
import '../../providers/ai_provider.dart';
import '../../models/scan_record.dart';
import '../ai_analysis/ai_analysis_screen.dart';

class OcrResultScreen extends StatelessWidget {
  const OcrResultScreen({super.key});

  final ocrState= ref.watch(ocrProvider);
  final selectedMode= ref.watch(selectedModeProvider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Text'),
         backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(context, ref, ocrState, selectedMode),
    );
  }

  Widget _buildBody(
  BuildContext context,
  WidgetRef ref,
  OcrState ocrState,
  ScanMode selectedMode,
) {
  return SingleChildScrollView(
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

        // Mode selection
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
        Row(
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
                  color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
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
      ],
    ),
  );
}