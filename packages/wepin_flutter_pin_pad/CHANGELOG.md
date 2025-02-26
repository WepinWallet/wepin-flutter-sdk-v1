## 1.0.0

This new major release has some big changes.
This plugin requires a minimum dart sdk of 3.5.0 or higher and a minimum flutter version of 3.24.0.

### Update
- Updated Flutter, Dart, and Gradle versions
    -	Dart: v3.5.0
    - Flutter: v3.24.0
    - Gradle: v8.2.1
- Updated `wepin_flutter_login_lib` package to v1.0.0
- Updated `wepin_flutter_network` package to v1.0.0
- Updated `wepin_flutter_storage` package to v1.0.0
    - Migration from `flutter_secure_storage` to native storage (iOS/Android)
    - Fixed storage issue caused by MasterKey change (Now resets storage properly).

### Bug Fixes
- Fixed User Cancel Error Code Issue
  - Changed `WepinErrorCode.unknownError` → `WepinErrorCode.userCancelled`

## 0.0.4

### Updated:
 - Updated `wepin_flutter_login_lib` to v0.0.11
   - Updated `getRefreshFirebaseToken` to optionally accept a token parameter. 

## 0.0.3

### Updated:
- Updated `wepin_flutter_modal` package to v0.0.5
  - Updated `flutter_inappwebview` to version `6.1.5` to resolve the `SUPPRESS_ERROR_PAGE` error occurring in version `6.0.0`.

## 0.0.2

### Updated:
- Removed unnecessary currency parameter.

## 0.0.1

### Initial Release:
- Initial release of wepin_flutter_pin_pad.
