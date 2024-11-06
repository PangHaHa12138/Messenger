import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/page/privacy_page.dart';

import '../api/http_server.dart';
import '../app_info.dart';
import '../db/channel_dao.dart';
import '../db/user_dao.dart';
import '../db/warning_type_dao.dart';
import '../model/user_model.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          '設定',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      size: 26,
                      color: Color(0xFF015CD6),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'プライバシー規約',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPage(),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Divider(color: Color(0xFFEDEDED), height: 1),
            ),
            InkWell(
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 26,
                      color: Color(0xFF015CD6),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'サインアウト',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await logOut();
                setState(() {
                  isLoading = false;
                });
                navigateToLogin();
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> logOut() async {
    AppInfo appInfo = await AppInfo.getInstance().init();
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      await httpServerApi.unregister(token, appInfo.deviceId);
    }
    await UserDao.clear();
    await ChannelDao.clear();
    await WarningTypeDao.clear();
  }
}
