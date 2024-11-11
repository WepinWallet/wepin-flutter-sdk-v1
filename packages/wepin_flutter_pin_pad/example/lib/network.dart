import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad_types.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:wepin_flutter_common/wepin_flutter_common.dart';

class RegisterRequest {
  final String appId;
  final String userId;
  final String loginStatus;
  final String? walletId;
  final EncUVD? UVD;
  final EncPinHint? hint;

  RegisterRequest({
    required this.appId,
    required this.userId,
    required this.loginStatus,
    this.walletId,
    this.UVD,
    this.hint
  });

  Map<String, dynamic> toJson() => {
    'appId': appId,
    'userId': userId,
    'loginStatus': loginStatus,
    'walletId': walletId,
    'UVD': UVD?.toJson(),
    'hint': hint?.toJson()
  };
}

class RegisterResponse {
  final bool success;
  final String walletId;

  RegisterResponse({required this.success, required this.walletId});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      walletId: json['walletId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'walletId': walletId,
  };

  @override
  String toString() {
    return 'RegisterResponse(success: $success, walletId: $walletId)';
  }
}

class OtpCode {
  final String code;
  final bool recovery;
  OtpCode({
    required this.code,
    required this.recovery
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'recovery': recovery,
  };
}

class ChangePinRequest {
  final String userId;
  final String walletId;
  final EncUVD UVD;
  final EncUVD newUVD;
  final EncPinHint hint;
  final OtpCode? otpCode;

  ChangePinRequest({
    required this.userId,
    required this.walletId,
    required this.UVD,
    required this.newUVD,
    required this.hint,
    this.otpCode,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'walletId': walletId,
    'UVD': UVD?.toJson(),
    'newUVD': newUVD?.toJson(),
    'hint': hint?.toJson(),
    'otpCode': otpCode?.toJson(),
  };
}

class ChangePinResponse {
  final bool status;

  ChangePinResponse({required this.status});

  factory ChangePinResponse.fromJson(Map<String, dynamic> json) {
    return ChangePinResponse(
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
  };

  @override
  String toString() {
    return 'ChangePinResponse(status: $status)';
  }
}


class SignRequest {
  final String type;
  final String userId;
  final String walletId;
  final String accountId;
  final String? contract;
  final String? tokenId;
  final String? isNft;
  final EncUVD pin;
  final OtpCode? otpCode;

  final Map<String, dynamic> txData;

  SignRequest({
    required this.type,
    required this.userId,
    required this.accountId,
    required this.walletId,
    required this.pin,
    required this.txData,
    this.contract,
    this.tokenId,
    this.isNft,
    this.otpCode,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'userId': userId,
    'accountId': accountId,
    'walletId': walletId,
    'pin': pin.toJson(),
    'txData': txData,
    'contract': contract,
    'tokenId': tokenId,
    'isNft': isNft,
    'hint': otpCode?.toJson()
  };
}



class SignResponse {
  final dynamic signatureResult;
  final Map<String, dynamic> transaction;
  final String? broadcastData;
  final String? txId;

  SignResponse({required this.signatureResult, required this.transaction, this.broadcastData, this.txId});

  factory SignResponse.fromJson(Map<String, dynamic> json) {
    return SignResponse(
      signatureResult: json['signatureResult'],
      transaction: json['transaction'],
      broadcastData: json['broadcastData'],
      txId: json['txId']
    );
  }

  Map<String, dynamic> toJson() => {
    'signatureResult': signatureResult,
    'transaction': transaction,
    'broadcastData': broadcastData,
    'txId': txId
  };

  @override
  String toString() {
    return 'SignResponse(signatureResult: $signatureResult, transaction: $transaction, broadcastData: $broadcastData, txId: $txId)';
  }

}

class GetAccountListRequest {
  final String walletId;
  final String userId;
  final String localeId;

  GetAccountListRequest({
    required this.walletId,
    required this.userId,
    required this.localeId,
  });

  Map<String, dynamic> toJson() => {
    'walletId': walletId,
    'userId': userId,
    'localeId': localeId,
  };
}

class IAppAccount {
  final String accountId;
  final String address;
  final String? eoaAddress;
  final String addressPath;
  final int? coinId;
  final String? contract;
  final String symbol;
  final String label;
  final String name;
  final String network;
  final String balance;
  final int decimals;
  final String? iconUrl;
  final String? ids;
  final String? accountTokenId;
  final int? cmkId;
  final bool? isAA;

