import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolumeSelectionPage extends StatefulWidget {
  @override
  _VolumeSelectionPageState createState() => _VolumeSelectionPageState();
}

class _VolumeSelectionPageState extends State<VolumeSelectionPage> {
  int _selectedVolume = 100; // 默认选择100%音量

  @override
  void initState() {
    super.initState();
    _loadVolumeSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('ボリュームの選択',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: ListView(
        children: [
          RadioListTile(
            title: const Text('30%のボリューム'),
            value: 30,
            groupValue: _selectedVolume,
            onChanged: (value) {
              setState(() {
                _selectedVolume = value as int;
                _saveVolumeSetting(); // 选择后自动保存
              });
            },
          ),
          const Divider(
            height: 1,
          ),
          RadioListTile(
            title: const Text('60%のボリューム'),
            value: 60,
            groupValue: _selectedVolume,
            onChanged: (value) {
              setState(() {
                _selectedVolume = value as int;
                _saveVolumeSetting(); // 选择后自动保存
              });
            },
          ),
          const Divider(
            height: 1,
          ),
          RadioListTile(
            title: const Text('90%のボリューム'),
            value: 90,
            groupValue: _selectedVolume,
            onChanged: (value) {
              setState(() {
                _selectedVolume = value as int;
                _saveVolumeSetting(); // 选择后自动保存
              });
            },
          ),
          const Divider(
            height: 1,
          ),
          RadioListTile(
            title: const Text('100%のボリューム'),
            value: 100,
            groupValue: _selectedVolume,
            onChanged: (value) {
              setState(() {
                _selectedVolume = value as int;
                _saveVolumeSetting(); // 选择后自动保存
              });
            },
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  void _saveVolumeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedVolume', _selectedVolume);
    print('保存音量选择: $_selectedVolume');
  }

  void _loadVolumeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedVolume = prefs.getInt('selectedVolume') ?? 100;
    });
    print('加载音量选择: $_selectedVolume');
  }
}