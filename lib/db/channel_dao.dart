import 'package:hive/hive.dart';
import '../model/channel_list_model.dart';
import '../model/channel_model.dart';
import 'hive_service.dart';

class ChannelDao {

  static Future save(ChannelListModel list) async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<ChannelListModel>();
      await box.clear();
      await box.add(list);
    } catch (e) {
      print(e);
    }
  }

  static Future<ChannelListModel?> get() async {
    try {
      final hiveService = HiveService();
      Box box = await hiveService.box<ChannelListModel>();
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
      Box box = await hiveService.box<ChannelListModel>();
      return await box.clear();
    } catch (e) {
      print(e);
    }
  }

}