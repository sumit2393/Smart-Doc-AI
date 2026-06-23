import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_record.dart';

class HistoryRepository {
  final Box<ScanRecord> _box;

  HistoryRepository(this._box);

  // Take all records in reverse order (latest first)
  List<ScanRecord> getAll() {
    return _box.values.toList().reversed.toList();
  }

  // save one record
  Future<void> save(ScanRecord record) async {
    await _box.add(record);
  }

  // Delete one record
  Future<void> delete(ScanRecord record) async {
    await record.delete();
  }

  // clear all records
  Future<void> clearAll() async {
    await _box.clear();
  }
}