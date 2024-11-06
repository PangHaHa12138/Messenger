import 'package:hive/hive.dart';

import '../db/db_const.dart';

part 'warning_type_model.g.dart';

@HiveType(typeId: DBConst.Hive_Types_WARNING_TYPE)
class WarningTypeModel {
  @HiveField(0)
  int? dictionaryId;

  @HiveField(1)
  String? dictionaryCode;

  @HiveField(2)
  String? code;

  @HiveField(3)
  String? value;

  @HiveField(4)
  int? displayOrder;


  WarningTypeModel({
    this.dictionaryId,
    this.dictionaryCode,
    this.code,
    this.value,
    this.displayOrder,
  });
}


