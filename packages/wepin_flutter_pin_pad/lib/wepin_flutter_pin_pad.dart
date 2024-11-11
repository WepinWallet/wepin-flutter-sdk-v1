library wepin_flutter_pin_pad;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wepin_flutter_common/webview/js_request.dart';
import 'package:wepin_flutter_common/webview/js_response.dart';
import 'package:wepin_flutter_common/wepin_flutter_common.dart';
import 'package:wepin_flutter_common/wepin_url.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:wepin_flutter_modal/wepin_flutter_modal.dart';
import 'package:wepin_flutter_network/session/wepin_session_check.dart';
import 'package:wepin_flutter_network/wepin_firebase_network.dart';
import 'package:wepin_flutter_network/wepin_network.dart';
import 'package:wepin_flutter_pin_pad/src/version.dart';
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad_types.dart';

/// A WepinPinPad.
class WepinPinPad {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  bool _isInitialized = false;
  final String _wepinAppKey;
  final String wepinAppId;
  String? domain;
  String? version;
  String defaultLanguage = 'en';
  String defaultCurrency = 'USD';
  WepinNetwork? _wepinNetwork;
  WepinFirebaseNetwork? _wepinFirebaseNetwork;
  WepinSessionManager? _wepinSessionManager;
  final WepinModal? _wepinModal;
  String? _widgetUrl;
  Map<String, dynamic>? _currentWepinRequest;

  WepinLogin login;

  WepinPinPad({required String wepinAppKey, required this.wepinAppId})
      : _wepinAppKey = wepinAppKey,
        _wepinModal = WepinModal(),
        login = WepinLogin(wepinAppKey: wepinAppKey, wepinAppId: wepinAppId);

  Future<void> init({String? language, String? currency}) async {
    if(_isInitialized) {
      throw WepinError(WepinErrorCode.alreadyInitialized);
    }
    if (language != null) {
      defaultLanguage = language;
    }
    if (currency != null ) {
      defaultCurrency = currency;
    }
    try {
      _isInitialized = false;
      domain = await WepinCommon.getPackageName();
      version = packageVersion;
      _wepinNetwork = WepinNetwork(wepinAppKey: _wepinAppKey, domain: domain!, version: version!, type: 'flutter_pin');
      await _wepinNetwork?.getAppInfo();
      final firebaseKey = await _wepinNetwork?.getFirebaseConfig();
      if(firebaseKey != null){
        _wepinFirebaseNetwork = WepinFirebaseNetwork(firebaseKey: firebaseKey);
        _wepinSessionManager = WepinSessionManager(appId: wepinAppId, wepinNetwork: _wepinNetwork!, wepinFirebaseNetwork: _wepinFirebaseNetwork!);
        await login.init();
        _widgetUrl = getWepinSdkUrl(_wepinAppKey)['wepinWebview'];
        await _checkLoginStatus();
        _initWebViewCallback();
        _isInitialized = true;
      }
    }catch(e){
      if(e is WepinError) {
        rethrow;
      }
      throw WepinError(WepinErrorCode.unknownError, e.toString());
    }
  }

  Future<bool> _checkLoginStatus() async {
    bool? isExistLoginStatus = await _wepinSessionManager?.checkExistWepinLoginSession();
    if(isExistLoginStatus != null && isExistLoginStatus) {
      return true;
    } else {
      return false;
    }
  }

  bool isInitialized() {
    return _isInitialized;
  }

  void changeLanguage({language, currency}){
    if (language != null) {
      defaultLanguage = language;
    }
    if (currency != null ) {
      defaultCurrency = currency;
    }
  }

  Future<void> finalize() async {
    await _wepinSessionManager?.clearSession();
    await login.finalize();
    _isInitialized = false;
    _responseEvent.clear();
    _requestEvent.clear();
  }

  Future<dynamic> _openAndRequestWepinWidget({required BuildContext context, required String command, dynamic parameter}) async {
    final completer = Completer<dynamic>();
    final id = DateTime.now().millisecondsSinceEpoch;
    _currentWepinRequest = {
      'header': {
        'request_from': 'flutter',
        'request_to': 'wepin_widget',
        'id': id,
      },
      'body': {
        'command': command,
        'parameter': parameter,
      },
    };

    _responseEvent[id] = (JSResponse response) async {
      _wepinModal?.closeModal();
      await _checkLoginStatus();
      _currentWepinRequest = null;
      _responseEvent.remove(id);
      if (response.body.state == 'SUCCESS') {
        completer.complete(response.body.data);
      } else {
        completer.completeError(
            WepinError(WepinErrorCode.unknownError, '${response.body.data}'));
      }
      return;
    };
    if (context.mounted) {
      await _open(context: context);
    }else {
      completer.completeError(WepinError(WepinErrorCode.invalidContext));
    }
    return completer.future;
  }

