import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_doc_ai/providers/ocr_provider.dart';
import 'package:smart_doc_ai/features/ocr_result/ocr_result_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ocrProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Icon(
            Icons.document_scanner_outlined,
            size: 100,
            color: Color(0xFF6C63FF),
          ),
          const SizedBox(height: 24),
          Text('Smart Doc AI',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF))),
          const SizedBox(height: 48),
          // Camera Button
          ElevatedButton.icon(
            onPressed: () => _pickImage(context, ref, ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Scan with Camera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _pickImage(context, ref, ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose from Gallery'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C63FF),
              side: const BorderSide(color: Color(0xFF6C63FF)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Error Message
          if (state.status.toString() == 'OcrStatus.error' &&
              state.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            )
          ]
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    await ref.read(ocrProvider.notifier).pickAndExtract(source);

    final state = ref.read(ocrProvider);

    if (state.status.toString() == 'OcrStatus.success' && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OcrResultScreen(),
        ),
      );
    }
  }
}