import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_info.dart';
import '../notification_service.dart';
import 'search_page.dart';
import 'chart_page.dart';
import 'mine_page.dart';
import 'warning_page.dart';

class HomePage extends StatefulWidget {
  final BuildContext context;

  HomePage(this.context);

  @override
  _HomePageState createState() => _HomePageState(context);
}

class _HomePageState extends State<HomePage> {
  BuildContext? superContext;

  _HomePageState(this.superContext);

  int _currentIndex = 0;
  final List<Widget> _pages = [
    WarningPage(),
    MinePage(),
  ];

  DeviceInfoPlugin? deviceInfo;
  AndroidDeviceInfo? androidInfo;

  @override
  void initState() {
    getDeviceInfo();
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    await NotificationService().initNotifications();

    if (Platform.isAndroid) {
      bool? isBatteryOptimizationDisabled =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      if (isBatteryOptimizationDisabled == false) {
        DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      }

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      PermissionStatus status1 = await Permission.notification.request();
      if (status1.isGranted) {
      } else {
        openAppSettings();
      }
      PermissionStatus status2 =
          await Permission.ignoreBatteryOptimizations.request();
      if (status2.isGranted) {
      } else {
        openAppSettings();
      }
      PermissionStatus status3 = await Permission.systemAlertWindow.request();
      if (status3.isGranted) {
      } else {
        openAppSettings();
      }
      PermissionStatus status4 = await Permission.scheduleExactAlarm.request();
      if (status4.isGranted) {
      } else {
        openAppSettings();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool hasEnableAutoStart = prefs.getBool('hasEnableAutoStart') ?? false;
      if (hasEnableAutoStart) {
      } else {
        checkAndRequestPermission();
      }
    }

    if (Platform.isIOS) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      // PermissionStatus status1 = await Permission.notification.request();
      // if (status1.isGranted) {
      // } else {
      //   openAppSettings();
      // }
    }
  }

  Future<void> getDeviceInfo() async {
    deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo?.androidInfo;
    }

    setState(() {});
  }

  void checkAndRequestPermission() async {
    if (isDomesticManufacturer()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('ヒント'),
          content: const Text('通知を効果的に受信するには、設定ページに移動して「自起動する」権限を有効にしてください。'),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('hasEnableAutoStart', true);

                Navigator.pop(context);
              },
              child: const Text('オンになりました'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await openAppSettings();
              },
              child: const Text('確認する'),
            ),
          ],
        ),
      );
    }
  }

  bool isDomesticManufacturer() {
    bool isDomestic = false;
    List<String> domesticBrands = [
      'Huawei',
      'HONOR',
      'nova',
      'xiaomi',
      'Redmi',
      'OPPO',
      'vivo',
      'Meizu',
      'OnePlus',
      'lenovo',
      'zte',
      'smartisan',
      'letv',
    ];
    for (var element in domesticBrands) {
      if (containsIgnoreCase(element, '${androidInfo?.manufacturer}') ||
          containsIgnoreCase(element, '${androidInfo?.brand}')) {
        isDomestic = true;
      }
    }
    return isDomestic;
  }

  bool containsIgnoreCase(String source, String substring) {
    return source.toLowerCase().contains(substring.toLowerCase());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        inactiveColor: const Color(0xFFBCC6D5),
        activeColor: const Color(0xFF015CD6),
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? Image.asset('images/home_b.png')
                : Image.asset('images/home_a.png'),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Image.asset('images/my_b.png')
                : Image.asset('images/my_a.png'),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}
