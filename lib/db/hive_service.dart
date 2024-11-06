import 'package:hive_flutter/hive_flutter.dart';
import 'package:messager/model/channel_list_model.dart';
import 'package:messager/model/warning_list_model.dart';
import 'package:messager/model/warning_type_list_model.dart';

import '../model/channel_model.dart';
import '../model/user_model.dart';
import '../model/warning_model.dart';
import '../model/warning_type_model.dart';


class HiveService {
  static HiveService _instance = HiveService._();

  HiveService._() {
    _registerAdapters();
  }

  factory HiveService() {
    return _instance;
  }

  static Future init() async {
    await Hive.initFlutter();
  }

  void _registerAdapters() {

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ChannelModelAdapter());
    Hive.registerAdapter(ChannelListModelAdapter());
    Hive.registerAdapter(WarningModelAdapter());
    Hive.registerAdapter(WarningListModelAdapter());
    Hive.registerAdapter(WarningTypeModelAdapter());
    Hive.registerAdapter(WarningTypeListModelAdapter());

  }

  Future<Box<T>> box<T>() async {
    var boxName = _getBoxName(T);

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(_getBoxName(T));
  }

  String _getBoxName(Type type) {
    return type.toString();
  }

  /// Clears all the data stored in all boxes.
  Future<void> clearBoxes() async {}

  /// Close the boxes so they may not be accessible anymore unless reopened.
  Future<void> closeBoxes() async {
    await Hive.close();
  }
}
