import 'package:flutter_test/flutter_test.dart';
import 'package:wepin_flutter_login_lib/type/app_auth_native.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib_platform_interface.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWepinFlutterLoginLibPlatform
    // with MockPlatformInterfaceMixin
    implements WepinFlutterLoginLibPlatform {

  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<AuthorizeResult?> authorize(AuthConfiguration config) {
    // TODO: implement authorize
    throw UnimplementedError();
  }
}

void main() {
  final WepinFlutterLoginLibPlatform initialPlatform = WepinFlutterLoginLibPlatform.instance;

  test('$MethodChannelWepinFlutterLoginLib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWepinFlutterLoginLib>());
  });

  test('WepinLogin', () async {
    WepinLogin wepinFlutterLoginLibPlugin = WepinLogin(wepinAppKey: '', wepinAppId: '');
    MockWepinFlutterLoginLibPlatform fakePlatform = MockWepinFlutterLoginLibPlatform();
    WepinFlutterLoginLibPlatform.instance = fakePlatform;

    expect(wepinFlutterLoginLibPlugin.wepinAppId, '');
  });
}
