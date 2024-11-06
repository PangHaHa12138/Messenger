import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class Ringtone {
  final String name;
  final String url;
  bool playing = false;

  Ringtone({required this.name, required this.url});
}

class RingtoneSelectionPage extends StatefulWidget {
  @override
  _RingtoneSelectionPageState createState() => _RingtoneSelectionPageState();
}

class _RingtoneSelectionPageState extends State<RingtoneSelectionPage> {
  SharedPreferences? _prefs;
  Ringtone? _selectedRingtone;
  final List<Ringtone> _ringtones = [
    Ringtone(name: '', url: ''),
    Ringtone(name: '緊急アラームの効果音', url: '110.mp3'),
    Ringtone(name: '応急処置アラームの効果音', url: '120.mp3'),
    Ringtone(name: '盗難防止アラーム音', url: '119.mp3'),
    Ringtone(name: 'アラーム音のループ効果音', url: '1101.mp3'),
    Ringtone(name: '電子時計のアラーム音', url: '1102.mp3'),
    Ringtone(name: 'ヒップホップのトランペットの音', url: '1103.mp3'),
    Ringtone(name: '漫画のアラーム効果音', url: '1104.mp3'),
    Ringtone(name: '急須の水が沸騰する音', url: '1105.mp3'),
    Ringtone(name: '車の警報音の効果音', url: '1106.mp3'),
    Ringtone(name: '空襲警報の効果音', url: '1107.mp3'),
    Ringtone(name: 'アイテムアップグレード効果音', url: '1108.mp3'),
    Ringtone(name: '消防車の警笛効果音', url: '1109.mp3'),
    Ringtone(name: '花火', url: '1110.mp3'),
    Ringtone(name: 'スマートフォンの着信音', url: '1111.mp3'),
    Ringtone(name: 'シェルストリート', url: '1112.mp3'),
    Ringtone(name: 'コンビニの呼び鈴の効果音', url: '1113.mp3'),
    Ringtone(name: 'ダイナミックで陽気な効果音', url: '1114.mp3'),
    Ringtone(name: '最も人気のある着信音', url: '1115.mp3'),
    Ringtone(name: 'クラシック着信音', url: '1116.mp3'),
    Ringtone(name: 'アドベンチャーゲームのBGM', url: '1117.mp3'),
    Ringtone(name: '車のコマーシャルオープニング', url: '1118.mp3'),
    Ringtone(name: 'クリアなドアベル音', url: '1119.mp3'),
    Ringtone(name: '心地よいモバイル音楽の着信音', url: '1120.mp3'),
    Ringtone(name: '風の歌を聞く', url: '1121.mp3'),
    Ringtone(name: '軽くてリラックスできる BGM', url: '1122.mp3'),
    Ringtone(name: 'きしむ', url: '1123.mp3'),
    Ringtone(name: 'ヒップでハッピー', url: '1124.mp3'),
    Ringtone(name: 'モバイルメッセージの効果音', url: '1125.mp3'),
    Ringtone(name: 'スマホのデフォルト着信音', url: '1126.mp3'),
    Ringtone(name: 'スマホレーダー着信音', url: '1127.mp3'),
    Ringtone(name: 'さわやかな着信音', url: '1128.mp3'),
    Ringtone(name: '新しいメッセージの効果音', url: '1129.mp3'),
    Ringtone(name: 'ドアベルを鳴らす音', url: '1130.mp3'),
    Ringtone(name: 'マリンバの着信音', url: '1131.mp3'),
    Ringtone(name: 'ロボットの着信音', url: '1132.mp3'),
    Ringtone(name: '「ディン」という効果音', url: '1133.mp3'),
    Ringtone(name: '人気の広告音楽', url: '1134.mp3'),
    Ringtone(name: 'おやすみ、お嬢様', url: '1135.mp3'),
    Ringtone(name: 'デジタル電話の着信音', url: '1136.mp3'),
    Ringtone(name: '古典的な電話の着信音', url: '1137.mp3'),
    Ringtone(name: '電話の着信音', url: '1138.mp3'),
  ];
  final player = AudioPlayer();
  double _currentSliderValue = 30;
  int _selectedVolume = 100;

