import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

import 'package:messager/page/splash_page.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'db/hive_service.dart';
import 'firebase_options.dart';

void main() async {
  // 确保 Flutter 框架已经被初始化；
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化云消息推送
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MaterialColor customSwatch = MaterialColor(
    0xFF015CD6, // 主色
    <int, Color>{
      50: Color(0xFF015CD6),
      100: Color(0xFF015CD6),
      200: Color(0xFF015CD6),
      300: Color(0xFF015CD6),
      400: Color(0xFF015CD6),
      500: Color(0xFF015CD6),
      600: Color(0xFF015CD6),
      700: Color(0xFF015CD6),
      800: Color(0xFF015CD6),
      900: Color(0xFF015CD6),
    },
  );

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '鯨',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: const Color(0xFF015CD6),
        primarySwatch: customSwatch,
        useMaterial3: false,
      ),
      builder: EasyLoading.init(),
      home: SplashPage(),
      onInit: () async {
        Future.delayed(const Duration(milliseconds: 500), () async {
          await initializeDateFormatting();
        });
      },
      localizationsDelegates: const [
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ja', 'JP'),
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
    );
  }
}
