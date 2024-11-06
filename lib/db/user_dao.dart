

import 'package:hive/hive.dart';

import '../model/user_model.dart';
import 'hive_service.dart';

class UserDao{

  static Future save(UserModel userModel) async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<UserModel>();
      await box.clear();
      await box.add(userModel);
    } catch (e) {
      print(e);
    }
  }

  static Future<UserModel?> get() async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<UserModel>();
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
      Box box = await hiveService.box<UserModel>();
      return await box.clear();
    } catch (e) {
      print(e);
    }
  }

}