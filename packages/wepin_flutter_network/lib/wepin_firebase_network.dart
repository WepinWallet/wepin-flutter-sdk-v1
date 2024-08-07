import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wepin_flutter_common/wepin_error.dart';
import 'package:wepin_flutter_network/wepin_firebase_network_types.dart';

class WepinFirebaseNetwork {
  final firebaseUrl = 'https://identitytoolkit.googleapis.com/v1';
  final String _firebaseKey;

  WepinFirebaseNetwork({required String firebaseKey})
  : _firebaseKey = firebaseKey;

  Future<SignInWithCustomTokenSuccess> signInWithCustomToken(String customToken) async {
    final url = Uri.parse('$firebaseUrl/accounts:signInWithCustomToken?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode({
      'token': customToken,
      'returnSecureToken': true,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return SignInWithCustomTokenSuccess.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<SignInResponse> signInWithEmailPassword(EmailAndPasswordRequest signInRequest) async {
    final url = Uri.parse('$firebaseUrl/accounts:signInWithPassword?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode(signInRequest.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return SignInResponse.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetCurrentUserResponse> getCurrentUser(GetCurrentUserRequest getCurrentUserRequest) async {
    final url = Uri.parse('$firebaseUrl/accounts:lookup?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode(getCurrentUserRequest.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return GetCurrentUserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<GetRefreshIdTokenSuccess> getRefreshIdToken(GetRefreshIdTokenRequest getRefreshIdTokenRequest) async {
    final url = Uri.parse('$firebaseUrl/token?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode(getRefreshIdTokenRequest.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return GetRefreshIdTokenSuccess.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest resetPasswordRequest) async {
    final url = Uri.parse('$firebaseUrl/accounts:resetPassword?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode(resetPasswordRequest.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ResetPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.failedPasswordSetting, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<VerifyEmailResponse> verifyEmail(VerifyEmailRequest verifyEmailRequest) async {
    final url = Uri.parse('$firebaseUrl/accounts:update?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode(verifyEmailRequest.toJson());
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return VerifyEmailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.failedEmailVerified, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<UpdatePasswordSuccess> updatePassword(String idToken, String password) async {
    final url = Uri.parse('$firebaseUrl/accounts:update?key=$_firebaseKey');
    final jsonRequestBody = jsonEncode({
      'idToken': idToken,
      'password': password,
      'returnSecureToken': true,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return UpdatePasswordSuccess.fromJson(jsonDecode(response.body));
    } else {
      throw WepinError(WepinErrorCode.failedPasswordSetting, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }




}