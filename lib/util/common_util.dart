import 'dart:math';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

String formatTimestamp(int timestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat(format).format(date);
}

bool isImage(String filePath) {
  String extension = filePath.split('.').last;
  return extension == 'jpg' || extension == 'jpeg' || extension == 'png';
}

String randomAvatar = 'assets/avatar01.png';

String getRandomAvatar() {
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

Color getColor(String key) {
  if (key == '01') {
    return const Color(0xFFDDBB00);
  }
  if (key == '02') {
    return const Color(0xFFFC9D72);
  }
  if (key == '03') {
    return const Color(0xFF00B8BF);
  }
  if (key == '04') {
    return const Color(0xFFFED8C7);
  }

  List<Color> colors = [
    const Color(0xFF00B8BF),
    const Color(0xFFDDBB00),
    const Color(0xFFFC9D72),
  ];
  Random random = Random();
  return colors[random.nextInt(colors.length)];
}
