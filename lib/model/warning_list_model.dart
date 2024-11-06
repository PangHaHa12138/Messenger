import 'package:hive/hive.dart';

import '../db/db_const.dart';
import 'warning_model.dart';

part 'warning_list_model.g.dart';


@HiveType(typeId: DBConst.Hive_Types_WARNING_LIST)
class WarningListModel {

  @HiveField(0)
  List<WarningModel>? warnings;

  WarningListModel({
    this.warnings,
  });

  static WarningListModel fromJson(Map<String, dynamic> rootData) {
    List<dynamic> data = rootData["data"];
    WarningListModel listModel = WarningListModel();
    List<WarningModel> list = [];
    for (var element in data) {
      WarningModel warningModel = WarningModel();
      warningModel.id = element["id"];
      warningModel.alarmType = element["alarmType"];
      warningModel.channelCode = element["channelCode"];
      warningModel.title = element["title"];
      warningModel.description = element["description"];
      warningModel.alarmTime = element["alarmTime"];
      list.add(warningModel);
    }
    listModel.warnings = list;
    return listModel;
  }
}