  Future<RegistrationPinBlock> generateRegistrationPINBlock(BuildContext context) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }
    if (!await _checkLoginStatus()) {
      throw WepinError(WepinErrorCode.invalidLoginSession, 'login required');
    }
    if (context.mounted) {
      final res =  await _openAndRequestWepinWidget(
          context: context, command: 'pin_register', parameter: {});
      return RegistrationPinBlock.fromJson(res);
    }else {
      throw WepinError(WepinErrorCode.invalidContext);
    }
  }

  Future<AuthPinBlock> generateAuthPINBlock(BuildContext context, int? count) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }
    if (!await _checkLoginStatus()) {
      throw WepinError(WepinErrorCode.invalidLoginSession, 'login required');
    }
    if (context.mounted) {
      final res = await _openAndRequestWepinWidget(
          context: context, command: 'pin_auth', parameter: {'count': count?? 1});
      return AuthPinBlock.fromJson(res);
    }else {
      throw WepinError(WepinErrorCode.invalidContext);
    }
  }

  Future<ChangePinBlock> generateChangePINBlock(BuildContext context) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }
    if (!await _checkLoginStatus()) {
      throw WepinError(WepinErrorCode.invalidLoginSession, 'login required');
    }
    if (context.mounted) {
      final res = await _openAndRequestWepinWidget(
          context: context, command: 'pin_change', parameter: {});
      return ChangePinBlock.fromJson(res);
    }else {
      throw WepinError(WepinErrorCode.invalidContext);
    }
  }

  Future<AuthOTP> generateAuthOTP(BuildContext context) async {
    if (!_isInitialized) {
      throw WepinError(WepinErrorCode.notInitialized);
    }
    if (!await _checkLoginStatus()) {
      throw WepinError(WepinErrorCode.invalidLoginSession, 'login required');
    }
    if (context.mounted) {
      final res = await _openAndRequestWepinWidget(
          context: context, command: 'pin_otp', parameter: {});
      return AuthOTP.fromJson(res);
    }else {
      throw WepinError(WepinErrorCode.invalidContext);
    }
  }


  Future<void> _open({required BuildContext context, String? url}) async {
    final loadUrl = _widgetUrl! + ((url != null && url.isNotEmpty) ? url : '');
    if (context.mounted) {
      _wepinModal?.openModal(context, loadUrl,_webviewCallback);
    } else {
      throw WepinError(WepinErrorCode.invalidContext);
    }
  }

  // 웹뷰 이벤트 핸들러 대체
  final Map<String, RequestHandlerFunction> _requestEvent = {};
  final Map<int, ResponseHandlerFunction> _responseEvent = {};
  void _initWebViewCallback() {
    _requestEvent['ready_to_widget'] =
        (JSRequest request, JSResponse response) async {
      final data = await _wepinSessionManager?.wepinStorage.getAllLocalStorage();

      ResponseReadyToWidget readyToWidgetData = ResponseReadyToWidget(
          _wepinAppKey,
          WidgetWebivewAttributes(defaultLanguage: defaultLanguage, defaultCurrency: defaultCurrency),
          domain!,
          Platform.isIOS? 3 : 2,
          version!,
          wepinAppId,
          'flutter-pin',
          data ?? {},
          WidgetPermission(camera: false, clipboard: false),
      );
      response.body.data = readyToWidgetData.toJson();
      return jsonEncode(response.toJson());
    };

    _requestEvent['close_wepin_widget'] =
        (JSRequest request, JSResponse response) async {
      await _wepinModal?.closeModal();
      return jsonEncode(response.toJson());
    };

    _requestEvent['set_local_storage'] =
        (JSRequest request, JSResponse response) async {
      final data = request.body.parameter['data'];
      await _wepinSessionManager?.wepinStorage.setAllLocalStorage(data);
      return jsonEncode(response.toJson());
    };

    _requestEvent['get_sdk_request'] =
        (JSRequest request, JSResponse response) async {
      response.body.data = _currentWepinRequest ?? 'No request';
      return jsonEncode(response.toJson());
    };

    _responseEvent.clear();
  }

  Future<String?> _webviewCallback(List<dynamic> message) async {
    String jsRequest;
    if (message.first is! String) {
      jsRequest = jsonEncode(message.first);
    } else {
      jsRequest = message.first;
    }
    Map<String, dynamic> jsonData = jsonDecode(jsRequest);
    JSRequest? request;
    JSResponse? jsResponse;
    ResponseHeader? responseHeader;
    ResponseBody? responseBody;
    String command = '';
    String response = '';

    if (jsonData['header'] != null &&
        jsonData['header']['request_to'] != null) {
      request = JSRequest.fromJson(jsonData);

      if (request.header.request_to != 'flutter') {
        return response;
      }

      command = request.body.command;
      responseHeader = ResponseHeader(
          id: request.header.id,
          reponse_from: request.header.request_to,
          response_to: request.header.request_from);
      responseBody = ResponseBody(
          command: request.body.command,
          state: 'SUCCESS',
          data: null); //Noti : General Success Response body

      if(_requestEvent.keys.contains(command)) {
        return await _requestEvent[command]!(request, JSResponse(header: responseHeader, body: responseBody));
      }

    } else {
      jsResponse = JSResponse.fromJson(jsonData);

      if (jsResponse.header.response_to != 'flutter') {
        return '';
      }
      final id = jsResponse.header.id;
      command = jsResponse.body.command;

      if(_responseEvent.keys.contains(id)) {
        return await _responseEvent[id]!(jsResponse);
      }
    }
    return null; // or return response if needed
  }
}
