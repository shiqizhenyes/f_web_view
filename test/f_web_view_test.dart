import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:f_web_view/f_web_view.dart';

void main() {
  const MethodChannel channel = MethodChannel('f_web_view');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FWebView.platformVersion, '42');
  });
}
