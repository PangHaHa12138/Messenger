import 'package:hive/hive.dart';

import '../db/db_const.dart';

part 'warning_model.g.dart';

@HiveType(typeId: DBConst.Hive_Types_WARNING)
class WarningModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? alarmType;

  @HiveField(2)
  String? alarmName;

  @HiveField(3)
  String? channelName;

  @HiveField(4)
  String? channelCode;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? description;

  @HiveField(7)
  int? alarmTime;

  @HiveField(8)
  String? url;

  @HiveField(9)
  String? channelIcon;

  WarningModel({
    this.id,
    this.alarmType,
    this.alarmName,
    this.channelName,
    this.channelCode,
    this.title,
    this.description,
    this.alarmTime,
    this.url,
    this.channelIcon,
  });
}

