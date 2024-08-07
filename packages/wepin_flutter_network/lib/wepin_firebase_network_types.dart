class SignInResponse {
  final String localId;
  final String email;
  final String displayName;
  final String idToken;
  final bool registered;
  final String refreshToken;
  final String expiresIn;

  SignInResponse({
    required this.localId,
    required this.email,
    required this.displayName,
    required this.idToken,
    required this.registered,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      localId: json['localId'],
      email: json['email'],
      displayName: json['displayName'],
      idToken: json['idToken'],
      registered: json['registered'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'email': email,
    'displayName': displayName,
    'idToken': idToken,
    'registered': registered,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
  };
}

class EmailAndPasswordRequest {
  final String email;
  final String password;
  final bool returnSecureToken;

  EmailAndPasswordRequest({
    required this.email,
    required this.password,
  }) : returnSecureToken = true;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'returnSecureToken': returnSecureToken,
  };
}

class SignInWithCustomTokenSuccess {
  final String idToken;
  final String refreshToken;

  SignInWithCustomTokenSuccess({
    required this.idToken,
    required this.refreshToken,
  });

  factory SignInWithCustomTokenSuccess.fromJson(Map<String, dynamic> json) {
    return SignInWithCustomTokenSuccess(
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
    'refreshToken': refreshToken,
  };
}

class UpdatePasswordSuccess {
  final String? kind;
  final String localId;
  final String email;
  final String? displayName;
  final String passwordHash;
  final List<WepinFBProviderUserInfo> providerUserInfo;
  final String idToken;
  final String refreshToken;
  final String expiresIn;
  final bool? emailVerified;

  UpdatePasswordSuccess({
    this.kind,
    required this.localId,
    required this.email,
    this.displayName,
    required this.passwordHash,
    required this.providerUserInfo,
    required this.idToken,
    required this.refreshToken,
    required this.expiresIn,
    this.emailVerified,
  });

  factory UpdatePasswordSuccess.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordSuccess(
      kind: json['kind'],
      localId: json['localId'],
      email: json['email'],
      displayName: json['displayName'],
      passwordHash: json['passwordHash'],
      providerUserInfo: (json['providerUserInfo'] as List)
          .map((i) => WepinFBProviderUserInfo.fromJson(i))
          .toList(),
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
      emailVerified: json['emailVerified'],
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'localId': localId,
    'email': email,
    'displayName': displayName,
    'passwordHash': passwordHash,
    'providerUserInfo': providerUserInfo.map((i) => i.toJson()).toList(),
    'idToken': idToken,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
    'emailVerified': emailVerified,
  };
}

class VerifyEmailResponse {
  final String localId;
  final String email;
  final String passwordHash;
  final List<WepinFBProviderUserInfo> providerUserInfo;

  VerifyEmailResponse({
    required this.localId,
    required this.email,
    required this.passwordHash,
    required this.providerUserInfo,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      localId: json['localId'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      providerUserInfo: (json['providerUserInfo'] as List)
          .map((i) => WepinFBProviderUserInfo.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'email': email,
    'passwordHash': passwordHash,
    'providerUserInfo': providerUserInfo.map((i) => i.toJson()).toList(),
  };
}

class VerifyEmailRequest {
  String oobCode;

  VerifyEmailRequest({required this.oobCode});

  Map<String, dynamic> toJson() => {
    'oobCode': oobCode,
  };
}

class ResetPasswordRequest {
  String oobCode;
  String newPassword;

  ResetPasswordRequest({required this.oobCode, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'oobCode': oobCode,
    'newPassword': newPassword,
  };
}

class ResetPasswordResponse {
  final String email;
  final String requestType;

  ResetPasswordResponse({required this.email, required this.requestType});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      email: json['email'],
      requestType: json['requestType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'requestType': requestType,
  };
}

class GetRefreshIdTokenRequest {
  final String refreshToken;
  final String grantType;

  GetRefreshIdTokenRequest({required this.refreshToken})
      : grantType = 'refresh_token';

  Map<String, dynamic> toJson() => {
    'refresh_token': refreshToken,
    'grant_type': grantType,
  };
}

class GetRefreshIdTokenSuccess {
  final String expiresIn;
  final String tokenType;
  final String refreshToken;
  final String idToken;
  final String userId;
  final String projectId;

  GetRefreshIdTokenSuccess({
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
    required this.idToken,
    required this.userId,
    required this.projectId,
  });

  factory GetRefreshIdTokenSuccess.fromJson(Map<String, dynamic> json) {
    return GetRefreshIdTokenSuccess(
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
      refreshToken: json['refresh_token'],
      idToken: json['id_token'],
      userId: json['user_id'],
      projectId: json['project_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'expires_in': expiresIn,
    'token_type': tokenType,
    'refresh_token': refreshToken,
    'id_token': idToken,
    'user_id': userId,
    'project_id': projectId,
  };
}

class GetCurrentUserRequest {
  final String idToken;

  GetCurrentUserRequest({required this.idToken});

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
  };
}

class GetCurrentUserResponse {
  final List<WepinFBUserInfo> users;

  GetCurrentUserResponse({required this.users});

  factory GetCurrentUserResponse.fromJson(Map<String, dynamic> json) {
    return GetCurrentUserResponse(
      users: (json['users'] as List)
          .map((i) => WepinFBUserInfo.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'users': users.map((i) => i.toJson()).toList(),
  };
}

class WepinFBUserInfo {
  final String localId;
  final String email;
  final bool emailVerified;
  final String displayName;
  final List<WepinFBProviderUserInfo> providerUserInfo;
  final String photoUrl;
  final String passwordHash;
  final String? passwordUpdatedAt;
  final String validSince;
  final bool disabled;
  final String lastLoginAt;
  final String createdAt;
  final bool customAuth;

  WepinFBUserInfo({
    required this.localId,
    required this.email,
    required this.emailVerified,
    required this.displayName,
    required this.providerUserInfo,
    required this.photoUrl,
    required this.passwordHash,
    this.passwordUpdatedAt,
    required this.validSince,
    required this.disabled,
    required this.lastLoginAt,
    required this.createdAt,
    required this.customAuth,
  });

  factory WepinFBUserInfo.fromJson(Map<String, dynamic> json) {
    return WepinFBUserInfo(
      localId: json['localId'],
      email: json['email'],
      emailVerified: json['emailVerified'],
      displayName: json['displayName'],
      providerUserInfo: (json['providerUserInfo'] as List)
          .map((i) => WepinFBProviderUserInfo.fromJson(i))
          .toList(),
      photoUrl: json['photoUrl'],
      passwordHash: json['passwordHash'],
      passwordUpdatedAt: json['passwordUpdatedAt'],
      validSince: json['validSince'],
      disabled: json['disabled'],
      lastLoginAt: json['lastLoginAt'],
      createdAt: json['createdAt'],
      customAuth: json['customAuth'],
    );
  }

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'email': email,
    'emailVerified': emailVerified,
    'displayName': displayName,
    'providerUserInfo': providerUserInfo.map((i) => i.toJson()).toList(),
    'photoUrl': photoUrl,
    'passwordHash': passwordHash,
    'passwordUpdatedAt': passwordUpdatedAt,
    'validSince': validSince,
    'disabled': disabled,
    'lastLoginAt': lastLoginAt,
    'createdAt': createdAt,
    'customAuth': customAuth,
  };
}

class WepinFBProviderUserInfo {
  final String providerId;
  final String? displayName;
  final String? photoUrl;
  final String? federatedId;
  final String? email;
  final String? rawId;
  final String? screenName;

  WepinFBProviderUserInfo({
    required this.providerId,
    this.displayName,
    this.photoUrl,
    this.federatedId,
    this.email,
    this.rawId,
    this.screenName,
  });

  factory WepinFBProviderUserInfo.fromJson(Map<String, dynamic> json) {
    return WepinFBProviderUserInfo(
      providerId: json['providerId'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      federatedId: json['federatedId'],
      email: json['email'],
      rawId: json['rawId'],
      screenName: json['screenName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'providerId': providerId,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'federatedId': federatedId,
    'email': email,
    'rawId': rawId,
    'screenName': screenName,
  };
}
