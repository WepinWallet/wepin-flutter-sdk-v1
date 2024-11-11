export 'package:wepin_flutter_login_lib/type/wepin_flutter_login_lib_type.dart';
export 'package:wepin_flutter_common/wepin_common_type.dart';
export 'package:wepin_flutter_common/wepin_error.dart';

class EncUVD {
  final int? seqNum;
  final String b64SKey;
  final String b64Data;

  EncUVD({this.seqNum, required this.b64SKey, required this.b64Data});

  /// fromJson 메서드
  factory EncUVD.fromJson(Map<String, dynamic> json) {
    return EncUVD(
      seqNum: json['seqNum'],
      b64SKey: json['b64SKey'],
      b64Data: json['b64Data'],
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'seqNum': seqNum,
      'b64SKey': b64SKey,
      'b64Data': b64Data,
    };
  }

  @override
  String toString() {
    return 'EncUVD(seqNum: $seqNum, b64SKey: $b64SKey, b64Data: $b64Data)';
  }
}

class EncPinHint {
  final int version;
  final String length;
  final String data;

  EncPinHint({required this.version, required this.length, required this.data});

  /// fromJson 메서드
  factory EncPinHint.fromJson(Map<String, dynamic> json) {
    return EncPinHint(
      version: json['version'],
      length: json['length'],
      data: json['data'],
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'length': length,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'EncPinHint(version: $version, length: $length, data: $data)';
  }
}

class ChangePinBlock {
  final EncUVD uvd;
  final EncUVD newUVD;
  final EncPinHint hint;
  final String? otp;

  ChangePinBlock({required this.uvd, required this.newUVD, required this.hint, this.otp});

  /// fromJson 메서드
  factory ChangePinBlock.fromJson(Map<String, dynamic> json) {
    return ChangePinBlock(
      uvd: EncUVD.fromJson(json['UVD']),
      newUVD: EncUVD.fromJson(json['newUVD']),
      hint: EncPinHint.fromJson(json['hint']),
      otp: json['otp'],
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'UVD': uvd.toJson(),
      'newUVD': newUVD.toJson(),
      'hint': hint.toJson(),
      'otp': otp,
    };
  }

  @override
  String toString() {
    return 'ChangePinBlock(uvd: $uvd, newUVD: $newUVD, hint: $hint, otp: $otp)';
  }
}

class RegistrationPinBlock {
  final EncUVD uvd;
  final EncPinHint hint;

  RegistrationPinBlock({required this.uvd, required this.hint});

  /// fromJson 메서드
  factory RegistrationPinBlock.fromJson(Map<String, dynamic> json) {
    return RegistrationPinBlock(
      uvd: EncUVD.fromJson(json['UVD']),
      hint: EncPinHint.fromJson(json['hint']),
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'UVD': uvd.toJson(),
      'hint': hint.toJson(),
    };
  }

  @override
  String toString() {
    return 'RegistrationPinBlock(uvd: $uvd, hint: $hint)';
  }
}

class AuthOTP {
  final String code;

  AuthOTP({required this.code});

  /// fromJson 메서드
  factory AuthOTP.fromJson(Map<String, dynamic> json) {
    return AuthOTP(
      code: json['code'],
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }

  @override
  String toString() {
    return 'AuthOTP(code: $code)';
  }
}

class AuthPinBlock {
  /// 암호화된 PIN 목록
  final List<EncUVD> uvdList;

  /// OTP 인증이 필요한 경우 포함될 OTP
  final String? otp;

  AuthPinBlock({
    required this.uvdList,
    this.otp,
  });

  /// fromJson 메서드
  factory AuthPinBlock.fromJson(Map<String, dynamic> json) {
    return AuthPinBlock(
      uvdList: (json['UVDs'] as List<dynamic>)
          .map((item) => EncUVD.fromJson(item))
          .toList(),
      otp: json['otp'],
    );
  }

  /// toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'UVDs': uvdList.map((item) => item.toJson()).toList(),
      'otp': otp,
    };
  }

  @override
  String toString() {
    return 'AuthPinBlock(uvdList: $uvdList, otp: $otp)';
  }
}

