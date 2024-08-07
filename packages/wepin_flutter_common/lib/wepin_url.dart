import 'package:wepin_flutter_common/wepin_error.dart';

Map<String, String> getWepinSdkUrl(String apiKey) {
  final keyType = WepinKeyTypeExtension.fromAppKey(apiKey);
  switch (keyType) {
    case WepinKeyType.dev:
      return {
        // 'wepinWebview': 'https://localhost:8989/',
        'wepinWebview': 'https://dev-v1-widget.wepin.io/',
        'sdkBackend': 'https://dev-sdk.wepin.io/v1/',
        'wallet': 'https://dev-app.wepin.io/',
      };
    case WepinKeyType.stage:
      return {
        'wepinWebview': 'https://stage-v1-widget.wepin.io/',
        'sdkBackend': 'https://stage-sdk.wepin.io/v1/',
        'wallet': 'https://stage-app.wepin.io/',
      };
    case WepinKeyType.prod:
      return {
        'wepinWebview': 'https://v1-widget.wepin.io/',
        'sdkBackend': 'https://sdk.wepin.io/v1/',
        'wallet': 'https://app.wepin.io/',
      };
    default:
      throw WepinError(WepinErrorCode.invalidAppKey);
  }
}


enum WepinKeyType {
  dev,
  stage,
  prod,
}

extension WepinKeyTypeExtension on WepinKeyType {
  String get value {
    switch (this) {
      case WepinKeyType.dev:
        return 'ak_dev';
      case WepinKeyType.stage:
        return 'ak_test';
      case WepinKeyType.prod:
        return 'ak_live';
    }
  }

  static WepinKeyType? fromAppKey(String appKey) {
    if (appKey.startsWith(WepinKeyType.dev.value)) {
      return WepinKeyType.dev;
    } else if (appKey.startsWith(WepinKeyType.stage.value)) {
      return WepinKeyType.stage;
    } else if (appKey.startsWith(WepinKeyType.prod.value)) {
      return WepinKeyType.prod;
    } else {
      return null;
    }
  }
}
