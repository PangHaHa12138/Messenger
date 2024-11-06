// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelListModelAdapter extends TypeAdapter<ChannelListModel> {
  @override
  final int typeId = 5;

  @override
  ChannelListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelListModel(
      channels: (fields[0] as List?)?.cast<ChannelModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChannelListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.channels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
