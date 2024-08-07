export 'package:wepin_flutter_common/wepin_common_type.dart';
export 'package:wepin_flutter_common/wepin_error.dart';

// LoginResult 클래스
class LoginResult {
  final String provider;
  final WepinFBToken token;

  LoginResult({required this.provider, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      provider: json['provider'],
      token: WepinFBToken.fromJson(json['token']),
    );
  }

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'token': token.toJson(),
  };

  @override
  String toString() {
    return 'LoginResult(provider: $provider, token: $token)';
  }
}

class LoginOauthResult {
  final String provider;
  final WepinOauthTokenType type;
  final String token;

  LoginOauthResult({
    required this.provider,
    required this.token,
    required this.type,
  });

  @override
  String toString() {
    return 'LoginOauthResult(provider: $provider, type: $type, token: $token)';
  }

  factory LoginOauthResult.fromJson(Map<String, dynamic> json) {
    return LoginOauthResult(
      provider: json['provider'],
      token: json['token'],
      type: WepinOauthTokenTypeExtension.fromValue(json['type'])!,
    );
  }

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'token': token,
    'type': type.toValue(),
  };
}

// WepinOauthTokenType 열거형
enum WepinOauthTokenType { idToken, accessToken }

extension WepinOauthTokenTypeExtension on WepinOauthTokenType {
  static WepinOauthTokenType? fromValue(String value) {
    switch (value) {
      case 'id_token':
        return WepinOauthTokenType.idToken;
      case 'accessToken':
        return WepinOauthTokenType.accessToken;
      default:
        return null;
    }
  }

  String toValue() {
    switch (this) {
      case WepinOauthTokenType.idToken:
        return 'id_token';
      case WepinOauthTokenType.accessToken:
        return 'accessToken';
    }
  }
}

// WepinFBToken 클래스
class WepinFBToken {
  final String idToken;
  final String refreshToken;

  WepinFBToken({required this.idToken, required this.refreshToken});

  factory WepinFBToken.fromJson(Map<String, dynamic> json) {
    return WepinFBToken(
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
    'refreshToken': refreshToken,
  };

  @override
  String toString() {
    return 'WepinFBToken(idToken: $idToken, refreshToken: $refreshToken)';
  }
}
