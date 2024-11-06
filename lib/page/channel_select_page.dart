import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import '../api/http_server.dart';
import '../db/channel_dao.dart';
import '../db/user_dao.dart';
import '../http/options.dart';
import '../model/channel_list_model.dart';
import '../model/channel_model.dart';
import '../model/user_model.dart';
import '../util/common_util.dart';

class ChannelSelectionPage extends StatefulWidget {
  @override
  _ChannelSelectionPageState createState() => _ChannelSelectionPageState();
}

class _ChannelSelectionPageState extends State<ChannelSelectionPage> {
  List<ChannelModel> selectedChannels = []; // 已选择的频道
  List<ChannelModel> allChannels = []; // 所有可选择的频道
  List<String> selectedList = [];
  List<String> allList = [];
  bool hasFinishHttp = false;

  @override
  void initState() {
    super.initState();

    getMyChannel();
    getChannelList();
  }

  Future<void> getMyChannel() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      ChannelListModel? channelListModel = await httpServerApi.myChannel(token);
      print(channelListModel?.channels);
      if (channelListModel != null && channelListModel.channels != null) {
        selectedChannels = channelListModel.channels!;
        selectedList.clear();
        for (var element in selectedChannels) {
          selectedList.add(element.name!);
        }
      }
    }
    hasFinishHttp = true;
    setState(() {});
  }

  Future<void> getChannelList() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      ChannelListModel? channelListModel =
          await httpServerApi.channelList(token);
      if (channelListModel != null && channelListModel.channels != null) {
        allChannels = channelListModel.channels!;
      }
    }
    if (allChannels.isEmpty) {
      ChannelListModel? channelListModel = await ChannelDao.get();
      if (channelListModel != null && channelListModel.channels != null) {
        if (channelListModel.channels!.isNotEmpty) {
          allChannels = channelListModel.channels!;
        }
      }
    }
    if (allChannels.isNotEmpty) {
      allList.clear();
      for (var element in allChannels) {
        allList.add(element.name!);
      }
    }
    setState(() {});
  }

  Future<void> saveChannel() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      await httpServerApi.channelSave(token, selectedChannels);
    }
  }

  Future<void> deleteChannel(int channelId) async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      await httpServerApi.channelDelete(token, channelId);
    }
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
          'チャンネルフォロー',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: selectedChannels.isEmpty && hasFinishHttp
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
          : ListView.builder(
              controller: ScrollController(),
              itemCount: selectedChannels.length,
              itemBuilder: (context, index) {
                ChannelModel channel = selectedChannels[index];
                return Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    extentRatio: 0.2,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) async {
                          int channelId = selectedChannels[index].id!;
                          selectedChannels.removeAt(index);
                          selectedList.removeAt(index);
                          await deleteChannel(channelId);
                          setState(() {});
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '消去',
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 12, bottom: 12),
                      child: Row(
                        children: [
                          (channel.icon != null && isImage('${channel.icon}'))
                              ? Image.network(
                                  '${HttpOptions.baseUrl}${channel.icon}',
                                  width: 35,
                                  height: 35,
                                )
                              : Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${channel.name}',
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 16),
        child: FloatingActionButton(
          onPressed: showChannelSelectionDialog,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF015CD6),
          child: const Icon(
            Icons.add,
            color: Color(0xFFBCC6D5),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void showChannelSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('チャンネル追加'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: allChannels.map((channel) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Row(
                            children: [
                              (channel.icon != null &&
                                      isImage('${channel.icon}'))
                                  ? Image.network(
                                      '${HttpOptions.baseUrl}${channel.icon}',
                                      width: 20,
                                      height: 20,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${channel.name}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1D2A38),
                                ),
                              )
                            ],
                          ),
                          value: selectedList.contains(channel.name),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                channel.checked = true;
                                selectedChannels.add(channel);
                                selectedList.add(channel.name!);
                                print('===> add');
                                print('===> ${selectedChannels.length}');
                                print('===> ${selectedList.length}');
                              } else {
                                int deleteIndex = 0;
                                for (int i = 0; i < selectedList.length; i++) {
                                  if (selectedList[i] == channel.name) {
                                    deleteIndex = i;
                                    break;
                                  }
                                }
                                channel.checked = false;
                                selectedChannels.removeAt(deleteIndex);
                                selectedList.removeAt(deleteIndex);
                                print('===> remove');
                                print('===> ${selectedChannels.length}');
                                print('===> ${selectedList.length}');
                              }
                            });
                          },
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await saveChannel();
                setState(() {}); // 更新列表页面
              },
              child: const Text('確認する'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteChannelDialog(String title, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除を確認する'),
          content: Text('削除を確認してください $title ？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('確認する'),
            ),
          ],
        );
      },
    );
  }
}
