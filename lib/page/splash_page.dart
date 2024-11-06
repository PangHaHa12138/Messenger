import 'dart:math';

import 'package:flutter/material.dart';
import 'package:messager/page/home_page.dart';
import 'package:messager/page/login_page.dart';
import 'package:messager/util/common_util.dart';

import '../api/http_server.dart';
import '../db/user_dao.dart';
import '../model/user_model.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _expireTime = 0;

  @override
  void initState() {
    super.initState();
    setAvatar();
    getUser();
  }

  Future<void> setAvatar() async {
    randomAvatar = getRandomAvatar();
  }

  Future<void> getUser() async {
    UserModel? userModel = await UserDao.get();

    _expireTime = userModel?.expireTime ?? 0;
    print('===> expireTime:${userModel?.expireTime}');

    if (_expireTime == 0 ||
        (_expireTime > 0 && currentTimeMillis() > _expireTime)) {
      navigateToLogin();
    } else {
      HttpServerApi httpServer = HttpServerApi();
      String? token = userModel?.x_token;
      String? password = userModel?.password;
      if (token != null && password != null) {
        print('===> token:$token');
        await httpServer.refreshToken(token, password, userModel);
      }
      navigateToHome();
    }
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(context),
      ),
    );
  }

  int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/logo_startup.png',
              width: 120,
              height: 120,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'すべての「クジラ」が守っています',
                style: TextStyle(fontSize: 14, color: Color(0xFF015CD6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
