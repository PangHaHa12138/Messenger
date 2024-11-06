// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_type_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarningTypeListModelAdapter extends TypeAdapter<WarningTypeListModel> {
  @override
  final int typeId = 7;

  @override
  WarningTypeListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarningTypeListModel(
      warnings: (fields[0] as List?)?.cast<WarningTypeModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WarningTypeListModel obj) {
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
      other is WarningTypeListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
