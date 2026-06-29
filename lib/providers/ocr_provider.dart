import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_doc_ai/repositories/ocr_repository.dart';
import 'package:smart_doc_ai/core/services/ocr_service.dart';
import 'dart:io';

enum OcrStatus { idle, picking, processing, success, error }

class OcrState {
  final OcrStatus status;
  final String extractedText;
  final File? imageFile;
  final String? errorMessage;

  OcrState({
    required this.status,
    this.extractedText = '',
    this.imageFile,
    this.errorMessage,
  });

  bool get loading =>
      status == OcrStatus.picking || status == OcrStatus.processing;
  bool get hasText => extractedText.trim().isNotEmpty;

  OcrState copyWith({
    OcrStatus? status,
    String? extractedText,
    File? imageFile,
    String? errorMessage,
  }) {
    return OcrState(
      status: status ?? this.status,
      extractedText: extractedText ?? this.extractedText,
      imageFile: imageFile ?? this.imageFile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
// Notifier
class OcrNotifier extends StateNotifier<OcrState> {
  OcrNotifier(this._repository)
      : super(OcrState(status: OcrStatus.idle));

  final OcrRepository _repository;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndExtract(ImageSource source) async {
    try {
      state = state.copyWith(status: OcrStatus.picking);
      final pickedFile = await _picker.pickImage(source: source,imageQuality: 70,maxHeight: 1500,maxWidth: 1500);
      if (pickedFile == null) {
        state = state.copyWith(status: OcrStatus.idle);
        return;
      }
      final imageFile = File(pickedFile.path);
      state = state.copyWith(
          status: OcrStatus.processing, imageFile: imageFile);
      final extractedText = await _repository.extractText(imageFile);
      state = state.copyWith(
          status: OcrStatus.success, extractedText: extractedText);
    } catch (e) {
      state = state.copyWith(
        status: OcrStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void updateText(String text) {
    state = state.copyWith(extractedText: text);
  }

  void reset() {
    state = OcrState(status: OcrStatus.idle);
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────
final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrService();
});

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepository(ref.read(ocrServiceProvider));
});

final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  return OcrNotifier(ref.read(ocrRepositoryProvider));
});
