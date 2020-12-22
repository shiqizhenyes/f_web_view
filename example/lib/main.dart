import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:f_web_view/f_web_view.dart';

void main() {
  runApp(MyApp());
  if(Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FWebView.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  String _title = "Plugin example app";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Center(
          child: Column(
            children: [
              Text("platformVersion $_platformVersion"),
              Expanded(
                child: FWebView(
                  url: "https://m.bilibili.com",
                  enableJavaScript: true,
                  viewCreateCallBack: (result, id) {
                    setState(() {
                      initPlatformState();
                    });
                  },
                  onReceivedTitle: (title) {
                    setState(() {
                      _title = title;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
