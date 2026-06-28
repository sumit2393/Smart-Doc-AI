import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../providers/ai_provider.dart';
import '../../providers/history_provider.dart';
import '../../models/scan_record.dart';

class AiAnalysisScreen extends ConsumerStatefulWidget {
  final String ocrText;
  final ScanMode mode;

  const AiAnalysisScreen({
    required this.ocrText,
    required this.mode,
    super.key,
  });

  @override
  ConsumerState<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends ConsumerState<AiAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiProvider.notifier).analyze(
            widget.ocrText,
            widget.mode,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('AI Analysis'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        actions: [
          if (aiState.isDone)
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: () => _saveToHistory(context, ref, aiState),
            ),
        ],
      ),
      body: _buildBody(aiState),
    );
  }

  Widget _buildBody(AiState aiState) {
    // Loading
    if (aiState.isLoading) {
      return const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
              SizedBox(height: 16),
              Text(
                'AI is analyzing your document...',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Error
    if (aiState.status == AiStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                aiState.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(aiProvider.notifier).analyze(
                        widget.ocrText,
                        widget.mode,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Result
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${aiState.mode.emoji} ${aiState.mode.label}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // AI Result
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: MarkdownBody(
              data: aiState.result.isEmpty
                  ? 'Waiting for response...'
                  : aiState.result,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E),
                  height: 1.6,
                ),
                h2: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
                listBullet: const TextStyle(
                  color: Color(0xFF6C63FF),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Save button
          if (aiState.isDone)
            ElevatedButton.icon(
              onPressed: () => _saveToHistory(context, ref, aiState),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save to History'),
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

  Future<void> _saveToHistory(
    BuildContext context,
    WidgetRef ref,
    AiState aiState,
  ) async {
    final record = ScanRecord.create(
      rawText: widget.ocrText,
      aiResult: aiState.result,
      mode: widget.mode,
    );

    await ref.read(historyProvider.notifier).save(record);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved to history ✅'),
          backgroundColor: Color(0xFF28A745),
        ),
      );
    }
  }
}