  IAppAccount({
    required this.accountId,
    required this.address,
    this.eoaAddress,
    required this.addressPath,
    this.coinId,
    this.contract,
    required this.symbol,
    required this.label,
    required this.name,
    required this.network,
    required this.balance,
    required this.decimals,
    this.iconUrl,
    this.ids,
    this.accountTokenId,
    this.cmkId,
    this.isAA
  });

  factory IAppAccount.fromJson(Map<String, dynamic> json) {
    return IAppAccount(
      accountId: json['accountId'],
      address: json['address'],
      eoaAddress: json['eoaAddress'],
      addressPath: json['addressPath'],
      coinId: json['coinId'],
      contract: json['contract'],
      symbol: json['symbol'],
      label: json['label'],
      name: json['name'],
      network: json['network'],
      balance: json['balance'],
      decimals: json['decimals'],
      iconUrl: json['iconUrl'],
      ids: json['ids'],
      accountTokenId: json['accountTokenId'],
      cmkId: json['cmkId'],
      isAA: json['isAA'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accountId': accountId,
    'address': address,
    'eoaAddress': eoaAddress,
    'addressPath': addressPath,
    'coinId': coinId,
    'contract': contract,
    'symbol': symbol,
    'label': label,
    'name': name,
    'network': network,
    'balance': balance,
    'decimals': decimals,
    'iconUrl': iconUrl,
    'ids': ids,
    'accountTokenId': accountTokenId,
    'cmkId': cmkId,
    'isAA': isAA,
  };
}

class GetAccountListResponse {
  final String walletId;
  final List<IAppAccount> accounts;
  final List<IAppAccount>? aa_accounts;

  GetAccountListResponse({
    required this.walletId,
    required this.accounts,
    this.aa_accounts,
  });

  factory GetAccountListResponse.fromJson(Map<String, dynamic> json) {
    return GetAccountListResponse(
      walletId: json['walletId'],
      accounts: (json['accounts'] as List)
          .map((item) => IAppAccount.fromJson(item))
          .toList(),
      aa_accounts: json['aa_accounts'] != null
          ? (json['aa_accounts'] as List)
          .map((item) => IAppAccount.fromJson(item))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'walletId': walletId,
    'accounts': accounts.map((account) => account.toJson()).toList(),
    'aa_accounts': aa_accounts?.map((account) => account.toJson()).toList(),
  };
}

class NetworkManager {
  final String _wepinBaseUrl;
  final String appKey;
  Map<String, String> headers = <String, String>{};
  String? _accessToken;
  String? _refreshToken;

  NetworkManager({required this.appKey}):
      _wepinBaseUrl = getUrl(appKey)!
      {
        _setHeader();
      }

  static String? getUrl(String key){
    if(key.startsWith('ak_dev')){
      return 'https://dev-sdk.wepin.io/v1/';
    }else if(key.startsWith('ak_test')){
      return 'https://stage-sdk.wepin.io/v1/';
    }else if(key.startsWith('ak_live')){
      return 'https://sdk.wepin.io/v1/';
    }
  }

  static Future<String> getPackageName() async {
    final info = await WepinCommon.getPackageName();
    return info!;
  }

  void _setHeader() async {
    headers["Content-Type"] = 'application/json';
    headers["X-API-KEY"] = appKey;
    headers["X-API-DOMAIN"] = await getPackageName();
    headers["X-SDK-TYPE"] = 'flutter-rest_api';
    headers["X-SDK-VERSION"] = '0.0.1';
  }

  void setAuthToken(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    headers['Authorization'] = 'Bearer $_accessToken';
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

  Future<ChangePinResponse> changePin(ChangePinRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}wallet/pin/change');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.patch(
      url,
      headers: headers,
      body: jsonRequestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return ChangePinResponse.fromJson(responseBody);
    } else {
      throw WepinError(WepinErrorCode.apiRequestError, 'code: ${response.statusCode} , body: ${response.body}');
    }
  }

  Future<SignResponse> sign(SignRequest params) async {
    final url = Uri.parse('${_wepinBaseUrl}tx/sign');
    final jsonRequestBody = jsonEncode(params.toJson());
    final response = await http.post(
      url,
      headers: headers,
      body: jsonRequestBody,
    );


    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = jsonDecode(response.body);
      return SignResponse.fromJson(responseBody);
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
}