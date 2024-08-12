class AuthConfiguration {
  late String wepinAppId;
  late String clientId;
  late List<String> scopes;
  late String redirectUrl;
  late ServiceConfiguration serviceConfiguration;
  Map<String, String>? additionalParameters;
  bool? skipCodeExchange;
  AuthConfiguration(this.wepinAppId, this.clientId, this.scopes, this.redirectUrl, this.serviceConfiguration, this.additionalParameters, this.skipCodeExchange);

  Map<String, dynamic> toJson() {
    return {
      'wepinAppId': wepinAppId,
      'clientId': clientId,
      'scopes': scopes,
      'redirectUrl': redirectUrl,
      'serviceConfiguration': serviceConfiguration.toJson(),
      'additionalParameters': additionalParameters,
      'skipCodeExchange': skipCodeExchange,
    };
  }

  static AuthConfiguration fromJson(Map<dynamic, dynamic> json) {
    return AuthConfiguration(
      json['wepinAppId'],
      json['clientId'],
      json['scopes']?.cast<String>(),
      json['redirectUrl'],
      ServiceConfiguration.fromJson(json['serviceConfiguration']),
      Map<String, String>.from(json['additionalParameters'] ?? {}),
      json['skipCodeExchange'],
    );
  }
}



class ServiceConfiguration {
  late String authorizationEndpoint;
  late String tokenEndpoint;
  ServiceConfiguration(this.authorizationEndpoint, this.tokenEndpoint);

  Map<String, dynamic> toJson() {
    return {
      'authorizationEndpoint': authorizationEndpoint,
      'tokenEndpoint': tokenEndpoint,
    };
  }

  static ServiceConfiguration fromJson(Map<dynamic, dynamic> json) {
    return ServiceConfiguration(
      json['authorizationEndpoint'],
      json['tokenEndpoint'],
    );
  }
}


class AuthorizeResult {
  late String? accessToken;
  late String? accessTokenExpirationDate;
  late String? idToken;
  late String? refreshToken;
  late String? tokenType;
  late List<String>? scopes;
  late String? authorizationCode;
  late String? state;
  String? codeVerifier;

  AuthorizeResult(
    this.accessToken,
    this.accessTokenExpirationDate,
    this.idToken,
    this.refreshToken,
    this.tokenType,
    this.scopes,
    this.authorizationCode,
    this.state,
    this.codeVerifier,
  );

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'accessTokenExpirationDate': accessTokenExpirationDate,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'scopes': scopes,
      'authorizationCode': authorizationCode,
      'state': state,
      'codeVerifier': codeVerifier,
    };
  }

  static AuthorizeResult fromJson(Map<dynamic, dynamic> json) {

    return AuthorizeResult(
      json['accessToken'],
      json['accessTokenExpirationDate'],
      json['idToken'],
      json['refreshToken'],
      json['tokenType'],
      json['scopes']?.cast<String>(),
      json['authorizationCode'],
      json['state'],
      json['codeVerifier'],
    );
  }
}