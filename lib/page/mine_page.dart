import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:messager/util/common_util.dart';
import '../db/user_dao.dart';
import '../model/user_model.dart';
import 'about_app_page.dart';
import 'channel_select_page.dart';
import 'ring_select_page.dart';
import 'setting_page.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String? name = '';
  String? uid = '';
  String? avatar = randomAvatar;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    UserModel? userModel = await UserDao.get();
    name = userModel?.nickName;
    uid = userModel?.name;
    //avatar = 'assets/${userModel?.avatar}';
    setState(() {});
  }

  String getAvatar() {
    List<String> list = [
      'assets/avatar01.png',
      'assets/avatar02.png',
      'assets/avatar03.png',
      'assets/avatar04.png',
      'assets/avatar05.png',
      'assets/avatar06.png',
      'assets/avatar07.png',
      'assets/avatar08.png',
      'assets/avatar09.png',
      'assets/avatar10.png',
      'assets/avatar11.png',
      'assets/avatar12.png',
      'assets/avatar13.png',
      'assets/avatar14.png',
    ];
    Random random = Random();
    return list[random.nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'プロフィール',
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
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              '$avatar',
              width: 93,
              height: 93,
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  'UID:$uid',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B5BA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'images/channel.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'チャンネル',
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
                    builder: (context) => ChannelSelectionPage(),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Divider(color: Color(0xFFEDEDED), height: 1),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'images/sound.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '着信音',
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
                    builder: (context) => RingtoneSelectionPage(),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Divider(color: Color(0xFFEDEDED), height: 1),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'images/set.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '設定',
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
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Divider(color: Color(0xFFEDEDED), height: 1),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 16, bottom: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'images/info.png',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '鯨について',
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
                    builder: (context) => AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
