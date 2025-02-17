import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wepin_flutter_login_lib/type/app_auth_native.dart';

import 'wepin_flutter_login_lib_method_channel.dart';

abstract class WepinFlutterLoginLibPlatform extends PlatformInterface {
  /// Constructs a WepinFlutterLoginLibPlatform.
  WepinFlutterLoginLibPlatform() : super(token: _token);

  static final Object _token = Object();

  static WepinFlutterLoginLibPlatform _instance = MethodChannelWepinFlutterLoginLib();

  /// The default instance of [WepinFlutterLoginLibPlatform] to use.
  ///
  /// Defaults to [MethodChannelWepinFlutterLoginLib].
  static WepinFlutterLoginLibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WepinFlutterLoginLibPlatform] when
  /// they register themselves.
  static set instance(WepinFlutterLoginLibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<AuthorizeResult?> authorize(AuthConfiguration config) {
    throw UnimplementedError('authorize() has not been implemented.');
  }

  Future<String> hashPw({required String password, required String salt}) {
    throw UnimplementedError('hashPw() has not been implemented.');
  }
}
