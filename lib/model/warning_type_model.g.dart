// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarningTypeModelAdapter extends TypeAdapter<WarningTypeModel> {
  @override
  final int typeId = 6;

  @override
  WarningTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarningTypeModel(
      dictionaryId: fields[0] as int?,
      dictionaryCode: fields[1] as String?,
      code: fields[2] as String?,
      value: fields[3] as String?,
      displayOrder: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WarningTypeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dictionaryId)
      ..writeByte(1)
      ..write(obj.dictionaryCode)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.displayOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarningTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
