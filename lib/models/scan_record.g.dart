// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanRecordAdapter extends TypeAdapter<ScanRecord> {
  @override
  final int typeId = 0;

  @override
  ScanRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanRecord(
      id: fields[0] as String,
      rawText: fields[1] as String,
      aiResult: fields[2] as String,
      mode: fields[3] as ScanMode,
      createdAt: fields[4] as DateTime,
      imageFileName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScanRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rawText)
      ..writeByte(2)
      ..write(obj.aiResult)
      ..writeByte(3)
      ..write(obj.mode)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.imageFileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScanModeAdapter extends TypeAdapter<ScanMode> {
  @override
  final int typeId = 1;

  @override
  ScanMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScanMode.summarize;
      case 1:
        return ScanMode.translate;
      case 2:
        return ScanMode.qa;
      default:
        return ScanMode.summarize;
    }
  }

  @override
  void write(BinaryWriter writer, ScanMode obj) {
    switch (obj) {
      case ScanMode.summarize:
        writer.writeByte(0);
        break;
      case ScanMode.translate:
        writer.writeByte(1);
        break;
      case ScanMode.qa:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
