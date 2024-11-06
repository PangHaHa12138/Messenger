import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {


  String url = "https://html-dev.emb-app-stg.nishikawa1566.com/contract/contract_6.1.3_20230612114534.html";
  String url2 = "https://www.5idream.net/privacy.html";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'プライバシー規約',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: url2,
          backgroundColor: Colors.white,
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
        ),
      ),
    );
  }
}
