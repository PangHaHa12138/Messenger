import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'アラーム統計',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '24時間の衝突事故数',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (_, value) => const TextStyle(color: Colors.black),
                      margin: 10,
                      getTitles: (double value) {
                        return value.toInt().toString();
                      },
                    ),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: _generateBarGroupsForHours(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '週あたりの衝突件数',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (_, value) => const TextStyle(color: Colors.black),
                      margin: 10,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return '月曜日に';
                          case 1:
                            return '火曜日';
                          case 2:
                            return '水曜日';
                          case 3:
                            return '木曜日';
                          case 4:
                            return '金曜日';
                          case 5:
                            return '土曜日';
                          case 6:
                            return '日曜日';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: _generateBarGroupsForWeeks(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '月ごとの衝突事故の数',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (_, value) => const TextStyle(color: Colors.black),
                      margin: 10,
                      getTitles: (double value) {
                        return '${value.toInt() + 1}月';
                      },
                    ),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: _generateBarGroupsForMonths(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'iOS がクラッシュしたモバイル デバイスの割合',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'iPhone 11',
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.green,
                      title: 'iPhone 14',
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.red,
                      title: 'iPhone 12',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'クラッシュした Android モバイル デバイスの割合',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'pixel 7',
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.green,
                      title: 'AQUOS sense8',
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.red,
                      title: 'OPPO FindX7',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '携帯電話システムがクラッシュした iOS の割合',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'ios 17',
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.green,
                      title: 'ios 16',
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.red,
                      title: 'ios 15',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Android がクラッシュした携帯電話システムの割合',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'android 14',
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.green,
                      title: 'android 13',
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.red,
                      title: 'android 12',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroupsForHours() {
    List<double> hoursData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4];
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < 24; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(y: hoursData[i], colors: [Colors.blue]),
          ],
        ),
      );
    }

    return barGroups;
  }

  List<BarChartGroupData> _generateBarGroupsForWeeks() {
    List<double> weeksData = [10, 20, 30, 40, 50, 60, 70];
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < 7; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(y: weeksData[i], colors: [Colors.green]),
          ],
        ),
      );
    }

    return barGroups;
  }

  List<BarChartGroupData> _generateBarGroupsForMonths() {
    List<double> monthsData = [50, 60, 55, 70, 65, 80, 75, 90, 85, 100, 95, 110];
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(y: monthsData[i], colors: [Colors.red]),
          ],
        ),
      );
    }

    return barGroups;
  }
}
