import 'package:hive/hive.dart';
import '../model/warning_type_list_model.dart';
import 'hive_service.dart';

class WarningTypeDao {

  static Future save(WarningTypeListModel list) async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<WarningTypeListModel>();
      await box.clear();
      await box.add(list);
    } catch (e) {
      print(e);
    }
  }

  static Future<WarningTypeListModel?> get() async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<WarningTypeListModel>();
      if (box.values.isNotEmpty) {
        return box.get(0);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future clear() async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<WarningTypeListModel>();
      return await box.clear();
    } catch (e) {
      print(e);
    }
  }

}