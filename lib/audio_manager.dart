import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'dart:async';

class AudioManager {
  // 单例实例
  static final AudioManager _instance = AudioManager._();
  // 私有构造函数
  AudioManager._();
  // 工厂构造函数返回单例实例
  factory AudioManager() => _instance;

  final AudioPlayer _player = AudioPlayer();
  Timer? _vibrateTimer;

  Future<void> startVibrate() async {
    stopVibrate();
    Vibration.hasVibrator().then((value) {
      if (value != null && value) {
        _vibrateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          Vibration.vibrate();
        });
      }
    });
  }

  Future<void> stopVibrate() async {
    _vibrateTimer?.cancel();
    Vibration.cancel();
  }

  Future<void> startAudio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int selectedVolume = prefs.getInt('selectedVolume') ?? 100;
    String selectedRingtoneUrl =
        prefs.getString('selectedRingtoneUrl') ?? '110.mp3';
    double volume = selectedVolume * 1.0 / 100;

    print('===> volume: $volume');

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1.0);
    PerfectVolumeControl.hideUI = true;
    await PerfectVolumeControl.setVolume(volume);
    await _player.play(AssetSource(selectedRingtoneUrl));
  }

  Future<void> stopAudio() async {
    await _player.stop();
    await _player.release();
  }
}
