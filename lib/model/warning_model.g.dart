// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarningModelAdapter extends TypeAdapter<WarningModel> {
  @override
  final int typeId = 2;

  @override
  WarningModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarningModel(
      id: fields[0] as int?,
      alarmType: fields[1] as String?,
      alarmName: fields[2] as String?,
      channelName: fields[3] as String?,
      channelCode: fields[4] as String?,
      title: fields[5] as String?,
      description: fields[6] as String?,
      alarmTime: fields[7] as int?,
      url: fields[8] as String?,
      channelIcon: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WarningModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.alarmType)
      ..writeByte(2)
      ..write(obj.alarmName)
      ..writeByte(3)
      ..write(obj.channelName)
      ..writeByte(4)
      ..write(obj.channelCode)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.alarmTime)
      ..writeByte(8)
      ..write(obj.url)
      ..writeByte(9)
      ..write(obj.channelIcon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarningModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