  @override
  void initState() {
    super.initState();
    _loadSelectedRingtone();
    _loadVolumeSetting();
  }

  void _saveVolumeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedVolume', _selectedVolume);
    print('===> 保存音量选择: $_selectedVolume');
  }

  void _loadVolumeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedVolume = prefs.getInt('selectedVolume') ?? 100;
      _currentSliderValue = _selectedVolume.toDouble();
    });
    print('===> 加载音量选择: $_selectedVolume');
  }

  Future<void> _loadSelectedRingtone() async {
    _prefs = await SharedPreferences.getInstance();
    String? selectedRingtoneUrl = _prefs?.getString('selectedRingtoneUrl');
    if (selectedRingtoneUrl != null) {
      setState(() {
        _selectedRingtone = _ringtones.firstWhere(
          (ringtone) => ringtone.url == selectedRingtoneUrl,
          orElse: () => _ringtones.first,
        );
      });
    } else {
      setState(() {
        _selectedRingtone = _ringtones.first;
      });
    }
  }

  void _saveSelectedRingtone(String url) {
    _prefs?.setString('selectedRingtoneUrl', url);
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          '着信音',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
          controller: ScrollController(),
          itemCount: _ringtones.length,
          itemBuilder: (context, index) {
            final ringtone = _ringtones[index];
            bool isSelected = ringtone.url == _selectedRingtone?.url;
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 30, top: 24, bottom: 12),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '音量',
                        style:
                            TextStyle(color: Color(0xFFB7BBC0), fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xFFF7F7F7),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding:
                        const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: const SliderThemeData(
                              trackHeight: 4, // 轨道高度
                              trackShape:
                                  RoundedRectSliderTrackShape(), // 轨道形状，可以自定义
                              activeTrackColor: Color(0xFF015CD6), // 激活的轨道颜色
                              inactiveTrackColor: Color(0xFFE0E0E1), // 未激活的轨道颜色
                              thumbColor: Colors.white, // 滑块颜色
                              thumbShape: RoundSliderThumbShape(
                                  //  滑块形状，可以自定义
                                  enabledThumbRadius: 18 // 滑块大小
                                  ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 10, // 设置滑块的覆盖层半径
                              ),
                            ),
                            child: Slider(
                              value: _currentSliderValue,
                              min: 0.0,
                              max: 100.0,
                              onChanged: (value) {
                                setState(() {
                                  _currentSliderValue = value;
                                  _selectedVolume = _currentSliderValue.toInt();
                                  _saveVolumeSetting();
                                });
                              },
                            ),
                          ),
                        ),
                        Text(
                          '${_currentSliderValue.toInt()}%',
                          style: const TextStyle(
                              color: Color(0xFF015CD6), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 30, top: 50, bottom: 16),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '通知効果音',
                        style:
                            TextStyle(color: Color(0xFFB7BBC0), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Radio(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const Color(0xFF015CD6);
                            }
                            return const Color(0xFFE0E0E1);
                          }),
                          value: ringtone.url,
                          groupValue: _selectedRingtone?.url,
                          onChanged: (value) {
                            setState(() {
                              _selectedRingtone = ringtone;
                              _saveSelectedRingtone(ringtone.url);
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            ringtone.name,
                            style: const TextStyle(
                                color: Color(0xFF222222), fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Image.asset(
                            ringtone.playing
                                ? 'images/pause.png'
                                : 'images/play.png',
                            width: 35,
                            height: 35,
                          ),
                          onTap: () async {
                            if (ringtone.playing) {
                              await player.pause();
                              setState(() {
                                ringtone.playing = false;
                              });
                            } else {
                              setState(() {
                                for (var element in _ringtones) {
                                  element.playing = false;
                                }
                                ringtone.playing = true;
                              });
                              await player.setVolume(1.0);
                              await player.play(AssetSource(ringtone.url));
                              player.onPlayerComplete.listen((event) {
                                setState(() {
                                  ringtone.playing = false;
                                });
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(color: Color(0xFFEDEDED), height: 1),
                  ),
                  if (index == _ringtones.length - 1)
                    const SizedBox(height: 30),
                ],
              );
            }
          }),
    );
  }
}
