import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'api/http_server.dart';
import 'app_info.dart';
import 'audio_manager.dart';
import 'db/user_dao.dart';
import 'model/user_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("===> 后台通知");
  print("===> Handling a background message: ${message.messageId}");
  print("===> title: ${message.notification?.title}");
  print("===> body: ${message.notification?.body}");
  print("===> payload: ${message.data}");

  AudioManager audioManager = AudioManager();
  audioManager.startAudio();
  audioManager.startVibrate();

  showNotification(message.notification?.title, message.notification?.body);
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  String? fCMToken;

  Future<void> initNotifications() async {
    AppInfo appInfo = await AppInfo.getInstance().init();

    await _firebaseMessaging.requestPermission();
    // 获取Firebase Cloud 消息传递令牌
    fCMToken = await _firebaseMessaging.getToken();

    RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
    if (message != null && message.notification != null) {
      AudioManager audioManager = AudioManager();
      audioManager.stopAudio();
      audioManager.stopVibrate();
    }

    // 后台运行通知回调
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 前台运行通知监听
    FirebaseMessaging.onMessage.listen(handleMessage);
    // 监听 后台运行时通过系统信息条打开应用
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    // 如需在每次令牌更新时获得通知
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      //  If necessary send token to application server.
      fCMToken = fcmToken;
      // 每当生成新令牌时，都会触发此回调。
      await postTokenHttp(fcmToken, appInfo);
    }).onError((err) {
      // Error getting token.
    });
    print("===> fCMToken:$fCMToken");

    await postTokenHttp(fCMToken!, appInfo);
  }

  void onMessageOpenedApp(RemoteMessage? message) async {
    print("===> 打开通知");
    print("===> Handling a background message: ${message?.messageId}");
    print("===> title: ${message?.notification?.title}");
    print("===> body: ${message?.notification?.body}");
    print("===> payload: ${message?.data}");

    AudioManager audioManager = AudioManager();
    audioManager.stopAudio();
    audioManager.stopVibrate();
  }

  void handleMessage(RemoteMessage? message) async {
    print("===> 前台通知");
    print("===> title: ${message?.notification?.title}");
    print("===> body: ${message?.notification?.body}");
    print("===> payload: ${message?.data}");

    AudioManager audioManager = AudioManager();
    audioManager.startAudio();
    audioManager.startVibrate();

    showNotification(message?.notification?.title, message?.notification?.body);
  }

  Future<void> postTokenHttp(String fcmToken, AppInfo appInfo) async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    int? expireTime = userModel?.expireTime;
    if (token != null) {
      await httpServerApi.register(
          token, fcmToken, appInfo.deviceId, expireTime!);
    }
  }

  Future<void> refreshTokenHttp(String fcmToken, AppInfo appInfo) async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    int? expireTime = userModel?.expireTime;
    if (token != null) {
      await httpServerApi.updateToken(
          token, fcmToken, appInfo.deviceId, expireTime!);
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification(String? title, String? body) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'messageNotificationChannelId',
    'messager',
    channelDescription: 'message',
    icon: '@mipmap/ic_launcher',
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    playSound: true,
    //silent: true,
    enableLights: true,
    enableVibration: true,
    ongoing: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.alarm,
  );

  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    presentBanner: true,
    presentList: true,
    subtitle: 'messager',
    interruptionLevel: InterruptionLevel.active,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: darwinNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: 'notification_payload',
  );
}
