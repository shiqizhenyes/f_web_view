
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void FWebViewCreateCallBack(String result, int id);

class FWebView extends StatefulWidget {

  static String _viewType = "me.nice/f_web_view";

  FWebView({Key key, @required this.url, this.enableJavaScript = false , this.viewCreateCallBack}): super(key: key);

  final String url;
  final bool enableJavaScript;

  final FWebViewCreateCallBack viewCreateCallBack;

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
          FWebView._channel.invokeMethod("loadUrl", {"url" : widget.url});
          if (widget.enableJavaScript) {
            FWebView._channel.invokeMethod("enableJavaScript");
          }
          print("$_tag  $id");
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: (id) {
          widget.viewCreateCallBack("success", id);
        },
      );
    } else {
      return Text("this plugin is not support the platform");
    }
  }

}
