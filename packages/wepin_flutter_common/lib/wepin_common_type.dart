// WepinUserInfo 클래스
class WepinUserInfo {
  final String userId;
  final String email;
  final String provider;
  final bool use2FA;

  WepinUserInfo({
    required this.userId,
    required this.email,
    required this.provider,
    required this.use2FA,
  });

  factory WepinUserInfo.fromJson(Map<String, dynamic> json) {
    return WepinUserInfo(
      userId: json['userId'],
      email: json['email'],
      provider: json['provider']!,
      use2FA: json['use2FA'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'provider': provider,
    'use2FA': use2FA,
  };

  @override
  String toString() {
    return 'WepinUserInfo(userId: $userId, email: $email, provider: $provider, use2FA: $use2FA)';
  }
}

// WepinUserStatus 클래스
class WepinUserStatus {
  final String loginStatus;
  final bool? pinRequired;

  WepinUserStatus({required this.loginStatus, this.pinRequired});

  factory WepinUserStatus.fromJson(Map<String, dynamic> json) {
    return WepinUserStatus(
      loginStatus: json['loginStatus']!,
      pinRequired: json['pinRequired'],
    );
  }

  Map<String, dynamic> toJson() => {
    'loginStatus': loginStatus,
    'pinRequired': pinRequired,
  };

  @override
  String toString() {
    return 'WepinUserStatus(loginStatus: $loginStatus, pinRequired: $pinRequired)';
  }
}

// WepinUser 클래스
class WepinUser {
  final String status;
  final WepinUserInfo? userInfo;
  final String? walletId;
  final WepinUserStatus? userStatus;
  final WepinToken? token;

  WepinUser({
    required this.status,
    this.userInfo,
    this.walletId,
    this.userStatus,
    this.token,
  });

  factory WepinUser.fromJson(Map<String, dynamic> json) {
    return WepinUser(
      status: json['status'],
      userInfo: json['userInfo'] != null ? WepinUserInfo.fromJson(json['userInfo']) : null,
      walletId: json['walletId'],
      userStatus: json['userStatus'] != null ? WepinUserStatus.fromJson(json['userStatus']) : null,
      token: json['token'] != null ? WepinToken.fromJson(json['token']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'userInfo': userInfo?.toJson(),
    'walletId': walletId,
    'userStatus': userStatus?.toJson(),
    'token': token?.toJson(),
  };

  @override
  String toString() {
    return 'WepinUser(status: $status, userInfo: $userInfo, walletId: $walletId, userStatus: $userStatus, token: $token)';
  }
}


// WepinToken 클래스
class WepinToken {
  final String accessToken;
  final String refreshToken;

  WepinToken({required this.accessToken, required this.refreshToken});

  factory WepinToken.fromJson(Map<String, dynamic> json) {
    return WepinToken(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  @override
  String toString() {
    return 'WepinToken(accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

class LocaleMapper {
  static const Map<String, int> localeToNumber = {
    'ko': 1,
    'en': 2,
    'ja': 3,
  };

  static int? getNumberFromLocale(String locale) {
    return localeToNumber[locale];
  }

  static String? getLocaleFromNumber(int number) {
    return localeToNumber.entries
        .firstWhere((entry) => entry.value == number, orElse: () => const MapEntry('', 0))
        .key;
  }
}