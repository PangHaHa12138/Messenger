import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:messager/db/channel_dao.dart';
import 'package:messager/db/user_dao.dart';
import 'package:messager/db/warning_type_dao.dart';
import 'package:messager/http/request.dart';
import 'package:messager/model/channel_model.dart';

import '../app_info.dart';
import '../model/channel_list_model.dart';
import '../model/user_model.dart';
import '../model/warning_list_model.dart';
import '../model/warning_model.dart';
import '../model/warning_type_list_model.dart';
import '../model/warning_type_model.dart';

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
    String url = "/v1/auth/login";
    String key = "whale";
    String encryptedData = encryptHMACSHA256(password, key);
    Map<String, dynamic> map = {};
    map["name"] = name;
    map["password"] = encryptedData;

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;

    var response = await HttpUtils.post(path: url, data: map, headers: headers);

    Map<String, dynamic>? data = response;

    if (data != null) {
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

    return null;
  }

  Future<void> refreshToken(
      String xToken, String password, UserModel? old) async {
    String url = "/v1/auth/refreshToken";

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;

    var response =
        await HttpUtils.get(path: url, headers: headers, showLoading: false);

    Map<String, dynamic>? data = response;

    if (data != null) {
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

  Future<ChannelListModel?> myChannel(String xToken) async {
    String url = "/v1/appAlarm/myChannel";

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;

    var response = await HttpUtils.get(path: url, headers: headers);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
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
      ChannelListModel channelListModel = ChannelListModel(channels: channels);
      await ChannelDao.save(channelListModel);
      return channelListModel;
    }

    return null;
  }

  Future<WarningListModel?> lastAlarm(String xToken, String alarmType,
      String channelCode, int pageSize, bool showLoading) async {
    String url = "/v1/appAlarm/lastAlarm";

    Map<String, dynamic> map = {};
    map["alarmType"] = alarmType;
    map["channelCode"] = channelCode;
    map["pageSize"] = pageSize;

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;

    var response = await HttpUtils.post(
        path: url, data: map, headers: headers, showLoading: showLoading);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;

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

    return null;
  }

  Future<WarningTypeListModel?> warningType(
      String xToken, String alarmType, String channelCode) async {
    String url = "/v1/appAlarm/dictionary?code=alarm_type";

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;

    var response = await HttpUtils.get(path: url, headers: headers);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;

      if (data.isNotEmpty) {
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
    bool showLoading,
  ) async {
    String url = "/v1/appAlarm/alarmRecord";

    Map<String, dynamic> map = {};
    map["alarmType"] = alarmType;
    map["channelCode"] = channelCode;
    map["pageSize"] = pageSize;
    map["cursor"] = cursor;
    map["description"] = description;
    map["alarmTimeEnd"] = alarmTimeEnd;
    map["alarmTimeStart"] = alarmTimeStart;

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;

    var response = await HttpUtils.post(
        path: url, headers: headers, data: map, showLoading: showLoading);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;

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

    return null;
  }

  Future<ChannelListModel?> channelList(String xToken) async {
    String url = "/v1/appAlarm/channelDoView";
    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response = await HttpUtils.get(path: url, headers: headers);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
      if (data.isNotEmpty) {
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
    }

    return null;
  }

  Future<void> channelSave(String xToken, List<ChannelModel> channel) async {
    String url = "/v1/appAlarm/channelSave";
    List<dynamic> list = [];
    for (var value in channel) {
      list.add({
        'id': value.id,
        'code': value.code,
        'name': value.name,
        'checked': true
      });
    }
    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response =
        await HttpUtils.post(path: url, headers: headers, data: list);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
    } else if (response is Map<String, dynamic>) {
      Map<String, dynamic> data = response;

      String msg = data['result'];
      if (msg == 'ok') {
        msg = '正常に追加されました';
      }
      showToast(msg);
    }
  }

  Future<void> channelDelete(
    String xToken,
    int channelId,
  ) async {
    String url = "/v1/appAlarm/channelDelete?channelId=$channelId";
    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response = await HttpUtils.delete(path: url, headers: headers);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
    } else if (response is Map<String, dynamic>) {
      Map<String, dynamic> data = response;

      String msg = data['result'];
      if (msg == 'ok') {
        msg = '正常に削除されました';
      }
      showToast(msg);
    }
  }

  Future<void> register(String xToken, String fcmToken, String deviceUuid,
      int expirationTime) async {
    String url = "/v1/userdevicetoken/register";

    Map<String, dynamic> map = {};
    map["deviceUuid"] = deviceUuid;
    map["token"] = fcmToken;
    map["expirationTime"] = expirationTime;

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response = await HttpUtils.post(
        path: url, data: map, headers: headers, showLoading: false);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
    } else if (response is Map<String, dynamic>) {
      Map<String, dynamic> data = response;
    }
  }

  Future<void> updateToken(String xToken, String fcmToken, String deviceUuid,
      int expirationTime) async {
    String url = "/v1/userdevicetoken/updateToken";

    Map<String, dynamic> map = {};
    map["deviceUuid"] = deviceUuid;
    map["token"] = fcmToken;
    map["expirationTime"] = expirationTime;

    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response = await HttpUtils.put(
        path: url, data: map, headers: headers, showLoading: false);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
    } else if (response is Map<String, dynamic>) {
      Map<String, dynamic> data = response;
    }
  }

  Future<void> unregister(String xToken, String deviceUuid) async {
    String url = "/v1/userdevicetoken/unregister?deviceUuid=$deviceUuid";
    Map<String, dynamic>? headers = {};
    AppInfo appInfo = await AppInfo.getInstance().init();
    headers['systemVersion'] = appInfo.systemVersion;
    headers['systemName'] = appInfo.systemName;
    headers['machine'] = appInfo.machine;
    headers['deviceId'] = appInfo.deviceId;
    headers['version'] = appInfo.version;
    headers['buildNumber'] = appInfo.buildNumber;
    headers['x-token'] = xToken;
    var response = await HttpUtils.delete(path: url, headers: headers);

    if (response is List<dynamic>) {
      List<dynamic>? data = response;
    } else if (response is Map<String, dynamic>) {
      Map<String, dynamic> data = response;
    }
  }

  void showToast(String msg) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      );
    EasyLoading.showToast(msg);
  }
}
