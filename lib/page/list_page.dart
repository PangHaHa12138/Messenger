import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:messager/model/channel_model.dart';
import 'package:messager/model/warning_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/http_server.dart';
import '../db/user_dao.dart';

import '../http/options.dart';
import '../model/user_model.dart';
import '../model/warning_list_model.dart';
import '../util/common_util.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final ChannelModel model;

  ListPage({required this.model});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ScrollController scrollController;
  late RefreshController refreshController;

  int pageSize = 10;
  List<WarningModel> dataList = [];
  String code = '';
  bool hasFinishHttp = false;

  @override
  void initState() {
    super.initState();
    code = '${widget.model.code}';
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: false);

    getListData(true, true);
  }

  Future<void> getListData(bool refresh, bool isInit) async {
    if (refresh) {
      pageSize = 10;
      dataList.clear();
    } else {
      pageSize += 10;
    }
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      WarningListModel? warningListModel =
          await httpServerApi.lastAlarm(token, '', code, pageSize, isInit);
      if (warningListModel != null && warningListModel.warnings!.isNotEmpty) {
        warningListModel.warnings?.forEach((element) {
          dataList.add(element);
        });
      }
      hasFinishHttp = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: dataList.isEmpty && hasFinishHttp
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
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const ClassicHeader(
                refreshStyle: RefreshStyle.Follow,
              ),
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              onRefresh: () async {
                await getListData(true, false);
                refreshController.refreshCompleted();
              },
              onLoading: () async {
                await getListData(false, false);
                refreshController.loadComplete();
              },
              controller: refreshController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  WarningModel warningModel = dataList[index];

                  Color randomColor = getColor(warningModel.alarmType!);

                  return GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.white,
                      ),
                      height: 144,
                      child: Row(
                        children: [
                          Container(
                            width: 4.5,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                              color: randomColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 49,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  49) *
                                              4 /
                                              5,
                                      margin: const EdgeInsets.only(
                                          left: 12,
                                          top: 16,
                                          bottom: 14,
                                          right: 12),
                                      child: Text(
                                        '${warningModel.title}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    (warningModel.channelIcon != null &&
                                            isImage(
                                                '${warningModel.channelIcon}'))
                                        ? Image.network(
                                            '${HttpOptions.baseUrl}${warningModel.channelIcon}',
                                            width: 28,
                                            height: 28,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 61,
                                margin: const EdgeInsets.only(
                                    left: 12, bottom: 14, right: 12),
                                child: Text(
                                  '${warningModel.description}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xFF1D2A38), fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 49,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                      ),
                                      child: Text(
                                        formatTimestamp(
                                            warningModel.alarmTime!),
                                        style: const TextStyle(
                                            color: Color(0xFFBCBFC4),
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: randomColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${warningModel.alarmName}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: randomColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            warningModel: warningModel,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
