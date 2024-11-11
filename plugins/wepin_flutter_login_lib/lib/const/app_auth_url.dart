import 'package:wepin_flutter_common/wepin_error.dart';

String getAuthorizationEndpoint(String provider) {
  switch (provider) {
    case 'google':
      return 'https://accounts.google.com/o/oauth2/v2/auth';
    case 'apple':
      return 'https://appleid.apple.com/auth/authorize';
    case 'discord':
      return 'https://discord.com/api/oauth2/authorize';
    case 'naver':
      return 'https://nid.naver.com/oauth2.0/authorize';
    case 'line':
      return 'https://access.line.me/oauth2/v2.1/authorize';
    case 'facebook':
      return 'https://www.facebook.com/v21.0/dialog/oauth';
    default:
      throw WepinError(WepinErrorCode.invalidLoginProvider);
  }
}

String getTokenEndpoint(String provider) {
  switch (provider) {
    case 'google':
      return 'https://oauth2.googleapis.com/token';
    case 'apple':
      return 'https://appleid.apple.com/auth/token';
    case 'discord':
      return 'https://discord.com/api/oauth2/token';
    case 'naver':
      return 'https://nid.naver.com/oauth2.0/token';
    case 'line':
      return 'https://api.line.me/oauth2/v2.1/token';
    case 'facebook':
      return 'https://graph.facebook.com/v21.0/oauth/access_token';
    default:
      throw WepinError(WepinErrorCode.invalidLoginProvider);
  }
}
