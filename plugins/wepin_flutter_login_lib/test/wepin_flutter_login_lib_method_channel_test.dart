import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // MethodChannelWepinFlutterLoginLib platform = MethodChannelWepinFlutterLoginLib();
  const MethodChannel channel = MethodChannel('wepin_flutter_login_lib');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

}
