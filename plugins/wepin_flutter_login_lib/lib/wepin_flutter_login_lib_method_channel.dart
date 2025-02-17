import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wepin_flutter_login_lib/type/app_auth_native.dart';

import 'wepin_flutter_login_lib_platform_interface.dart';

/// An implementation of [WepinFlutterLoginLibPlatform] that uses method channels.
class MethodChannelWepinFlutterLoginLib extends WepinFlutterLoginLibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wepin_flutter_login_lib');

  @override
  Future<AuthorizeResult?> authorize(AuthConfiguration config) async {
    final token = await methodChannel.invokeMethod('authorize', config.toJson());
    return AuthorizeResult.fromJson(token);
  }

  @override
  Future<String> hashPw({required String password, required String salt}) async {
    return await methodChannel.invokeMethod(
        'hashPw', {'password': password, 'salt': salt});
  }
}
