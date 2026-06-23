import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../repositories/history_repository.dart';
import '../models/scan_record.dart';

class HistoryNotifier extends StateNotifier<List<ScanRecord>> {
  HistoryNotifier(this._repository) : super([]) {
    loadAll();
  }

  final HistoryRepository _repository;
void loadAll(){
  state =_repository.getAll();
}

Futture<void> save(ScanRecord record) async{
  await _repository.save(record);
  loadAll();
}

Future<void> delete(ScanRecord record) async{
  await _repository.delete(record);
  loadAll();
}
Future<void> clearAll() async{
  await _repository.clearAll();
  loadAll();
}
}
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final box = Hive.box<ScanRecord>('scan_records');
  return HistoryRepository(box);
});

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<ScanRecord>>((ref) {
  return HistoryNotifier(ref.read(historyRepositoryProvider));
});