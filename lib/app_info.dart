import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  // 例12.3.1
  String systemVersion = '';
  // 例ios
  String systemName = '';
  // 例iPhone7,1
  String machine = '';
  // 例jp.co.awabank.securestarter.stg
  String packageName = '';
  // 例1.0.0
  String version = '';
  // 例1212
  String buildNumber = '';
  //deviceId
  String deviceId = '';

  /// 创建单利
  static final AppInfo _instance = AppInfo();

  static AppInfo getInstance() {
    return _instance;
  }

  /// 初始化
  Future<AppInfo> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      /// ios deviceInfo
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // 例12.3.1
      systemVersion = iosInfo.systemVersion;
      // 例ios
      systemName = iosInfo.systemName;
      // 例iPhone7,1
      machine = iosInfo.utsname.machine;
      //Unique UUID
      deviceId = iosInfo.identifierForVendor!;
    }
    if (Platform.isAndroid) {
      /// androids deviceInfo
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      systemVersion = androidInfo.version.release;
      systemName = "Android";
      machine = androidInfo.model;
      deviceId = androidInfo.fingerprint;
    }

    /// PackageInfo
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // 例jp.co.awabank.securestarter.stg
    packageName = packageInfo.packageName;
    // 例1.0.0
    version = packageInfo.version;
    // 例1212
    buildNumber = packageInfo.buildNumber;

    print('===> systemVersion:$systemVersion');
    print('===> systemName:$systemName');
    print('===> machine:$machine');
    print('===> deviceId:$deviceId');
    print('===> version:$version');
    print('===> buildNumber:$buildNumber');

    return _instance;
  }
}
