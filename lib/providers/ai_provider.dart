import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_api_service.dart';
import '../repositories/gemini_repository.dart';
import '../models/scan_record.dart';

enum AiStatus { idle, loading, success, error }

class AiState {
  final AiStatus status;
  final String result;
  final ScanMode mode;
  final String? errorMessage;

  const AiState({
    this.status = AiStatus.idle,
    this.result = '',
    this.mode = ScanMode.summarize,
    this.errorMessage,
  });

  bool get isLoading => status == AiStatus.loading;
  bool get hasResult => result.trim().isNotEmpty;

  AiState copyWith({
    AiStatus? status,
    String? result,
    ScanMode? mode,
    String? errorMessage,
  }) {
    return AiState(
      status: status ?? this.status,
      result: result ?? this.result,
      mode: mode ?? this.mode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AiNotifier extends StateNotifier<AiState> {
  AiNotifier(this._repository) : super(const AiState());

  final GeminiRepository _repository;

  Future<void> analyze(String ocrText, ScanMode mode) async {
    state = state.copyWith(status: AiStatus.loading, mode: mode);

    try {
      final result = await _repository.analyzeText(ocrText, mode);
      state = state.copyWith(
        status: AiStatus.success,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        status: AiStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const AiState();
  }
}

final geminiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiService();
});

final geminiRepositoryProvider = Provider<GeminiRepository>((ref) {
  return GeminiRepository(ref.read(geminiServiceProvider));
});

final selectedModeProvider = StateProvider<ScanMode>((ref) {
  return ScanMode.summarize;
});

final aiProvider = StateNotifierProvider<AiNotifier, AiState>((ref) {
  return AiNotifier(ref.read(geminiRepositoryProvider));
});