library wepin_flutter_storage;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wepin_flutter_common/wepin_common_type.dart';

class WepinStorage {
  final String appId;
  static const _prefix = 'wepin_store_';
  static const _storage = FlutterSecureStorage();

  WepinStorage({required this.appId});

  String _getPrefixedKey(String key) {
    return '$_prefix${appId}_$key';
  }

  T? _parseJsonValue<T>(dynamic jsonValue) {
    if (T == String) {
      return jsonValue as T;
    } else if (T == int) {
      return int.tryParse(jsonValue.toString()) as T?;
    } else if (T == double) {
      return double.tryParse(jsonValue.toString()) as T?;
    } else if (T == bool) {
      return (jsonValue.toString() == 'true') as T?;
    } else if (T == IFirebaseWepin) {
      return IFirebaseWepin.fromJson(Map<String, dynamic>.from(jsonValue)) as T;
    } else if (T == IAppLanguage) {
      return IAppLanguage.fromJson(Map<String, dynamic>.from(jsonValue)) as T;
    }else if (T == WepinToken) {
      return WepinToken.fromJson(Map<String, dynamic>.from(jsonValue)) as T;
    } else if (T == WepinUser) {
      return WepinUser.fromJson(Map<String, dynamic>.from(jsonValue)) as T;
    } else if (T == WepinUserStatus) {
      return WepinUserStatus.fromJson(Map<String, dynamic>.from(jsonValue)) as T;
    } else {
      throw ArgumentError('Unsupported data type');
    }
  }

  String _encodeValue<T>(T value) {
    if (value is String || value is int || value is double || value is bool) {
      return value.toString();
    } else if (value is IFirebaseWepin) {
      return jsonEncode((value).toJson());
    } else if (value is IAppLanguage) {
      return jsonEncode((value).toJson());
    } else if (value is WepinToken) {
      return jsonEncode((value).toJson());
    } else if (value is WepinUser) {
      return jsonEncode((value).toJson());
    } else if (value is WepinUserStatus) {
      return jsonEncode((value).toJson());
    } else {
      return jsonEncode(value);
    }
  }

  Future<T?> getLocalStorage<T>(String key) async {
    final appSpecificKey = _getPrefixedKey(key);
    final value = await _storage.read(key: appSpecificKey);
    if (value == null) return null;
    // print('getLocalStorage key - $key');
    // print('getLocalStorage value - $value');
    try {
      final jsonValue = jsonDecode(value);
      return _parseJsonValue<T>(jsonValue);
    } catch (e) {
      // print('getLocalStorage json decode error');
      return value as T;
    }
  }

  Future<void> setLocalStorage<T>(String key, T value) async {
    final appSpecificKey = _getPrefixedKey(key);
    final stringValue = _encodeValue<T>(value);
    // print('setLocalStorage key - $key');
    // print('setLocalStorage value - $value');
    await _storage.write(key: appSpecificKey, value: stringValue);
  }

  Future<Map<String, dynamic>?> getAllLocalStorage() async {
    final allData = await _storage.readAll();
    final Map<String, dynamic> filteredData = {};

    for (var key in allData.keys) {
      if (key.startsWith('$_prefix${appId}_')) {
        final storageKey = key.replaceFirst('wepin_store_${appId}_', '');
        // filteredData[storageKey] = allData[key];
        try {
          final jsonValue = jsonDecode(allData[key]!);
          filteredData[storageKey] = jsonValue;
        } catch (e) {
          filteredData[storageKey] = allData[key]!;
        }
      }
    }

    return filteredData.isEmpty ? null : filteredData;
  }

  Future<void> clearAllLocalStorage(bool clear) async {
    if (clear) {
      final allData = await _storage.readAll();
      for (var key in allData.keys) {
        if (key.startsWith('$_prefix${appId}_')) {
          await _storage.delete(key: key);
        }
      }
    }
  }

  Future<void> setAllLocalStorage(Map<String, dynamic> data) async {
    for (var entry in data.entries) {
      await setLocalStorage(entry.key, entry.value);
    }
  }

  Future<void> clearAllLocalStorageWithAppId() async {
    final allData = await _storage.readAll();
    for (var key in allData.keys) {
      if (key.startsWith('wepin_store_${appId}_')) {
        await _storage.delete(key: key);
      }
    }
  }

  Future<void> clearAllWepinStoreLocalStorage() async {
    final allData = await _storage.readAll();
    for (var key in allData.keys) {
      if (key.startsWith('wepin_store_')) {
        await _storage.delete(key: key);
      }
    }
  }
}


class StorageDataType {
  static const String firebaseWepin = 'firebase:wepin';
  static const String wepinConnectUser = 'wepin:connectUser';
  static const String userId = 'user_id';
  static const String userStatus = 'user_status';
  static const String walletId = 'wallet_id';
  static const String userInfo = 'user_info';
  static const String oauthProviderPending = 'oauth_provider_pending';
}

class IFirebaseWepin {
  final String provider;
  final String idToken;
  final String refreshToken;

  IFirebaseWepin({required this.provider, required this.idToken, required this.refreshToken});

  factory IFirebaseWepin.fromJson(Map<String, dynamic> json) {
    return IFirebaseWepin(
      provider: json['provider'],
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'idToken': idToken,
    'refreshToken': refreshToken,
  };
}

class IAppLanguage {
  final String locale;
  final String currency;

  IAppLanguage({required this.locale, required this.currency});

  factory IAppLanguage.fromJson(Map<String, dynamic> json) {
    return IAppLanguage(
      locale: json['locale'],
      currency: json['currency']
    );
  }
  Map<String, dynamic> toJson() => {
    'locale' : locale,
    'currency': currency
  };
}
