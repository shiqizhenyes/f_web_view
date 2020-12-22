
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void FWebViewCreateCallBack(String result, int id);
typedef void OnReceivedTitle(String title);
typedef void OnPageStarted(String url);
typedef void OnPageFinished(String url);
typedef void OnProgressChanged(int progress);

class FWebView extends StatefulWidget {

  static String _viewType = "me.nice/f_web_view";

  FWebView({Key key, @required this.url, this.enableJavaScript = false ,
    this.viewCreateCallBack,
    this.onReceivedTitle,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgressChanged}): super(key: key);

  final String url;
  final bool enableJavaScript;

  final FWebViewCreateCallBack viewCreateCallBack;
  final OnReceivedTitle onReceivedTitle;
  final OnPageStarted onPageStarted;
  final OnPageFinished onPageFinished;
  final OnProgressChanged onProgressChanged;

  static const MethodChannel _channel = MethodChannel("f_web_view");

  static Future<String> get platformVersion async {
    try {
      final String version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    }catch (e) {
      return "unknown";
    }
  }

  @override
  State<StatefulWidget> createState() => _FWebViewState();

}

class _FWebViewState extends State<FWebView> {

  String _tag = "FWebView";

  @override
  void initState() {
    super.initState();
    FWebView._channel.setMethodCallHandler((call) async {
      if(call.method == "onReceivedTitle") {
        print(call);
        widget.onReceivedTitle(call.arguments);
      } else if (call.method == "onPageStarted") {
        widget.onPageStarted(call.arguments);
      } else if (call.method == "onPageFinished") {
        widget.onPageFinished(call.arguments);
      } else if (call.method == "onProgressChanged") {
        widget.onProgressChanged(call.arguments);
      } else {
        print("this plugin is not support the platform");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String viewType = "${FWebView._viewType}_${Platform.operatingSystem}";
    print("$_tag  $viewType");
    if(Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: (id) {
          widget.viewCreateCallBack("success", id);
          if (widget.enableJavaScript) {
            FWebView._channel.invokeMethod("enableJavaScript");
          }
          FWebView._channel.invokeMethod("loadUrl", {"url" : widget.url});
          print("$_tag  $id");
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: (id) {
          widget.viewCreateCallBack("success", id);
          if(widget.enableJavaScript) {
            FWebView._channel.invokeMethod("enableJavaScript");
          }
          FWebView._channel.invokeMethod("loadUrl", {"url" : widget.url});
        },
      );
    } else {
      return Text("this plugin is not support the platform");
    }
  }

}
