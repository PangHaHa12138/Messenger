import 'package:hive/hive.dart';

import '../db/db_const.dart';
import 'warning_type_model.dart';

part 'warning_type_list_model.g.dart';


@HiveType(typeId: DBConst.Hive_Types_WARNING__TYPE_LIST)
class WarningTypeListModel {

  @HiveField(0)
  List<WarningTypeModel>? warnings;

  WarningTypeListModel({
    this.warnings,
  });

  static WarningTypeListModel fromJson(Map<String, dynamic> rootData) {
    List<dynamic> data = rootData["data"];
    WarningTypeListModel listModel = WarningTypeListModel();
    List<WarningTypeModel> list = [];
    for (var element in data) {
      WarningTypeModel warningModel = WarningTypeModel();
      warningModel.dictionaryId = element["dictionaryId"];
      warningModel.dictionaryCode = element["dictionaryCode"];
      warningModel.code = element["code"];
      warningModel.value = element["value"];
      warningModel.displayOrder = element["displayOrder"];
      list.add(warningModel);
    }
    listModel.warnings = list;
    return listModel;
  }
}
