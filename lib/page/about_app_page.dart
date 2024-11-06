import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    String year = DateTime.now().toString().substring(0, 4);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          '鯨について',
          style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'images/logo_startup.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 15),
                const Text(
                  '鯨',
                  style: TextStyle(
                    color: Color(0xFF015CD6),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'version: $version',
                  style: const TextStyle(
                    color: Color(0xFF015CD6),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    String url = 'https://www.gientech.com';
                    launch(url);
                  },
                  child: const Text(
                    '株式会社パクテラ',
                    style: TextStyle(
                      color: Color(0xFF015CD6),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Copyright © 1995-$year Pactera. All rights reserved.',
                  style: const TextStyle(
                    color: Color(0xFF015CD6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
