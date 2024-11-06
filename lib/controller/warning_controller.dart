import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/http_server.dart';
import '../db/user_dao.dart';
import '../model/channel_list_model.dart';
import '../model/channel_model.dart';
import '../model/user_model.dart';

class WarningController extends GetxController {
  List<ChannelModel> tabs = [
    ChannelModel(),
  ];
  List<Widget> tabList = [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Center(
        child: Text(''),
      ),
    ),
  ];



  @override
  void onInit() {
    super.onInit();
    getMyChannel();
  }

  Future<void> getMyChannel() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      ChannelListModel? channelListModel = await httpServerApi.myChannel(token);

      print(channelListModel?.channels);

      if (channelListModel != null && channelListModel.channels != null) {
        tabs = channelListModel.channels!;
        tabs.add(tabs[0]);
        tabs.add(tabs[0]);
        tabs.add(tabs[0]);
        tabList.clear();

        for (int i = 0; i < tabs.length; i++) {
          tabList.add(
            Container(
              width: 104,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  '${tabs[i].name}',
                ),
              ),
            ),
          );
        }


        refresh();
      }
    }
  }


  @override
  void onClose() {
    super.onClose();
  }
}
