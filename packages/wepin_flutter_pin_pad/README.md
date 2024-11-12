<br/>

<p align="center">
  <a href="https://wepin.io">
      <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://github.com/WepinWallet/wepin-web-sdk-v1/blob/main//assets/wepin_logo_white.png">
        <img bg_color="white" alt="wepin logo" src="https://github.com/WepinWallet/wepin-web-sdk-v1/blob/main//assets/wepin_logo_color.png" width="250" height="auto">
      </picture>
  </a>
</p>

<br>


# wepin_flutter_pin_pad

[![mit licence](https://img.shields.io/dub/l/vibe-d.svg?style=for-the-badge)](https://github.com/WepinWallet/wepin-flutter-sdk/blob/main/LICENSE)

[![pub package](https://img.shields.io/pub/v/wepin_flutter_pin_pad.svg?logo=flutter&style=for-the-badge)](https://pub.dartlang.org/packages/wepin_flutter_pin_pad)

[![platform - android](https://img.shields.io/badge/platform-Android-3ddc84.svg?logo=android&style=for-the-badge)](https://www.android.com/) [![platform - ios](https://img.shields.io/badge/platform-iOS-000.svg?logo=apple&style=for-the-badge)](https://developer.apple.com/ios/)

Wepin Pin Pad libarary for Flutter. This package is exclusively available for use in Android and iOS environments.

## ⏩ Get App ID and Key

After signing up for [Wepin Workspace](https://workspace.wepin.io/), navigate to the development tools menu, and enter the required information for each app platform to receive your App ID and App Key.

## ⏩ Requirements

- **Android**: API version **21** or newer is required.
  - Set `compileSdkVersion` to **34** in the `android/app/build.gradle` file. 
- **iOS**: Version **13** or newer is required.
  - Update the `platform :ios` version to **13.0** in the `ios/Podfile` of your Flutter project. Verify and modify the `ios/Podfile` as needed.

## ⏩ Install
Add the `wepin_flutter_pin_pad` dependency in your pubspec.yaml file:

```yaml
dependencies:
  wepin_flutter_pin_pad: ^0.0.1
```
or run the following command:

```bash
flutter pub add wepin_flutter_pin_pad
```

## ⏩ Getting Started

### Config Deep Link

To enable OAuth login functionality (`login.loginWithOauthProvider`), you need to configure the Deep Link Scheme.

Deep Link scheme format : `wepin. + Your Wepin App ID`

#### Android

When a custom scheme is used, the WepinWidget SDK can be easily configured to capture all redirects using this custom scheme through a manifest placeholder in the `build.gradle (app)` file:

```kotlin
// For Deep Link => RedirectScheme Format: wepin. + Wepin App ID
android.defaultConfig.manifestPlaceholders = [
  'appAuthRedirectScheme': 'wepin.{{YOUR_WEPIN_APPID}}'
]
```

#### iOS

You must add the app's URL scheme to the `Info.plist` file. This is necessary for redirection back to the app after the authentication process.

The value of the URL scheme should be `'wepin.' + your Wepin app id`.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>unique name</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>wepin.{{YOUR_WEPIN_APPID}}</string>
        </array>
    </dict>
</array>
```

## ⏩ Import SDK

```dart
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad.dart';
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad_types.dart';
```

## ⏩ Initialize

```dart
WepinPinPad wepinPinPad = WepinPinPad(wepinAppKey: wepinAppKey, wepinAppId: wepinAppId);
```

### init

```dart
await wepinPinPad.init(String? language)
```

#### Parameters
  - `language` \<String> - The language to be displayed on the widget (default: 'en'). Currently, only 'ko', 'en', and 'ja' are supported.
#### Example

```dart
await wepinPinPad.init('ko')
```

### isInitialized

```dart
wepinPinPad.isInitialized()
```

The `isInitialized()` method checks if the Wepin PinPad Libarary is initialized.

#### Returns

- Future\<bool> - Returns `true` if  Wepin PinPad Libarary is already initialized, otherwise false.

### changeLanguage
```dart
wepinPinPad.changeLanguage(String language)
```

The `changeLanguage()` method changes the language and currency of the widget.

#### Parameters
- `language` \<String> - The language to be displayed on the widget. Currently, only 'ko', 'en', and 'ja' are supported.

#### Returns
- void

#### Example

```dart
wepinPinPad.changeLanguage('ko');
```

## ⏩ Method & Variable

Methods and Variables can be used after initialization of Wepin Widget SDK.

### login

The `login` variable is a Wepin login library that includes various authentication methods, allowing users to log in using different approaches. It supports email and password login, OAuth provider login, login using ID tokens or access tokens, and more. For detailed information on each method, please refer to the official library documentation at [wepin_flutter_login_lib](https://pub.dev/packages/wepin_flutter_login_lib).

#### Available Methods
- `loginWithOauthProvider`
- `signUpWithEmailAndPassword`
- `loginWithEmailAndPassword`
- `loginWithIdToken`
- `loginWithAccessToken`
- `getRefreshFirebaseToken`
- `loginWepin`
- `getCurrentWepinUser`
- `logout`
- `getSignForLogin`

These methods support various login scenarios, allowing you to select the appropriate method based on your needs.

For detailed usage instructions and examples for each method, please refer to the official library documentation. The documentation includes explanations of parameters, return values, exception handling, and more.

#### Example
```dart
// Login using an OAuth provider
final oauthResult = await wepinPinPad.login.loginWithOauthProvider(provider: 'google', clientId: 'your-client-id');

// Sign up and log in using email and password
final signUpResult = await wepinPinPad.login.signUpWithEmailAndPassword(email: 'example@example.com', password: 'password123');

// Log in using an ID token
final idTokenResult = await wepinPinPad.login.loginWithIdToken(idToken: 'your-id-token', sign: 'your-sign');

// Log in to Wepin
final wepinLoginResult = await wepinPinPad.login.loginWepin(idTokenResult);

// Get the currently logged-in user
final currentUser = await wepinPinPad.login.getCurrentWepinUser();

// Logout
await wepinPinPad.login.logout();
```

For more details on each method and to see usage examples, please visit the official  [wepin_flutter_login_lib documentation](https://pub.dev/packages/wepin_flutter_login_lib).


### generateRegistrationPINBlock
```dart
await generateRegistrationPINBlock(BuildContext context)
```
Generates a pin block for registration.

#### Parameters
 - context \<BuildContext> - The `BuildContext` parameter is essential in Flutter as it represents the location of a widget in the widget tree. This context is used by Flutter to locate the widget's position in the tree and to provide various functions like navigation, accessing theme data, and more. When you call `generateRegistrationPINBlock`, you pass the current context to ensure that the widget is displayed within the correct part of the UI hierarchy.
   
#### Returns
 - Future\<RegistrationPinBlock>
   - UVD: \<EncUVD> - Encrypted PIN
     - b64Data \<String> - Data encrypted with the original key in b64SKey
     - b64SKey \<String> - A key that encrypts data encrypted with the Wepin's public key.
     - seqNum \<int> - __optionl__ Values to check for when using PIN numbers to ensure they are used in order.
   - hint: \<EncPinHint> - Hints in the encrypted PIN.
     - data \<String> - Encrypted hint data.
     - length \<String> - The length of the hint
     - version \<int> - The version of the hint

#### Example
```dart
await wepinPinPad.generateRegistrationPINBlock(context);
```

### generateAuthPINBlock
```dart
await generateAuthPINBlock(BuildContext context, int? count)
```
Generates a pin block for authentication.

#### Parameters
 - context \<BuildContext> - The `BuildContext` parameter is essential in Flutter as it represents the location of a widget in the widget tree. This context is used by Flutter to locate the widget's position in the tree and to provide various functions like navigation, accessing theme data, and more. When you call `generateAuthPINBlock`, you pass the current context to ensure that the widget is displayed within the correct part of the UI hierarchy.
 - count \<int> - __optional__ PIN block count (default value is 1).
   
#### Returns
 - Future\<AuthPinBlock>
   - UVDs: \<List<EncUVD>> - Encypted pin list
     - b64Data \<String> - Data encrypted with the original key in b64SKey
     - b64SKey \<String> - A key that encrypts data encrypted with the wepin's public key.
     - seqNum \<int> - __optionl__ Values to check for when using PIN numbers to ensure they are used in order
   - otp \<String> - __optionl__ If OTP authentication is required, include the OTP.

#### Example
```dart
await wepinPinPad.generateAuthPINBlock(context, 1);
```

### generateChangePINBlock
```dart
await generateChangePINBlock(BuildContext context)
```
Generate pin block for changing the PIN.

#### Parameters
 - context \<BuildContext> - The `BuildContext` parameter is essential in Flutter as it represents the location of a widget in the widget tree. This context is used by Flutter to locate the widget's position in the tree and to provide various functions like navigation, accessing theme data, and more. When you call `generateChangePINBlock`, you pass the current context to ensure that the widget is displayed within the correct part of the UI hierarchy.
   
#### Returns
 - Future\<ChangePinBlock>
   - UVD: \<EncUVD> - Encrypted PIN
     - b64Data \<String> - Data encrypted with the original key in b64SKey
     - b64SKey \<String> - A key that encrypts data encrypted with the wepin's public key.
     - seqNum \<int> - __optionl__ Values to check for when using PIN numbers to ensure they are used in order
   - newUVD: \<EncUVD> - New encrypted PIN
     - b64Data \<String> - Data encrypted with the original key in b64SKey
     - b64SKey \<String> - A key that encrypts data encrypted with the wepin's public key.
     - seqNum \<int> - __optionl__ Values to check for when using PIN numbers to ensure they are used in order
   - hint: \<EncPinHint> - Hints in the encrypted PIN
     - data \<String> - Encrypted hint data
     - length \<String> - The length of the hint
     - version \<int> - The version of the hint
   - otp \<String> - __optionl__ If OTP authentication is required, include the OTP.

#### Example
```dart
await wepinPinPad.generateChangePINBlock(context);
```

### generateAuthOTP
```dart
await generateAuthOTP(BuildContext context)
```
generate OTP.

#### Parameters
 - context \<BuildContext> - The `BuildContext` parameter is essential in Flutter as it represents the location of a widget in the widget tree. This context is used by Flutter to locate the widget's position in the tree and to provide various functions like navigation, accessing theme data, and more. When you call `generateAuthOTP`, you pass the current context to ensure that the widget is displayed within the correct part of the UI hierarchy.
   
#### Returns
 - Future\<AuthOTP>
   - code \<String> - __optionl__ The OTP entered by the user.

#### Example
```dart
await wepinPinPad.generateAuthOTP(context);
```

### finalize
```dart
await wepinPinPad.finalize()
```

The `finalize()` method finalizes the Wepin PinPad Libarary, releasing any resources or connections it has established.

#### Parameters
 - None - This method does not take any parameters.
 - 
#### Returns
 - Future\<void> - A future that completes when the SDK has been finalized.

#### Example
```dart
await wepinPinPad.finalize();
```
