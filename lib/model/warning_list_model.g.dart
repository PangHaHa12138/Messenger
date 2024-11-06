// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarningListModelAdapter extends TypeAdapter<WarningListModel> {
  @override
  final int typeId = 3;

  @override
  WarningListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarningListModel(
      warnings: (fields[0] as List?)?.cast<WarningModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WarningListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.warnings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarningListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
