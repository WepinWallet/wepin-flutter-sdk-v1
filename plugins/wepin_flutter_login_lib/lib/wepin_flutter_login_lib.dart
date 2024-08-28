import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:wepin_flutter_common/wepin_flutter_common.dart';
import 'package:wepin_flutter_common/wepin_url.dart';
import 'package:wepin_flutter_login_lib/const/app_auth_url.dart';
import 'package:wepin_flutter_login_lib/const/reg_exp.dart';
import 'package:wepin_flutter_login_lib/session/wepin_session_check.dart';
import 'package:wepin_flutter_login_lib/src/version.dart';
import 'package:wepin_flutter_login_lib/type/app_auth_native.dart';
import 'package:wepin_flutter_login_lib/type/wepin_flutter_login_lib_type.dart';
import 'package:wepin_flutter_network/wepin_firebase_network.dart';
import 'package:wepin_flutter_network/wepin_firebase_network_types.dart';
import 'package:wepin_flutter_network/wepin_network.dart';
import 'package:wepin_flutter_network/wepin_network_types.dart';
import 'wepin_flutter_login_lib_platform_interface.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';

import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';


class WepinLogin {
  bool _isInitialized = false;
  final String _wepinAppKey;
  final String wepinAppId;
  String? domain;
  String? version;
  WepinNetwork? _wepinNetwork;
  WepinFirebaseNetwork? _wepinFirebaseNetwork;
  WepinLoginSessionManager? _wepinSessionManager;

  WepinLogin({required String wepinAppKey, required this.wepinAppId})
      : _wepinAppKey = wepinAppKey;

  Future<void> init() async {
    if(_isInitialized) {
      throw WepinError(WepinErrorCode.alreadyInitialized);
    }
    try {
      domain = await WepinCommon.getPackageName();
      // print('domain - $domain');
      version = packageVersion;
      _wepinNetwork = WepinNetwork(wepinAppKey: _wepinAppKey, domain: domain!, version: version!, type: 'flutter_login');

      await _wepinNetwork?.getAppInfo();
      final firebaseKey = await _wepinNetwork?.getFirebaseConfig();
      if(firebaseKey != null){
        _wepinFirebaseNetwork = WepinFirebaseNetwork(firebaseKey: firebaseKey);
        _wepinSessionManager = WepinLoginSessionManager(appId: wepinAppId, wepinNetwork: _wepinNetwork!, wepinFirebaseNetwork: _wepinFirebaseNetwork!);
        _isInitialized = true;
      }
    }catch(e){
      if(e is WepinError) {
        rethrow;
      }
      throw WepinError(WepinErrorCode.unknownError, e.toString());
    }
  }

  bool isInitialized() {
    return _isInitialized;
  }

  Future<void> finalize() async {
    await _wepinSessionManager?.clearSession();
    _isInitialized = false;
  }

  Future<LoginOauthResult?> loginWithOauthProvider({required String provider, required String clientId}) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    await _wepinSessionManager?.clearSession();

    final authEndpoint = getAuthorizationEndpoint(provider);
    final tokenEndpoint = getTokenEndpoint(provider);

    final additionalParameters = <String, String>{
      'prompt': 'select_account',
    };

    try {
      if (provider == 'apple') {
        additionalParameters['response_mode'] = 'form_post';
      }

      final config = AuthConfiguration(
          wepinAppId,
          clientId,
          provider == 'discord' ? ['identify', 'email'] : ['email'],
          '${getWepinSdkUrl(_wepinAppKey)['sdkBackend']}user/oauth/callback?uri=${Uri
              .encodeComponent('wepin.$wepinAppId:/oauth2redirect')
              .toString()}',
          ServiceConfiguration(authEndpoint, tokenEndpoint),
          additionalParameters,
          provider != 'discord'
      );

