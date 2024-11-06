import 'package:hive/hive.dart';

import '../db/db_const.dart';

part 'channel_model.g.dart';

@HiveType(typeId: DBConst.Hive_Types_CHANNEL)
class ChannelModel {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? code;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? checked;

  @HiveField(4)
  String? icon;

  ChannelModel({this.id, this.code, this.name, this.checked,this.icon,});

}
