## 1.0.0-beta.1

This new major release has some big changes.
This plugin requires a minimum dart sdk of 3.5.0 or higher and a minimum flutter version of 3.24.0.

### Update
- Updated Flutter, Dart, and Gradle versions
  - Dart: v3.5.0
  - Flutter: v3.24.0
  - Gradle: v8.2.1
- Updated `wepin_flutter_storage` package to v1.0.0-beta.1
  - Migration from `flutter_secure_storage` to native storage (iOS/Android)
- Replaced `flutter_bcrypt` with native implementation

## 0.0.11

### Update
 - Updated `getRefreshFirebaseToken` to optionally accept a token parameter.

## 0.0.10

### Bug Fixes
- Added missing source code for previous versions.

## 0.0.9

### Update
- Updated `wepin_flutter_network` package to v0.0.8
- 
## 0.0.8

### Update
- Updated `wepin_flutter_network` package to v0.0.7

## 0.0.7

### Update
 - Added AppAuth login support for LINE and Facebook.

### Bug Fixes
 - Added implementation 'androidx.appcompat:appcompat:1.6.1' to resolve compatibility issues.

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
