## 0.0.6

### Bug Fixes
- Fixed `SFAuthenticationViewController` Deallocation Issue:
  - Resolved the error caused by premature deallocation of `SFAuthenticationViewController` during the authentication flow.


## 0.0.5

### Update
 - Changed the sign value to optional in the parameters of the external token login methods:
   - `loginWithIdToken`
   - `loginWithAccessToken` 
    > If you choose to remove the authentication key issued from the Wepin workspace, you may opt not to use the sign value.
    > (Workspace page > Development Tools menu > Login tab > Auth Key)
 - Updated `wepin_flutter_network` package to v0.0.5
 - Updated `wepin_flutter_common` package to v0.0.6
 - Updated `wepin_flutter_storage` package to v0.0.4

### New Feature
 - Added methods to perform Wepin login in a single step for convenience:
   - `loginWepinWithOauthProvider`
   - `loginWepinWithIdToken`
   - `loginWepinWithAccessToken`
   - `loginWepinWithEmailAndPassword`
 - Added a method to retrieve Firebase information using OAuth provider login:
   - `loginFirebaseWithOauthProvider`
    > This method can only be used after the authentication key has been deleted from the workspace.
    > Please delete the authentication key from the workspace before using this method.
    > (Workspace page > Development Tools menu > Login tab > Auth Key)

## 0.0.4

### Update
  - Updated `wepin_flutter_network` package to v0.0.4
  - Updated `wepin_flutter_common` package to v0.0.5
  - Updated `wepin_flutter_storage` package to v0.0.3

## 0.0.3

### Update
  - Minimum required `dart` version updated to v2.18.3.
  - Minimum required `flutter` version updated to v3.3.0.
  - Updated `wepin_flutter_network` package to v0.0.3
  - Updated `wepin_flutter_common` package to v0.0.4
  - Updated `wepin_flutter_storage` package to v0.0.2

## 0.0.2

### Update
  - Updated `wepin_flutter_network` package to v0.0.2 


## 0.0.1

- Initial release of `wepin_flutter_login_lib`.
