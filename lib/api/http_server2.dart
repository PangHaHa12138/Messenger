import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:messager/db/channel_dao.dart';
import 'package:messager/db/user_dao.dart';
import 'package:messager/db/warning_type_dao.dart';
import 'package:messager/model/channel_model.dart';

import '../model/channel_list_model.dart';
import '../model/user_model.dart';
import '../model/warning_list_model.dart';
import '../model/warning_model.dart';
import '../model/warning_type_list_model.dart';
import '../model/warning_type_model.dart';

const String host = 'http://8.140.253.71:21260';

class HttpServerApi extends GetxService {
  // HMAC-SHA256加密，另外用“whale”加言
  String encryptHMACSHA256(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);

    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);

    return digest.toString();
  }

  Future<UserModel?> login(String name, String password) async {
    Dio dio = Dio();

    String url = "$host/v1/auth/login";
    String key = "whale";
    String encryptedData = encryptHMACSHA256(password, key);
    Map<String, dynamic> map = {};
    map["name"] = name;
    map["password"] = encryptedData;

    print('===> body：$map');
    print('===> url：$url');

    var response = await dio.post(url, data: map);

    print('===> code：${response.statusCode}');

    Map<String, dynamic>? data = response.data;

    print('===> ${data.toString()}');

    if (data != null) {
      if (data['errorMessage'] != null) {
        print('===> ${data['errorMessage']}');
        String msg = data['errorMessage'];
      } else {
        UserModel userModel = UserModel(
          name: data['name'],
          nickName: data['nickName'],
          expireTime: data['expireTime'],
          x_token: data['x-token'],
          password: password,
          avatar: data['avatar'],
        );
        await UserDao.save(userModel);
        return userModel;
      }
    }

    return null;
  }

  Future<void> refreshToken(
      String xToken, String password, UserModel? old) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/auth/refreshToken";

    print('===> url：$url');

    var response = await dio.get(url);

    print('===> code：${response.statusCode}');

    Map<String, dynamic>? data = response.data;

    print('===> ${data.toString()}');

    if (data != null) {
      if (data['errorMessage'] != null) {
        print('===> ${data['errorMessage']}');
        String msg = data['errorMessage'];
      } else {
        UserModel userModel = UserModel(
          name: data['name'],
          nickName: data['nickName'],
          expireTime: data['expireTime'],
          x_token: data['x-token'],
          password: password,
          avatar: old?.avatar,
        );
        await UserDao.save(userModel);
      }
    }
  }

  Future<ChannelListModel?> myChannel(String xToken) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;
    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/myChannel";

    print('===> url：$url');

    var response = await dio.get(url);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null) {
        List<ChannelModel> channels = [];
        for (var value in data) {
          Map<String, dynamic>? item = value;
          if (item != null) {
            ChannelModel channelModel = ChannelModel(
              id: item['id'],
              code: item['code'],
              name: item['name'],
              icon: item['icon'],
            );
            channels.add(channelModel);
          }
        }
        ChannelListModel channelListModel =
            ChannelListModel(channels: channels);
        await ChannelDao.save(channelListModel);
        return channelListModel;
      }
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null && data['errorMessage'] != null) {
        print(data['errorMessage']);
        String msg = data['errorMessage'];
      }
    }
    return null;
  }

  Future<WarningListModel?> lastAlarm(
      String xToken, String alarmType, String channelCode, int pageSize) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/lastAlarm";

    Map<String, dynamic> map = {};
    map["alarmType"] = alarmType;
    map["channelCode"] = channelCode;
    map["pageSize"] = pageSize;

    print('===> body：$map');
    print('===> url：$url');

    var response = await dio.post(url, data: map);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> pageSize:$pageSize');
      print('===> ${data.toString()}');

      if (null != data) {
        List<WarningModel> list = [];
        for (var element in data) {
          WarningModel warningModel = WarningModel(
            id: element["id"],
            alarmType: element["alarmType"],
            alarmName: element["alarmName"],
            channelCode: element["channelCode"],
            channelName: element["channelName"],
            title: element["title"],
            description: element["description"],
            alarmTime: element["alarmTime"],
            url: element["url"],
            channelIcon: element["channelIcon"],
          );
          list.add(warningModel);
        }
        WarningListModel warningListModel = WarningListModel(warnings: list);
        return warningListModel;
      }
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null && data['errorMessage'] != null) {
        print(data['errorMessage']);
        String msg = data['errorMessage'];
      }
    }

    return null;
  }

  Future<WarningTypeListModel?> warningType(
      String xToken, String alarmType, String channelCode) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/dictionary?code=alarm_type";

    print('===> url：$url');

    var response = await dio.get(url);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');

      if (data != null && data.isNotEmpty) {
        List<WarningTypeModel> list = [];
        for (var element in data) {
          WarningTypeModel warningModel = WarningTypeModel(
            dictionaryId: element["dictionaryId"],
            dictionaryCode: element["dictionaryCode"],
            code: element["code"],
            value: element["value"],
            displayOrder: element["displayOrder"],
          );
          list.add(warningModel);
        }
        WarningTypeListModel listModel = WarningTypeListModel(warnings: list);
        await WarningTypeDao.save(listModel);
        return listModel;
      }
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null && data['errorMessage'] != null) {
        print(data['errorMessage']);
        String msg = data['errorMessage'];
      }
    }

    return null;
  }

  Future<WarningListModel?> searchWarning(
    String xToken,
    String alarmType,
    String channelCode,
    int pageSize,
    int cursor,
    String description,
    String alarmTimeStart,
    String alarmTimeEnd,
  ) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/alarmRecord";

    Map<String, dynamic> map = {};
    map["alarmType"] = alarmType;
    map["channelCode"] = channelCode;
    map["pageSize"] = pageSize;
    map["cursor"] = cursor;
    map["description"] = description;
    map["alarmTimeEnd"] = alarmTimeEnd;
    map["alarmTimeStart"] = alarmTimeStart;

    print('===> body：$map');
    print('===> url：$url');

    var response = await dio.post(url, data: map);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');

      if (null != data) {
        List<WarningModel> list = [];
        for (var element in data) {
          WarningModel warningModel = WarningModel(
            id: element["id"],
            alarmType: element["alarmType"],
            alarmName: element["alarmName"],
            channelCode: element["channelCode"],
            channelName: element["channelName"],
            title: element["title"],
            description: element["description"],
            alarmTime: element["alarmTime"],
            url: element["url"],
            channelIcon: element["channelIcon"],
          );
          list.add(warningModel);
        }
        WarningListModel warningListModel = WarningListModel(warnings: list);
        return warningListModel;
      }
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null && data['errorMessage'] != null) {
        print('===> ${data['errorMessage']}');
        String msg = data['errorMessage'];
      }
    }

    return null;
  }

  Future<ChannelListModel?> channelList(String xToken) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/channelDoView";

    print('===> url：$url');

    var response = await dio.get(url);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null) {
        if (data.isEmpty) {}
        List<ChannelModel> channels = [];
        for (var value in data) {
          Map<String, dynamic>? item = value;
          if (item != null) {
            ChannelModel channelModel = ChannelModel(
              id: item['id'],
              code: item['code'],
              name: item['name'],
              icon: item['icon'],
            );
            channels.add(channelModel);
          }
        }
        ChannelListModel channelListModel =
            ChannelListModel(channels: channels);
        await ChannelDao.save(channelListModel);
        return channelListModel;
      }
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic>? data = response.data;
      print('===> ${data.toString()}');
      if (data != null && data['errorMessage'] != null) {
        String msg = data['errorMessage'];
      }
    }

    return null;
  }

  Future<void> channelSave(String xToken, List<ChannelModel> channel) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;
    options.contentType = "application/json";

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/channelSave";

    List<dynamic> list = [];

    for (var value in channel) {
      list.add({
        'id': value.id,
        'code': value.code,
        'name': value.name,
        'checked': true
      });
    }

    print('===> body：$list');
    print('===> url：$url');

    var response = await dio.post(url, data: list);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic> data = response.data;

      print('===> ${data.toString()}');

      String msg = data['result'];
      if (msg == 'ok') {
        msg = '正常に追加されました';
      }
    }
  }

  Future<void> channelDelete(
    String xToken,
    int channelId,
  ) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/appAlarm/channelDelete?channelId=$channelId";

    print('===> url：$url');

    var response = await dio.delete(url);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic> data = response.data;

      print('===> ${data.toString()}');

      String msg = data['result'];
      if (msg == 'ok') {
        msg = '正常に削除されました';
      }
    }
  }

  Future<void> register(String xToken, String fcmToken, String deviceUuid,
      int expirationTime) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/userdevicetoken/register";

    Map<String, dynamic> map = {};
    map["deviceUuid"] = deviceUuid;
    map["token"] = fcmToken;
    map["expirationTime"] = expirationTime;

    print('===> body：$map');
    print('===> url：$url');

    var response = await dio.post(url, data: map);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic> data = response.data;

      print('===> ${data.toString()}');
    }
  }

  Future<void> updateToken(String xToken, String fcmToken, String deviceUuid,
      int expirationTime) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/userdevicetoken/updateToken";

    Map<String, dynamic> map = {};
    map["deviceUuid"] = deviceUuid;
    map["token"] = fcmToken;
    map["expirationTime"] = expirationTime;

    print('===> body：$map');
    print('===> url：$url');

    var response = await dio.put(url, data: map);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic> data = response.data;

      print('===> ${data.toString()}');
    }
  }

  Future<void> unregister(String xToken, String deviceUuid) async {
    BaseOptions options = BaseOptions();

    options.headers["x-token"] = xToken;

    Dio dio = Dio(options);

    String url = "$host/v1/userdevicetoken/unregister?deviceUuid=$deviceUuid";

    print('===> url：$url');

    var response = await dio.delete(url);

    print('===> code：${response.statusCode}');

    if (response.data is List<dynamic>) {
      List<dynamic>? data = response.data;

      print('===> ${data.toString()}');
    } else if (response.data is Map<String, dynamic>) {
      Map<String, dynamic> data = response.data;

      print('===> ${data.toString()}');
    }
  }
}
