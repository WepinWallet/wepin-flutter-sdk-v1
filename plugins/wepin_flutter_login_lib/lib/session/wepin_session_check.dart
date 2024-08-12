import 'package:wepin_flutter_login_lib/type/wepin_flutter_login_lib_type.dart';
import 'package:wepin_flutter_network/wepin_network.dart';
import 'package:wepin_flutter_network/wepin_firebase_network.dart';
import 'package:wepin_flutter_network/wepin_network_types.dart';
import 'package:wepin_flutter_network/session/wepin_session_check.dart';
import 'package:wepin_flutter_storage/wepin_flutter_storage.dart';

class WepinLoginSessionManager extends WepinSessionManager {

  WepinLoginSessionManager({required appId, required WepinNetwork wepinNetwork, required WepinFirebaseNetwork wepinFirebaseNetwork})
  :super(appId: appId, wepinNetwork: wepinNetwork, wepinFirebaseNetwork: wepinFirebaseNetwork);


  Future<void> setFirebaseSessionStorage(WepinFBToken token, String provider) async {
    await wepinStorage.setLocalStorage<IFirebaseWepin>(StorageDataType.firebaseWepin, IFirebaseWepin(
        idToken: token.idToken,
        refreshToken: token.refreshToken,
        provider: provider
    ));
  }

  Future<void> setLoginUserStorage(LoginResult request, LoginResponse response) async {
    await wepinStorage.clearAllLocalStorageWithAppId();
    await wepinStorage.setLocalStorage<IFirebaseWepin>(
      StorageDataType.firebaseWepin,
        IFirebaseWepin(
        idToken: request.token.idToken,
        refreshToken: request.token.refreshToken,
        provider: request.provider,
      ),
    );
    await wepinStorage.setLocalStorage<WepinToken>(
      StorageDataType.wepinConnectUser,
        response.token
    );

    await wepinStorage.setLocalStorage<String>(StorageDataType.userId, response.userInfo.userId);

    await wepinStorage.setLocalStorage<WepinUserStatus>(
      StorageDataType.userStatus,
        WepinUserStatus(
          loginStatus: response.loginStatus,
          pinRequired: response.loginStatus == 'registerRequired'
          ? response.pinRequired
              : false,
        ),
    );

    if (response.loginStatus != 'pinRequired' && response.walletId != null) {
      await wepinStorage.setLocalStorage<String>(StorageDataType.walletId, response.walletId!);
      await wepinStorage.setLocalStorage<WepinUser>(
        StorageDataType.userInfo,
        WepinUser(
          status: 'success',
          userInfo: WepinUserInfo(
            userId: response.userInfo.userId,
            email: response.userInfo.email,
            provider: request.provider,
            use2FA: response.userInfo.use2FA >= 2,
          ),
          walletId: response.walletId,
        ),
      );
    } else {
      await wepinStorage.setLocalStorage<WepinUser>(
        StorageDataType.userInfo,
        WepinUser(
          status: 'success',
          userInfo: WepinUserInfo(
          userId: response.userInfo.userId,
          email: response.userInfo.email,
          provider: request.provider,
          use2FA: response.userInfo.use2FA >= 2,
        ),
      ),
      );
    }

    await wepinStorage.setLocalStorage<String>(StorageDataType.oauthProviderPending, request.provider);
  }
}