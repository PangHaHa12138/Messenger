import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/http_server.dart';
import '../db/channel_dao.dart';
import '../db/user_dao.dart';
import '../db/warning_type_dao.dart';

import '../http/options.dart';
import '../model/channel_list_model.dart';
import '../model/channel_model.dart';
import '../model/user_model.dart';
import '../model/warning_list_model.dart';
import '../model/warning_model.dart';
import '../model/warning_type_list_model.dart';
import '../model/warning_type_model.dart';
import '../util/common_util.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController scrollController = ScrollController();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final TextEditingController _textEditingController = TextEditingController();

  DateTime? _pickedDate;

  String? _selectChannel;

  String? _selectType;

  String? _inputText = '';

  final _focusNode = FocusNode();

  bool _hasFocus = false;

  List<PopupMenuItem> channelItemList = [];
  List<PopupMenuItem> warnTypeItemList = [];

  List<ChannelModel> channelList = [];
  List<WarningTypeModel> warningTypeList = [];
  List<WarningModel> dataList = [];
  int pageSize = 10;
  int cursor = 0;

  bool hasStartHttp = false;
  bool hasSearch = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });

    getChannelListAndWarnTypeList();
  }

  Future<void> getChannelListAndWarnTypeList() async {
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      ChannelListModel? channelListModel =
          await httpServerApi.channelList(token);
      if (channelListModel != null && channelListModel.channels != null) {
        channelList = channelListModel.channels!;
      }
    }
    if (channelList.isEmpty) {
      ChannelListModel? channelListModel = await ChannelDao.get();
      if (channelListModel != null && channelListModel.channels != null) {
        if (channelListModel.channels!.isNotEmpty) {
          channelList = channelListModel.channels!;
        }
      }
    }

    if (channelList.isNotEmpty) {
      for (var element in channelList) {
        channelItemList.add(
          PopupMenuItem(
              value: '${element.name}',
              child: Row(
                children: [
                  (element.icon != null && isImage('${element.icon}'))
                      ? Image.network(
                          '${HttpOptions.baseUrl}${element.icon}',
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
                    '${element.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1D2A38),
                    ),
                  ),
                ],
              )),
        );
      }
    }
    if (token != null) {
      WarningTypeListModel? warningTypeListModel =
          await httpServerApi.warningType(token, '', '');
      if (warningTypeListModel != null &&
          warningTypeListModel.warnings != null) {
        warningTypeList = warningTypeListModel.warnings!;
      }
    }
    if (warningTypeList.isEmpty) {
      WarningTypeListModel? warningTypeListModel = await WarningTypeDao.get();
      if (warningTypeListModel != null &&
          warningTypeListModel.warnings != null) {
        if (warningTypeListModel.warnings!.isNotEmpty) {
          warningTypeList = warningTypeListModel.warnings!;
        }
      }
    }

    if (warningTypeList.isNotEmpty) {
      for (var element in warningTypeList) {
        Color randomColor = getColor(element.code!);
        warnTypeItemList.add(
          PopupMenuItem(
            value: element.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: randomColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${element.value}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: randomColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> getListData(bool refresh, bool isSearch) async {
    if (refresh) {
      cursor = 0;
      dataList.clear();
    }
    HttpServerApi httpServerApi = HttpServerApi();
    UserModel? userModel = await UserDao.get();
    String? token = userModel?.x_token;
    if (token != null) {
      String alarmTimeStart = '';
      String alarmTimeEnd = '';
      if (_pickedDate != null) {
        DateTime startOfDay = DateTime(
            _pickedDate!.year, _pickedDate!.month, _pickedDate!.day, 0, 0, 0);
        DateTime endOfDay = DateTime(_pickedDate!.year, _pickedDate!.month,
            _pickedDate!.day, 23, 59, 59);
        alarmTimeStart = startOfDay.millisecondsSinceEpoch.toString();
        alarmTimeEnd = endOfDay.millisecondsSinceEpoch.toString();
      }

      String alarmType = getSelectWarningTypeValue() ?? '';
      String channelCode = getSelectChannelValue() ?? '';
      print('===> channelCode:$channelCode');
      String description = _inputText ?? '';
      WarningListModel? warningListModel = await httpServerApi.searchWarning(
          token,
          alarmType,
          channelCode,
          pageSize,
          cursor,
          description,
          alarmTimeStart,
          alarmTimeEnd,
          isSearch);
      if (warningListModel != null && warningListModel.warnings!.isNotEmpty) {
        warningListModel.warnings?.forEach((element) {
          dataList.add(element);
        });
        cursor = dataList[dataList.length - 1].id!;
      }
      hasStartHttp = false;
      setState(() {});
    }
  }

  String? getSelectChannelValue() {
    for (var element in channelList) {
      if (element.name == _selectChannel) {
        return element.code;
      }
    }
    return null;
  }

  String? getSelectWarningTypeValue() {
    for (var element in warningTypeList) {
      if (element.value == _selectType) {
        return element.code;
      }
    }
    return null;
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
          '警報検索',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 48,
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: _hasFocus
                        ? Border.all(color: const Color(0xFF015CD6), width: 1.0)
                        : null,
                    color: Colors.white,
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'キーウードを入力',
                      hintStyle: const TextStyle(
                          color: Color(0xFFDADADA), fontSize: 16),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          setState(() {
                            hasStartHttp = true;
                            hasSearch = true;
                          });
                          print('=====> search $_inputText ');

                          await getListData(true, true);
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFFBCC6D5),
                        ),
                      ),
                    ),
                    focusNode: _focusNode,
                    onChanged: (text) {
                      _inputText = text;
                    },
                    onEditingComplete: () async {
                      setState(() {
                        hasStartHttp = true;
                        hasSearch = true;
                      });
                      print('=====> search $_inputText ');
                      await getListData(true, true);
                    },
                    controller: _textEditingController,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton(
                        onSelected: (value) {
                          setState(() {
                            _selectChannel = value;
                          });
                          print('====> $value');
                        },
                        color: Colors.white,
                        itemBuilder: (BuildContext context) {
                          return channelItemList;
                        },
                        offset: const Offset(0, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectChannel ?? 'チャンネル',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1D2A38),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFB8C2CC),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: PopupMenuButton(
                        onSelected: (value) {
                          setState(() {
                            _selectType = value;
                          });
                          print('====> $value');
                        },
                        color: Colors.white,
                        itemBuilder: (BuildContext context) {
                          return warnTypeItemList;
                        },
                        offset: const Offset(0, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectType ?? 'ラベル',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1D2A38),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFB8C2CC),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _pickedDate != null
                                    ? _pickedDate!.toString().substring(0, 10)
                                    : '日付 ',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1D2A38),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFFB8C2CC),
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          final picked = await showDatePickerDialog2(context);
                          setState(() {
                            _pickedDate = picked;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: hasSearch && dataList.isEmpty && !hasStartHttp
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
                                      width: MediaQuery.of(context).size.width -
                                          49,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
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
                                          warningModel.channelIcon != null
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
                                      width: MediaQuery.of(context).size.width -
                                          61,
                                      margin: const EdgeInsets.only(
                                          left: 12, bottom: 14, right: 12),
                                      child: Text(
                                        '${warningModel.description}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Color(0xFF1D2A38),
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          49,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    49) *
                                                4 /
                                                5,
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
          ),
        ],
      ),
    );
  }

  Future<DateTime?> showDatePickerDialog(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    return selectedDate;
  }

  Future<DateTime?> showDatePickerDialog2(BuildContext context) async {
    DateTime? selectedDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text(
                        'キャンセル',
                        style:
                            TextStyle(color: Color(0xFF015CD6), fontSize: 14),
                      ),
                      onPressed: () {
                        selectedDate = null;
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text(
                        '確認する',
                        style:
                            TextStyle(color: Color(0xFF015CD6), fontSize: 14),
                      ),
                      onPressed: () {
                        selectedDate ??= DateTime.now();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 216,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (dateTime) {
                      selectedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return selectedDate;
  }
}
