import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:url_launcher/url_launcher.dart';

import '../audio_manager.dart';
import '../http/options.dart';
import '../model/warning_model.dart';
import '../util/common_util.dart';

class DetailPage extends StatefulWidget {
  final WarningModel warningModel;

  DetailPage({
    required this.warningModel,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<TextSpan> textSpans;
  String url = "";
  @override
  void initState() {
    super.initState();
    url = '${widget.warningModel.url}';
    AudioManager audioManager = AudioManager();
    audioManager.stopAudio();
    audioManager.stopVibrate();
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
          '警報詳細',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 90,
                      child: Text(
                        '${widget.warningModel.title}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    (widget.warningModel.channelIcon != null &&
                            isImage('${widget.warningModel.channelIcon}'))
                        ? Image.network(
                            '${HttpOptions.baseUrl}${widget.warningModel.channelIcon}',
                            width: 28,
                            height: 28,
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTimestamp(widget.warningModel.alarmTime!),
                      style: const TextStyle(
                          color: Color(0xFFBCBFC4), fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getColor(widget.warningModel.alarmType!),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${widget.warningModel.alarmName}',
                        style: TextStyle(
                          color: getColor(widget.warningModel.alarmType!),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${widget.warningModel.description}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 60,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF015CD6),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'レポート',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF015CD6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    launch(url);
                  },
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFF7F7F7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          url,
                          style: const TextStyle(
                            color: Color(0xFFBABEC1),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.copy,
                          color: Color(0xFFBABEC1),
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  onTap: () async {
                    final data = ClipboardData(text: url);
                    await Clipboard.setData(data);
                    showToast('コピー成功 !');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showToast(String msg) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      );
    EasyLoading.showToast(msg);
  }
}