      final result = await WepinFlutterLoginLibPlatform.instance.authorize(config);
      if (result == null) {
        throw WepinError(WepinErrorCode.failedLogin);
      }
      if (provider == 'discord') {
        return LoginOauthResult(provider: provider,
            type: WepinOauthTokenType.accessToken,
            token: result.accessToken!);
      } else {
        final code = result.authorizationCode;
        final state = result.state;
        final codeVerifier = result.codeVerifier;
        final redirectUri = config.redirectUrl;
        final tokenResponse = await _wepinNetwork?.oauthTokenRequest(
            provider,
            OAuthTokenRequest(
                clientId: clientId,
                code: code!,
                state: state,
                codeVerifier: codeVerifier,
                redirectUri: redirectUri
            ));
        if (tokenResponse == null) {
          throw WepinError(WepinErrorCode.invalidToken);
        }
        return provider == 'naver' ? LoginOauthResult(
            provider: provider,
            type: WepinOauthTokenType.accessToken,
            token: tokenResponse.accessToken
        ) : LoginOauthResult(
            provider: provider,
            type: WepinOauthTokenType.idToken,
            token: tokenResponse.idToken!
        );
      }
    } catch (e) {
      if (e is WepinError) {
        rethrow;
      }
      if ( e is PlatformException && e.code == 'user_canceled') {
        throw WepinError(WepinErrorCode.userCancelled, e.toString());
      }
      throw WepinError(WepinErrorCode.unknownError, e.toString());
    }
  }



  Future<LoginResult> _loginWithEmailAndResetPasswordState(String email, String password) async {
    await _wepinSessionManager?.clearSession();

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }
    bool isPasswordResetRequired = false;
    final resPwState = await _wepinNetwork!.getUserPasswordState(email.trim());
    isPasswordResetRequired = resPwState.isPasswordResetRequired;

    final encPassword = await FlutterBcrypt.hashPw(
        password: password,
        salt: bcryptSalt); // bcrypt!!!
    final resPassword = isPasswordResetRequired?  password : encPassword;
    final signInRequest = EmailAndPasswordRequest(email: email.trim(), password: resPassword);
    final signInResponse = await _wepinFirebaseNetwork!.signInWithEmailPassword(signInRequest);
    final token = await _changePassword(email, encPassword, WepinFBToken(
      idToken: signInResponse.idToken,
      refreshToken: signInResponse.refreshToken
    ));

    await _wepinSessionManager?.setFirebaseSessionStorage(token, 'email');

    return LoginResult(
      provider: 'email',
      token: token,
    );
  }

  Future<WepinFBToken> _changePassword(String email, String password, WepinFBToken token) async {
    bool isPasswordResetRequired;
    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }
    final resPwState = await _wepinNetwork!.getUserPasswordState(email.trim());
    isPasswordResetRequired = resPwState.isPasswordResetRequired;

    if (!isPasswordResetRequired) return token;
    final res = await _wepinNetwork!.login(token.idToken);

    final resUpdatePW = await _wepinFirebaseNetwork!.updatePassword(token.idToken, password);

    _wepinNetwork!.setAuthToken(res.token.accessToken, res.token.refreshToken);

    await _wepinNetwork!.updateUserPasswordState(res.userInfo.userId, PasswordStateRequest(isPasswordResetRequired: false));

    await _wepinNetwork!.logout(userId: res.userInfo.userId);
    _wepinNetwork!.clearAuthToken();

    return WepinFBToken(
      idToken: resUpdatePW.idToken,
      refreshToken: resUpdatePW.refreshToken,
    );
  }

  Future<Map<String, String>> _checkAndVerifyEmail({
    required String email,
    String? locale,
  }) async {
    final checkEmailExist = await _wepinNetwork!.checkEmailExist(email);

    final isEmailExist = checkEmailExist.isEmailExist;
    final isEmailVerified = checkEmailExist.isEmailVerified;
    final providerIds = checkEmailExist.providerIds;

    if (isEmailExist && isEmailVerified && providerIds.contains('password')) {
      throw WepinError(WepinErrorCode.existedEmail);
    }

    final verify = await _wepinNetwork!.verify(VerifyRequest(
      type: 'create',
      email: email,
      localeId: locale == 'ko' ? 1 : 2
    ));

    if (verify.oobReset == null || verify.oobVerify == null) {
      throw WepinError(WepinErrorCode.requiredEmailVerified);
    }

    return {
      'oobReset': verify.oobReset!,
      'oobVerify': verify.oobVerify!,
    };
  }

  Future<void> _signUpEmail({
    required String oobReset,
    required String oobVerify,
    required String email,
    required String password,
  }) async {
    final resetPassword = await _wepinFirebaseNetwork!.resetPassword(ResetPasswordRequest(oobCode: oobReset, newPassword: password));

    if (resetPassword.email.toLowerCase() != email.toLowerCase()) {
      throw WepinError(WepinErrorCode.failedPasswordSetting);
    }

    final verifyEmail = await _wepinFirebaseNetwork!.verifyEmail(VerifyEmailRequest(oobCode: oobVerify));

    if (verifyEmail.email.toLowerCase() != email.toLowerCase()) {
      throw WepinError(WepinErrorCode.failedEmailVerified);
    }
  }

  Future<LoginResult> singUpWithEmailAndPassword({required String email, required String password, String? locale}) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if (!emailRegExp.hasMatch(email)) {
      throw WepinError(WepinErrorCode.incorrectEmailForm);
    }

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    final checkAndVerifyResult = await _checkAndVerifyEmail(
      email: email.trim(),
      locale: locale,
    );

    await _wepinSessionManager?.clearSession();

    if (!passwordRegExp.hasMatch(password)) {
      throw WepinError(WepinErrorCode.incorrectPasswordForm);
    }

    await _signUpEmail(
      oobReset: checkAndVerifyResult['oobReset']!,
      oobVerify: checkAndVerifyResult['oobVerify']!,
      email: email.trim(),
      password: password,
    );

    return await _loginWithEmailAndResetPasswordState(email, password);

  }

  Future<LoginResult> loginWithEmailAndPassword({required String email, required String password}) async {
    if (!_isInitialized) {
      throw WepinError(
        WepinErrorCode.notInitialized);
    }

    if (!emailRegExp.hasMatch(email)) {
      throw WepinError(WepinErrorCode.incorrectEmailForm);
    }

    if (!passwordRegExp.hasMatch(password)) {
      throw WepinError(WepinErrorCode.incorrectPasswordForm);
    }

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    try{
      final checkEmailExist = await _wepinNetwork!.checkEmailExist(email);
      final isEmailExist = checkEmailExist.isEmailExist;
      final isEmailVerified = checkEmailExist.isEmailVerified;
      final providerIds = checkEmailExist.providerIds;

      if (isEmailExist && isEmailVerified && providerIds.contains('password')) {
        return await _loginWithEmailAndResetPasswordState(email, password);
      } else {
        throw WepinError(WepinErrorCode.requiredSignupEmail);
      }
    }catch(e){
      if (e is WepinError) {
        rethrow;
      }
      throw WepinError(WepinErrorCode.unknownError, e.toString());
    }
  }

  Future<LoginResult> _doFirebaseLoginWithCustomToken(
      String customToken, String provider) async {
    final signInResult = await _wepinFirebaseNetwork!.signInWithCustomToken(customToken);

    final idToken = signInResult.idToken;
    final refreshToken = signInResult.refreshToken;

    await _wepinSessionManager?.setFirebaseSessionStorage(WepinFBToken(idToken: idToken, refreshToken: refreshToken), 'external_token');

    return LoginResult(provider: provider, token: WepinFBToken( idToken: idToken, refreshToken: refreshToken));
  }

  Future<LoginResult> loginWithIdToken({required String idToken, String? sign}) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    await _wepinSessionManager?.clearSession();
    final params = LoginOauthIdTokenRequest(idToken: idToken, sign: sign);

    final res = await _wepinNetwork!.loginOAuthIdToken(params);

    return await _doFirebaseLoginWithCustomToken(res.token!, 'external_token');
  }

  Future<LoginResult> loginWithAccessToken({required String provider, required String accessToken, String? sign}) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    await _wepinSessionManager?.clearSession();

    final params = LoginOauthAccessTokenRequest(provider: provider, accessToken: accessToken, sign: sign);

    final res = await _wepinNetwork!.loginOAuthAccessToken(params);

    return await _doFirebaseLoginWithCustomToken(res.token!, 'external_token');
  }

  Future<LoginResult> getRefreshFirebaseToken() async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }
    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    final sessionExists = await _wepinSessionManager!.checkExistFirebaseLoginSession();

    if (sessionExists) {

      final token = await _wepinSessionManager?.getFirebaseSessionStorage();

      return LoginResult(
        provider: token!.provider,
        token: WepinFBToken(
          idToken: token.idToken,
          refreshToken: token.refreshToken,
        ),
      );
    } else {
      throw WepinError(WepinErrorCode.invalidLoginSession);
    }
  }


  Future<LoginResult?> loginFirebaseWithOauthProvider({required String provider, required String clientId}) async {
    final oauthRes = await loginWithOauthProvider(
        provider: provider, clientId: clientId);
    if(oauthRes == null) {
      throw WepinError(WepinErrorCode.failedLogin, 'failed oauth login');
    }
    await _wepinSessionManager?.clearSession();
    final res;
    if(oauthRes.type == WepinOauthTokenType.idToken) {
      final params = LoginOauthIdTokenRequest(idToken: oauthRes.token);

      res = await _wepinNetwork!.loginOAuthIdToken(params);
    }else {
      final params = LoginOauthAccessTokenRequest(provider: provider, accessToken: oauthRes.token);

      res = await _wepinNetwork!.loginOAuthAccessToken(params);
    }
    return await _doFirebaseLoginWithCustomToken(res.token!, provider);
  }

  Future<WepinUser?> loginWepinWithOauthProvider({required String provider, required String clientId}) async {
    final firebaseRes = await loginFirebaseWithOauthProvider(provider: provider, clientId: clientId);
    if(firebaseRes == null ){
      throw WepinError(WepinErrorCode.failedLogin, 'failed oauth firebase login');
    }
    return await loginWepin(firebaseRes);
  }

  Future<WepinUser?> loginWepinWithIdToken({required String idToken, String? sign}) async {
    final firebaseRes = await loginWithIdToken(idToken: idToken, sign: sign);
    return await loginWepin(firebaseRes);
  }

  Future<WepinUser?> loginWepinWithAccessToken({required String provider, required String accessToken, String? sign}) async {
    final firebaseRes = await loginWithAccessToken(provider: provider, accessToken: accessToken, sign: sign);
    return await loginWepin(firebaseRes);
  }

  Future<WepinUser?> loginWepinWithEmailAndPassword({required String email, required String password}) async {
    final firebaseRes = await loginWithEmailAndPassword(email: email, password: password);
    return await loginWepin(firebaseRes);
  }

  Future<WepinUser?> loginWepin(LoginResult params) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if (params.token.idToken.isEmpty || params.token.refreshToken.isEmpty) {
      throw WepinError(WepinErrorCode.invalidParameters,
          'idToken and refreshToken are required');
    }

    if(_wepinNetwork == null || _wepinFirebaseNetwork == null) {
      throw WepinError(WepinErrorCode.notInitializedNetwork);
    }

    final response = await _wepinNetwork!.login(params.token.idToken);
    await _wepinSessionManager?.setLoginUserStorage(params, response);

    return await _wepinSessionManager?.getLoginUserStorage();
  }

  Future<WepinUser?> getCurrentWepinUser() async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if (_wepinSessionManager == null || !await _wepinSessionManager!.checkExistWepinLoginSession()) {
      throw WepinError(WepinErrorCode.invalidLoginSession);
    }

    return await _wepinSessionManager?.getLoginUserStorage();
  }

  Future<bool> logoutWepin() async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }

    if (_wepinSessionManager == null || !await _wepinSessionManager!.checkExistWepinLoginSession()) {
      throw WepinError(WepinErrorCode.alreadyLogout);
    }

    await _wepinSessionManager?.clearSession();
    return true;
  }

  String getSignForLogin({required String privateKey, required String message}) {
    var ec = getSecp256k1();
    var pk = PrivateKey.fromHex(ec, privateKey);

    // Calculate the hash of the message
    var tokenBytes = utf8.encode(message); // Convert the message to bytes
    var tokenHashBytes =
        sha256.convert(tokenBytes).bytes; // Calculate SHA-256 hash
    var tokenHashHex = hex.encode(tokenHashBytes); // Convert hash to hex string
    var hash = List<int>.generate(tokenHashHex.length ~/ 2,
            (i) => int.parse(tokenHashHex.substring(i * 2, i * 2 + 2), radix: 16));
    // var sig = signature(pk, hash);
    var sig = deterministicSign(pk, hash); //rfc6979

    return sig.toCompactHex();
  }
}
