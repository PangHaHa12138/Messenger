import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import 'package:messager/db/channel_dao.dart';
import 'package:messager/model/channel_model.dart';

import 'package:messager/page/search_page.dart';

import '../api/http_server.dart';
import '../db/user_dao.dart';
import '../model/channel_list_model.dart';
import 'list_page.dart';
import '../model/user_model.dart';

class WarningPage extends StatefulWidget {
  WarningPage({Key? key}) : super(key: key);

  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage>
    with TickerProviderStateMixin {
  String errorLevel = '警報';

  late TabController tabController;

  List<ChannelModel> tabs = [];
  List<Widget> tabList = [];
  bool hasFinishHttp = false;

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: tabs.length);

    getMyChannel();
  }

  Future<void> getMyChannel() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      ChannelListModel? channelListModel = await httpServerApi.myChannel(token);
      if (channelListModel != null && channelListModel.channels != null) {
        tabs = channelListModel.channels!;
        tabList.clear();
        tabController = TabController(vsync: this, length: tabs.length);
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
      } else {
        ChannelListModel? channelList = await ChannelDao.get();
        if (channelList != null && channelList.channels != null) {
          if (channelList.channels!.isNotEmpty) {
            tabs = channelList.channels!;
            tabs.add(tabs[0]);
            tabs.add(tabs[0]);
            tabs.add(tabs[0]);
            tabList.clear();
            tabController = TabController(vsync: this, length: tabs.length);
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
          }
        }
      }

      print('===> tabs.length:${tabs.length}');
      print('===> tabList.length:${tabList.length}');

      hasFinishHttp = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          'ホーム',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            icon: Image.asset(
              'images/search.png',
              width: 18,
              height: 18,
            ),
          ),
        ],
      ),
      body: tabList.isEmpty && hasFinishHttp
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/empty.json',
                    width: 219,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'データなし',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(right: 8, left: 8),
                  padding: EdgeInsets.zero,
                  indicator: const BoxDecoration(),
                  labelStyle: const TextStyle(
                    color: Color(0xFF015CD6),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                      color: Color(0xFF959595),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  tabs: tabList,
                  tabAlignment: TabAlignment.center,
                  splashBorderRadius: BorderRadius.circular(18),
                  onTap: (index) {},
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: tabs
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                ListPage(model: e),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 30,right: 10),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     foregroundColor: Colors.lightBlue,
      //     child: const Icon(
      //       Icons.show_chart,
      //       size: 35,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
