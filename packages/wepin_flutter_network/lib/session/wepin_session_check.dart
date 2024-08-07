import 'dart:convert';
import 'package:wepin_flutter_common/wepin_common_type.dart';
import 'package:wepin_flutter_network/wepin_firebase_network_types.dart';
import 'package:wepin_flutter_network/wepin_network.dart';
import 'package:wepin_flutter_network/wepin_firebase_network.dart';
import 'package:wepin_flutter_storage/wepin_flutter_storage.dart';

class WepinSessionManager {
  final String appId;
  final WepinNetwork wepinNetwork;
  final WepinFirebaseNetwork wepinFirebaseNetwork;
  final WepinStorage wepinStorage;

  WepinSessionManager({required this.appId, required this.wepinNetwork, required this.wepinFirebaseNetwork})
   :wepinStorage = WepinStorage(appId: appId);


  Future<void> clearSession() async {
    wepinNetwork.clearAuthToken();
    await wepinStorage.clearAllLocalStorageWithAppId();
  }
  Future<bool> checkExistFirebaseLoginSession() async {
    final token = await wepinStorage.getLocalStorage<IFirebaseWepin>(StorageDataType.firebaseWepin);
    if (token != null) {
      try {
        final response = await wepinFirebaseNetwork.getRefreshIdToken(GetRefreshIdTokenRequest(refreshToken: token.refreshToken));

        final newToken = IFirebaseWepin(
          provider: token.provider,
          idToken: response.idToken,
          refreshToken: token.refreshToken,
        );
        await wepinStorage.setLocalStorage<IFirebaseWepin>('firebase:wepin', newToken);

        return true;
      } catch (error) {
        await clearSession();
        return false;
      }
    } else {
      await clearSession();
      return false;
    }
  }

  bool _isJwtTokenExpired(String token) {
    try {
      // JWT의 페이로드 부분을 디코딩하여 만료 시간(claim 'exp')을 가져옵니다.
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token');
      }

      final payload = parts[1];
      final decodedPayload = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final payloadMap = json.decode(decodedPayload) as Map<String, dynamic>;

      // 만료 시간(claim 'exp')을 확인하고 현재 시간과 비교합니다.
      final exp = payloadMap['exp'];
      if (exp == null) {
        throw Exception('JWT token does not contain an "exp" claim');
      }

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      const bufferTime = Duration(minutes: 1); // 1분의 여유 시간을 둠

      return expiryDate.isBefore(DateTime.now().add(bufferTime));
    } catch (e) {
      // 예외 발생 시 만료된 것으로 간주합니다.

      // print('Error decoding JWT token: $e');
      return true;
    }
  }

  Future<bool> checkExistWepinLoginSession() async {
    final token = await wepinStorage.getLocalStorage<WepinToken>('wepin:connectUser');
    final userId = await wepinStorage.getLocalStorage<String>('user_id');

    if (token != null && userId != null) {
      wepinNetwork.setAuthToken(token.accessToken, token.refreshToken);

      if(_isJwtTokenExpired(token.accessToken)){
        try {
          final response = await wepinNetwork.getAccessToken(userId);

          final newToken = WepinToken(
            accessToken: response,
            refreshToken: token.refreshToken,
          );
          await wepinStorage.setLocalStorage('wepin:connectUser', newToken);

          wepinNetwork.setAuthToken(newToken.accessToken, newToken.refreshToken);
          return true;
        } catch (error) {
          // print('error - $error');
          await clearSession();
          return false;
        }
      }else {
        return true;
      }
    } else {
      await clearSession();
      return false;
    }
  }

  Future<IFirebaseWepin?> getFirebaseSessionStorage() async {
    return await wepinStorage.getLocalStorage<IFirebaseWepin>(StorageDataType.firebaseWepin);
  }

  Future<WepinUser?> getLoginUserStorage() async {
    final data = await wepinStorage.getAllLocalStorage();
    if (data == null) {
      return null;
    }
    final walletId = await wepinStorage.getLocalStorage<String>(StorageDataType.walletId);
    final userInfo = await wepinStorage.getLocalStorage<WepinUser>(StorageDataType.userInfo);
    final token = await wepinStorage.getLocalStorage<WepinToken>(StorageDataType.wepinConnectUser);
    final userStatus = await wepinStorage.getLocalStorage<WepinUserStatus>(StorageDataType.userStatus);

    if (userInfo == null || token == null || userStatus == null) {
      return null;
    }

    return WepinUser(
      status: userInfo.status,
      userInfo: userInfo.userInfo,
      walletId: walletId,
      userStatus: userStatus,
      token: token,
    );
  }


}