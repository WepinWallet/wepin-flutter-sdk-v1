import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wepin_flutter_common/wepin_error.dart';
import 'package:wepin_flutter_common/wepin_url.dart';
import 'package:wepin_flutter_network/wepin_network_types.dart';

class WepinNetwork {
  final String _wepinAppKey;
  final String _wepinBaseUrl;
  final String _domain;
  final String _version;
  Map<String, String> headers = <String, String>{};
  String? _accessToken;
  String? _refreshToken;

  WepinNetwork({
    required String wepinAppKey,
    required String domain,
    required String version,
  })  : _wepinAppKey = wepinAppKey,
        _domain = domain,
        _version = version,
        _wepinBaseUrl = getWepinSdkUrl(wepinAppKey)['sdkBackend']!
        {
          _setHeader();
        }

  static String? getErrorMessage(http.Response response) {
    final statusCode = response.statusCode;
    final errorMessage = response.body;
    // debugPrint("HTTP Error: Status Code: $statusCode, Error Message: $errorMessage");
    return "Status Code: $statusCode, Error Message: $errorMessage";
  }

  void _setHeader() {
    headers["Content-Type"] = 'application/json';
    headers["X-API-KEY"] = _wepinAppKey;
    headers["X-API-DOMAIN"] = _domain;
    headers["X-SDK-TYPE"] = "flutter-login";
    headers["X-SDK-VERSION"] = _version;
  }

  void setAuthToken(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    headers['Authorization'] = 'Bearer $_accessToken';
  }

  void clearAuthToken() {
    _accessToken = null;
    _refreshToken = null;
    headers.remove('Authorization');
  }

  Future<void> getAppInfo() async {
    final url = Uri.parse('${_wepinBaseUrl}app/info');
    final response = await http.get(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<String> getFirebaseConfig() async {
    final url = Uri.parse('${_wepinBaseUrl}user/firebase-config');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodeString = utf8.decode(base64.decode(response.body));
      final jsonObject = jsonDecode(decodeString);
      final key = jsonObject['apiKey'];
      return key;
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<LoginResponse> login(String idToken) async {
    final url = Uri.parse('${_wepinBaseUrl}user/login');
    final jsonRequestBody = jsonEncode({'idToken': idToken});
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      final res = LoginResponse.fromJson(responseBody);
      setAuthToken(res.token.accessToken, res.token.refreshToken);
      return res;
    } else {
      throw WepinError(WepinErrorCode.failedLogin, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<bool> logout({required userId}) async {
    final url = Uri.parse('${_wepinBaseUrl}user/$userId/logout');
    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      clearAuthToken();
      return true;
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<String> getAccessToken(String userId) async {
    final url = Uri.parse('${_wepinBaseUrl}user/access-token?userId=$userId&refresh_token=$_refreshToken');
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      final token = responseBody['token'];
      setAuthToken(token, _refreshToken!);
      return token;
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<LoginOauthIdTokenResponse> loginOAuthIdToken(LoginOauthIdTokenRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}user/oauth/login/id-token');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return LoginOauthIdTokenResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<LoginOauthIdTokenResponse> loginOAuthAccessToken(LoginOauthAccessTokenRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}user/oauth/login/access-token');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return LoginOauthIdTokenResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<CheckEmailExistResponse> checkEmailExist(String email) async {
    final url = Uri.parse('${_wepinBaseUrl}user/check-user?email=$email');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return CheckEmailExistResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<PasswordStateResponse> getUserPasswordState(String email) async {
    final url = Uri.parse('${_wepinBaseUrl}user/password-state?email=$email');
    final response = await http.get(url, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return PasswordStateResponse.fromJson(responseBody);
    } else {
      if (response.statusCode != 400 || !response.body.contains('not exist')) {
        throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
      }
      return PasswordStateResponse(isPasswordResetRequired: true);
    }
  }

  Future<PasswordStateResponse> updateUserPasswordState(String userId, PasswordStateRequest passwordStateRequest) async {
    final url = Uri.parse('${_wepinBaseUrl}user/$userId/password-state');
    final jsonRequestBody = jsonEncode(passwordStateRequest.toJson());
    final response = await http.patch(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return PasswordStateResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.failedPasswordStateSetting, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<VerifyResponse> verify(VerifyRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}user/verify');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return VerifyResponse.fromJson(responseBody);
    } else {
      var errorCode = WepinErrorCode.failedSendEmail;
      if (response.statusCode == 400) {
        errorCode = WepinErrorCode.invalidEmailDomain;
      }
      throw WepinError(errorCode, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }


  Future<OAuthTokenResponse> oauthTokenRequest(String provider, OAuthTokenRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}user/oauth/token/$provider');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return OAuthTokenResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<RegisterResponse> register(RegisterRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}app/register');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return RegisterResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<UpdateTermsAcceptedResponse> updateTermsAccepted(String userId, UpdateTermsAcceptedRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}user/$userId/terms-accepted');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.patch(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return UpdateTermsAcceptedResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetAccountListResponse> getAppAccountList(GetAccountListRequest params) async {
    final jsonRequestQuery = params.toJson();
    final url = Uri.parse('${_wepinBaseUrl}account').replace(
      queryParameters: jsonRequestQuery
    );
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return GetAccountListResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetAccountBalanceResponse> getAccountBalance(String accountId) async {
    final url = Uri.parse('${_wepinBaseUrl}accountbalance/$accountId/balance');
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return GetAccountBalanceResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetNFTListResponse> getNFTList(GetNFTListRequest params) async {
    final jsonRequestQuery = params.toJson();
    final url = Uri.parse('${_wepinBaseUrl}nft').replace(
        queryParameters: jsonRequestQuery
    );
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return GetNFTListResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetNFTListResponse> refreshNFTList(GetNFTListRequest params) async {
    final jsonRequestQuery = params.toJson();
    final url = Uri.parse('${_wepinBaseUrl}nft/refresh').replace(
        queryParameters: jsonRequestQuery
    );
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return GetNFTListResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

}