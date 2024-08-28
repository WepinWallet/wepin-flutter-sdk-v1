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


# wepin_flutter_login_lib

[![mit licence](https://img.shields.io/dub/l/vibe-d.svg?style=for-the-badge)](https://github.com/WepinWallet/wepin-flutter-login/blob/main/LICENSE)

[![pub package](https://img.shields.io/pub/v/wepin_flutter_login_lib.svg?logo=flutter&style=for-the-badge)](https://pub.dartlang.org/packages/wepin_flutter_login_lib)

[![platform - android](https://img.shields.io/badge/platform-Android-3ddc84.svg?logo=android&style=for-the-badge)](https://www.android.com/) [![platform - ios](https://img.shields.io/badge/platform-iOS-000.svg?logo=apple&style=for-the-badge)](https://developer.apple.com/ios/)

Wepin Login Library from Flutter. This package is exclusively available for use in android and ios environments.

## ⏩ Get App ID and Key

After signing up for [Wepin Workspace](https://workspace.wepin.io/), navigate to the development tools menu, and enter the required information for each app platform to receive your App ID and App Key.

## ⏩ Requirements

- Android API version **21** or newer is required.
- iOS version **13** or newer is required.
    - Update the `platform :ios` version to **13.0** in the `ios/Podfile` of your Flutter project. Verify and modify the `ios/Podfile` as needed.
- Dart version **2.18.3** or newer is required.
- Flutter version **3.3.0** or newer is required.

> [!NOTE]
> 
> Due to potential multidex issues, it is recommended to use Android compiler SDK version **21** or higher. 
>
>  Ensure that the `minSdkVersion` in your app's `build.gradle` file is set to **21** or higher[[flutter document](https://docs.flutter.dev/deployment/android#enable-multidex-support)] :
>
> - `build.gradle` file `minSdkVersion` setting:    
>    You should ensure the correct minSdkVersion is set in android/app/build.gradle if it was previously lower than **21**:
>    ```gradle
>    android {
>        defaultConfig {
>            minSdkVersion 21
>        }
>    }
>    ```


## ⏩ Install
Add the `wepin_flutter_login_lib` dependency in your pubspec.yaml file:

```yaml
dependencies:
  wepin_flutter_login_lib: ^0.0.5
```
or run the following command:

```bash
flutter pub add wepin_flutter_login_lib
```


## ⏩ Getting Started

### Deep Link Setting
The Deep Link configuration is required for logging into Wepin. Setting up the Deep Link Scheme allows your app to handle external URL calls.

The format for the Deep Link scheme is `wepin. + Your Wepin App ID`

#### Android

On Android, you can configure the Wepin Login Library to handle all redirects using a custom scheme by adding a manifest placeholder in the `build.gradle (app)` file::

```kotlin
// For Deep Link => RedirectScheme Format: wepin. + Wepin App ID
android.defaultConfig.manifestPlaceholders = [
  'appAuthRedirectScheme': 'wepin.{{YOUR_WEPIN_APPID}}'
]
```

#### iOS

On iOS, you need to add the app's URL scheme to the Info.plist file. This is necessary to enable redirection back to the app after the authentication process. 

The URL scheme value should be 'wepin.' + your Wepin App ID.

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

### OAuth Login Provider Setup

If you want to use OAuth login functionality (e.g., loginWithOauthProvider), you need to set up OAuth login providers.
To do this, you must first register your OAuth login provider information in the [Wepin Workspace](https://workspace.wepin.io/). 
Navigate to the Login tab under the Developer Tools menu, click the Add or Set Login Provider button in the Login Provider section, and complete the registration.  

![image](https://github.com/user-attachments/assets/b7a7f6d3-69a7-4ee5-ab66-bad57a715fda)

---

## ⏩ Import SDK
```dart
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:wepin_flutter_login_lib/type/wepin_flutter_login_lib_type.dart';
```

## ⏩ Initialize

```dart
WepinLogin wepinLogin = WepinLogin(wepinAppKey: wepinAppKey, wepinAppId: wepinAppId);
```

### init

```dart
await wepinLogin.init()
```

#### Parameters

- None

#### Example

```dart
await wepinLogin.init();
```

### isInitialized

```dart
wepinLogin.isInitialized()
```

The `isInitialized()` method checks if the Wepin Login Library is initialized.

#### Returns

- Future\<bool> - Returns `true` if Wepin Login Library is already initialized, otherwise false.

## ⏩ Method

Methods can be used after initializing the Wepin Login Library.

### loginWithOauthProvider

```dart
await wepinLogin.loginWithOauthProvider({required String provider, required String clientId})
```

An in-app browser will open and proceed to log in to the specified OAuth provider. Returns OAuth login info upon successful login.

#### Parameters
- `provider` \<String> - The OAuth login provider (e.g., 'google', 'naver', 'discord', 'apple').
- `clientId` \<String> - The client ID of the OAuth login provider.

> [!NOTE]
> For details on setting up OAuth providers, refer to the [OAuth Login Provider Setup section](#oauth-login-provider-setup).

#### Returns

- Future\<LoginOauthResult>
    - `provider` \<String>  - The name of the OAuth provider used.
    - `token` \<String> - The token returned by the OAuth provider.
    - `type` \<WepinOauthTokenType> - The type of OAuth token (e.g., idToken, accessToken).

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.loginWithOauthProvider(
  provider: "google",
  clientId: "your-google-client-id"
);
```

- response

```dart
LoginOauthResult(
  provider: "google",
  token: "abcdefgh....adQssw5c",
  type: WepinOauthTokenType.idToken
)
```

### signUpWithEmailAndPassword

```dart
await wepinLogin.signUpWithEmailAndPassword({required String email, required String password, String? locale})
```

This method signs up on Wepin Firebase with your email and password. It returns Firebase login information upon successful signup.

#### Parameters

- `email` \<String> - The user's email address.
- `password` \<String> - The user's password.
- `locale` \<String> - __optional__ The language for the verification email (default: "en").

#### Returns

- Future\<LoginResult>
    - `provider` \<String> - The provider used for the login (in this case, 'email').
    - `token` \<WepinFBToken>
        - `idToken` \<String> - The Wepin Firebase ID token.
        - `refreshToken` \<String> -The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.signUpWithEmailAndPassword(
  email: 'abc@defg.com', 
  password: 'abcdef123&'
);
```

- response

```dart
LoginResult(
  provider: "email",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)

```

### loginWithEmailAndPassword

```dart
await wepinLogin.loginWithEmailAndPassword({required String email, required String password})
```

This method logs in to Wepin Firebase with your email and password. It returns Firebase login information upon successful login.

#### Parameters

- `email` \<String> - The user's email address.
- `password` \<String> - The user's password.

#### Returns

- Future\<LoginResult>
    - `provider` \<String> - The provider used for the login (in this case, 'email').
    - `token` \<WepinFBToken>
        - `idToken` \<String> - The Wepin Firebase ID token.
        - `refreshToken` ``<String>` - The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.loginWithEmailAndPassword(
  email: 'abc@defg.com', 
  password: 'abcdef123&'
);

```

- response

```dart
LoginResult(
  provider: "email",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)
```

### loginWithIdToken

```dart
await wepinLogin.loginWithIdToken({required String idToken, required String sign})
```

The `loginWithIdToken()` method logs in to Wepin Firebase using an external ID token. It returns Firebase login information upon successful login.

#### Parameters

- `idToken` \<String> - The ID token value to be used for login.
- `sign` \<String?> - __optional__ The signature value for the token provided as the first parameter. (Returned value of [getSignForLogin()](#getSignForLogin))

> [!NOTE]
> Starting from wepin_flutter_login_lib version 0.0.5, the sign value is optional.
> 
> If you choose to remove the authentication key issued from the [Wepin Workspace](https://workspace.wepin.io/), you may opt not to use the `sign` value. 
>
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.

#### Returns

- Future\<LoginResult>
    - `provider` \<'external_token'> - The provider used for the login.
    - `token` \<WepinFBToken>
        - `idToken` \<String> - The Wepin Firebase ID token.
        - `refreshToken` \<String> - The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.loginWithIdToken(
    idToken:'eyJHGciO....adQssw5c', 
    sign:'9753d4dc...c63466b9'
);
```

- response

```dart
LoginResult(
  provider: "external_token",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)

```

### loginWithAccessToken

```dart
await wepinLogin.loginWithAccessToken({required String provider, required String accessToken, required String sign})
```

The `loginWithAccessToken()` method logs in to Wepin Firebase using an external access token. It returns Firebase login information upon successful login.

#### Parameters

- `provider` \<'naver'|'discord'>  - The provider that issued the access token.
- `accessToken` \<String> - The access token value to be used for login.
- `sign` \<String?> - __optional__ The signature value for the token provided as the first parameter. [getSignForLogin()](#getSignForLogin))

> [!NOTE]
> Starting from wepin_flutter_login_lib version 0.0.5, the sign value is optional.
>
> If you choose to remove the authentication key issued from the [Wepin Workspace](https://workspace.wepin.io/), you may opt not to use the `sign` value. 
>
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.

#### Returns

- Future\<LoginResult>
    - `provider` \<'external_token'> - The provider used for the login.
    - `token` \<WepinFBToken>
        - `idToken` \<String> - The Wepin Firebase ID token.
        - `refreshToken` \<String> - The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.loginWithAccessToken(
    provider: 'naver', 
    accessToken:'eyJHGciO....adQssw5c', 
    sign:'9753d4dc...c63466b9'
);
```

- response

```dart
LoginResult(
  provider: "external_token",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)

```

### getSignForLogin

The `getSignForLogin()` method generates a signature to verify the issuer. It is primarily used to generate signatures for login-related information such as ID Tokens and Access Tokens.

```dart
final result = getSignForLogin({required String privateKey, required String message});
```

#### Parameters

- `privateKey` \<String> - The authentication key used for signature generation.
- `message` \<String> - The message or payload to be signed.

#### Returns

- \<String> - The generated signature.

> [!CAUTION]
>
> The authentication key (`privateKey`) must be stored securely and must not be exposed to the outside. It is recommended to execute the `getSignForLogin()` method on the backend rather than the frontend for enhanced security and protection of sensitive information.  [How to Implement Direct Signature Generation Functions](https://github.com/WepinWallet/wepin-web-sdk-v1/blob/main/packages/login/SignatureGenerationMethods.md#using-secp256k1-and-crypto-modules)

#### Example

```dart
final sign = getSignForLogin(
  privateKey: '0400112233445566778899001122334455667788990011223344556677889900', 
  message: 'idtokenabcdef'
);

final res = await wepinLogin.loginWithIdToken(
    idToken: 'eyJHGciO....adQssw5c', 
    sign: sign
);
```

### getRefreshFirebaseToken
```dart
await wepinLogin.getRefreshFirebaseToken()
```

The `getRefreshFirebaseToken()` method retrieves the current Firebase token's information from Wepin.

#### Parameters
- None

#### Returns
- Future\<LoginResult>
    - `provider` \<String> - The provider used for the login.
    - `token` \<WepinFBToken>
        - `idToken` \<String> -  The Wepin Firebase ID token.
        - `refreshToken` \<String> -The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)
-
#### Example
```dart
final user = await wepinLogin.getRefreshFirebaseToken();
```
- response
```dart
LoginResult(
  provider: "external_token",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)
```

### loginWepin

```dart
await wepinLogin.loginWepin(LoginResult params) 
```

The `loginWepin()` method logs the user into the Wepin application using the specified provider and token.

#### Parameters

- `params` \<LoginResult> - The parameters should utilize the return values from the `loginWithOauthProvider()`, `loginWithEmailAndPassword()`, `loginWithIdToken()`, and `loginWithAccessToken()` methods within this module.
    - `provider` \<'google'|'apple'|'naver'|'discord'|'external_token'|'email'> - The login provider.
    - `token` \<WepinFBToken> - The login tokens.

#### Returns

- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, the user must be registered in Wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final wepinLogin = WepinLogin(appId: 'appId', appKey: 'appKey');
await wepinLogin.init();
final res = await wepinLogin.loginWithOauthProvider(
provider: "google",
clientId: "your-google-client-id"
);

final sign = wepinLogin?.getSignForLogin(privateKey: privateKey, message: res!.token);
LoginResult? resLogin;
if(provider == 'naver' || provider == 'discord') {
  resLogin = await wepinLogin.loginWithAccessToken(provider: provider, accessToken: res!.token, sign: sign));
} else {
  resLogin = await wepinLogin.loginWithIdToken(idToken: res!.token, sign: sign));
}

final userInfo = await wepinLogin.loginWepin(resLogin);
final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```

- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@gmail.com",
    provider: "google",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```

### getCurrentWepinUser
```dart
await wepinLogin.getCurrentWepinUser()
```
The `getCurrentWepinUser()` method retrieves the currently logged-in user's information from Wepin.

#### Parameters
- None

#### Exception

- [WepinError](#WepinError)

#### Returns
- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, it must be registered in the wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Example

```dart
final userInfo = await wepinLogin.getCurrentWepinUser();
final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```
- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@gmail.com",
    provider: "google",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```

### loginFirebaseWithOauthProvider

```dart
await wepinLogin.loginFirebaseWithOauthProvider({required String provider, required String clientId})
```

This method combines the functionality of `loginWithOauthProvider`, `loginWithIdToken`, and `loginWithAccessToken`. 
It opens an in-app browser to log in to Wepin Firebase through the specified OAuth login provider. Upon successful login, it returns Firebase login information.

> [!CAUTION]
> This method can only be used after the authentication key has been deleted from the [Wepin Workspace](https://workspace.wepin.io/).
>
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.

#### Supported Version
Supported from version *`0.0.5`* and later.

#### Parameters
- `provider` \<String> - The OAuth login provider (e.g., 'google', 'naver', 'discord', 'apple').
- `clientId` \<String> - The client ID of the OAuth login provider.
  
> [!NOTE]
> For details on setting up OAuth providers, refer to the [OAuth Login Provider Setup section](#oauth-login-provider-setup).

#### Returns

- Future\<LoginResult>
    - `provider` \<'external_token'> - The provider used for the login.
    - `token` \<WepinFBToken>
        - `idToken` \<String> - The Wepin Firebase ID token.
        - `refreshToken` \<String> - The Wepin Firebase refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final user = await wepinLogin.loginFirebaseWithOauthProvider(
    provider:'apple', 
    clietId:'apple-client-id'
);
```

- response

```dart
LoginResult(
  provider: "apple",
  token: WepinFBToken(
    idToken: "ab2231df....ad0f3291",
    refreshToken: "eyJHGciO....adQssw5c",
  )
)

```


### loginWepinWithOauthProvider

```dart
await wepinLogin.loginWepinWithOauthProvider({required String provider, required String clientId})
```

This method combines the functionality of `loginFirebaseWithOauthProvider` and `loginWepin`. 
It opens an in-app browser to log in to Wepin through the specified OAuth login provider. Upon successful login, it returns Wepin user information.

> [!CAUTION]
> This method can only be used after the authentication key has been deleted from the [Wepin Workspace](https://workspace.wepin.io/).
> 
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.

#### Supported Version
Supported from version *`0.0.5`* and later.

#### Parameters
- `provider` \<String> - The OAuth login provider (e.g., 'google', 'naver', 'discord', 'apple').
- `clientId` \<String> - The client ID of the OAuth login provider.

> [!NOTE]
> For details on setting up OAuth providers, refer to the [OAuth Login Provider Setup section](#oauth-login-provider-setup).

#### Returns

- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, the user must be registered in Wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final wepinLogin = WepinLogin(appId: 'appId', appKey: 'appKey');
await wepinLogin.init();
final userInfo = await wepinLogin.loginWepinWithOauthProvider(
  provider: 'google',
  clientId; 'google-client-id'
);

final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```

- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@gmail.com",
    provider: "google",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```


### loginWepinWithIdToken

```dart
await wepinLogin.loginWepinWithIdToken({required String idToken, String? sign})
```

This method integrates the functions of `loginWithIdToken` and `loginWepin`. 
The `loginWepinWithIdToken` method logs the user into Wepin using an external ID token. Upon successful login, it returns Wepin user information.

#### Supported Version
Supported from version *`0.0.5`* and later.

#### Parameters

- `idToken` \<String> - The id token value to be used for login.
- `sign` \<String?> - __optional__ The signature value for the token provided as the first parameter. [getSignForLogin()](#getSignForLogin))

> [!NOTE]
> If you choose to remove the authentication key issued from the Wepin Workspace, you may opt not to use the `sign` value.
>
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.


#### Returns

- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, the user must be registered in Wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final wepinLogin = WepinLogin(appId: 'appId', appKey: 'appKey');
await wepinLogin.init();
final userInfo = await wepinLogin.loginWepinWithIdToken(
  idToken:'eyJHGciO....adQssw5c',
);

final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```

- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@gmail.com",
    provider: "external_token",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```

### loginWepinWithAccessToken

```dart
await wepinLogin.loginWepinWithAccessToken({required String provider, required String accessToken, String? sign})
```

This method integrates the functions of `loginWithAccessToken` and `loginWepin`. 
The `loginWepinWithAccessToken` method logs the user into Wepin using an external access token. Upon successful login, it returns Wepin user information.

#### Supported Version
Supported from version *`0.0.5`* and later.

#### Parameters

- `provider` \<'naver'|'discord'>  - The provider that issued the access token.
- `accessToken` \<String> - The access token value to be used for login.
- `sign` \<String?> - __optional__ The signature value for the token provided as the first parameter. [getSignForLogin()](#getSignForLogin))

> [!NOTE]
> If you choose to remove the authentication key issued from the Wepin Workspace, you may opt not to use the `sign` value.
>
> (Wepin Workspace > Development Tools menu > Login tab > Auth Key > Delete)
> > The Auth Key menu is visible only if an authentication key was previously generated.


#### Returns

- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, the user must be registered in Wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final wepinLogin = WepinLogin(appId: 'appId', appKey: 'appKey');
await wepinLogin.init();
final userInfo = await wepinLogin.loginWepinWithAccessToken(
    provider: 'naver',
    accessToken:'eyJHGciO....adQssw5c',
);

final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```

- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@naver.com",
    provider: "external_token",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```

### loginWepinWithEmailAndPassword 

```dart
await wepinLogin.loginWepinWithEmailAndPassword({required String email, required String password})
```

This method integrates the functions of `loginWithEmailAndPassword` and `loginWepin`. 
The `loginWepinWithEmailAndPassword` method logs the user into Wepin using the provided email and password. Upon successful login, it returns Wepin user information.

#### Supported Version
Supported from version *`0.0.5`* and later.

#### Parameters

- `email` \<String> - The user's email address.
- `password` \<String> - The user's password.

#### Returns

- Future\<WepinUser> - A Future that resolves to a WepinUser object containing the user's login status and information.
    - status \<'success'|'fail'>  - The login status.
    - userInfo \<WepinUserInfo> __optional__ - The user's information, including:
        - userId \<String> - The user's ID.
        - email \<String> - The user's email.
        - provider \<'google'|'apple'|'naver'|'discord'|'email'|'external_token'> - The login provider.
        - use2FA \<bool> - Whether the user uses two-factor authentication.
    - walletId \<String> = The user's wallet ID.
    - userStatus: \<WepinUserStatus> - The user's status of wepin login. including:
        - loginStatus: \<'complete' | 'pinRequired' | 'registerRequired'> - If the user's loginStatus value is not complete, the user must be registered in Wepin.
        - pinRequired?: <bool> - Whether a PIN is required.
    - token: \<WepinToken> - The user's token of wepin.
        - accessToken: \<String> - The access token.
        - refreshToken \<String> - The refresh token.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final wepinLogin = WepinLogin(appId: 'appId', appKey: 'appKey');
await wepinLogin.init();
final userInfo = await wepinLogin.loginWithEmailAndPassword(
    email: "abc@abc.com",
    password: "user_password"
);

final userStatus = userInfo.userStatus;
if (userStatus.loginStatus == 'pinRequired' || userStatus.loginStatus == 'registerRequired') {
    // Wepin register
}
```

- response
```dart
WepinUser(
  status: "success",
  userInfo: WepinUserInfo(
    userId: "120349034824234234",
    email: "abc@abc.com",
    provider: "email",
    use2FA: true,
  ),
  walletId: "abcdsfsf123",
  userStatus: WepinUserStatus(
    loginStatus: "complete",
    pinRequired: false,
  ),
  token: WepinToken(
    accessToken: "access_token",
    refreshToken: "refresh_token",
  )
)
```

### logout

```dart
await wepinLogin.logout()
```

The `logout()` method logs out the currently logged-in user from Wepin.

#### Parameters

- None

#### Returns

- Future\<bool>  - A Future that resolves to true if the logout was successful.

#### Exception

- [WepinError](#WepinError)

#### Example

```dart
final result = await wepinLogin.logout();
if (result) {
  // Successfully logged out
}
```

### finalize

```dart
await wepinLogin.finalize()
```

The `finalize()` method finalizes and cleans up the Wepin Login Library, releasing any resources that were used.

#### Parameters

- None

#### Returns

- Future/<void> - A Future that resolves when the finalization process is complete.

#### Example

```dart
await wepinLogin.finalize();
```

### WepinError

This section provides descriptions of various error codes that may be encountered while using the Wepin Login Library functionalities. Each error code corresponds to a specific issue, and understanding these can help in debugging and handling errors effectively.

| Error Code                     | Error Message                    | Error Description                                                                                                                                                                                       |
| ------------------------------ | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `invalidAppKey`          	 | "InvalidAppKey"            	   | The Wepin app key is invalid.                                                                                                                                                                        	|
| `invalidParameters` `    	 | "InvalidParameters" 	 	   | One or more parameters provided are invalid or missing.                                                                                                                                              	|
| `invalidLoginProvider`    	 | "InvalidLoginProvider"     	   | The login provider specified is not supported or is invalid.                                                                                                                                         	|
| `invalidToken`             	 | "InvalidToken"            	   | The token does not exist.                                                                                                                                                                            	|
| `invalidLoginSession`    	 | "InvalidLoginSession"      	   | The login session information does not exist.                                                                                                                                                        	|
| `notInitialized`     		 | "NotInitialized"       	   | The WepinLoginLibrary has not been properly initialized.                                                                                                                                             	|
| `alreadyInitialized` 		 | "AlreadyInitialized"            | The WepinLoginLibrary is already initialized, so the logout operation cannot be performed again.                                                                                                     	|
| `userCancelled`           	 | "UserCancelled"           	   | The user has cancelled the operation.                                                                                                                                                                	|
| `unknownError`            	 | "UnknownError"       	   | An unknown error has occurred, and the cause is not identified.                                                                                                                                      	|
| `notConnectedInternet`   	 | "NotConnectedInternet"     	   | The system is unable to detect an active internet connection.                                                                                                                                        	|
| `failedLogin`             	 | "FailedLogin"     	 	   | The login attempt has failed due to incorrect credentials or other issues.                                                                                                                           	|
| `alreadyLogout`           	 | "AlreadyLogout"           	   | The user is already logged out, so the logout operation cannot be performed again.                                                                                                                   	|
| `invalidEmailDomain`     	 | "InvalidEmailDomain"       	   | The provided email address's domain is not allowed or recognized by the system.                                                                                                                      	|
| `failedSendEmail`         	 | "FailedSendEmail"           	   | The system encountered an error while sending an email. This is because the email address is invalid or we sent verification emails too often. Please change your email or try again after 1 minute. 	|
| `requiredEmailVerified`  	 | "RequiredEmailVerified"     	   | Email verification is required to proceed with the requested operation.                                                                                                                              	|
| `incorrectEmailForm`      	 | "incorrectEmailForm"        	   | The provided email address does not match the expected format.                                                                                                                                      	|
| `incorrectPasswordForm`   	 | "IncorrectPasswordForm"     	   | The provided password does not meet the required format or criteria.                                                                                                                                 	|
| `notInitializedNetwork`   	 | "NotInitializedNetwork" 	  	   | The network or connection required for the operation has not been properly initialized.                                                                                                              	|
| `requiredSignupEmail`     	 | "RequiredSignupEmail"       	   | The user needs to sign up with an email address to proceed.                                                                                                                                          	|
| `failedEmailVerified`     	 | "FailedEmailVerified"       	   | The WepinLoginLibrary encountered an issue while attempting to verify the provided email address.                                                                                                    	|
| `failedPasswordStateSetting`   | "FailedPasswordStateSetting"    | Failed to set the password state. This error may occur during password management operations, potentially due to invalid input or system issues.                                                   	|
| `failedPasswordSetting` 	 | "failedPasswordSetting"         | Failed to set the password. This could be due to issues with the provided password or internal errors during the password setting process.                                                              |
| `existedEmail`                 | "ExistedEmail"           	   | The provided email address is already registered. This error occurs when attempting to sign up with an email that is already in use.                               					|
| `apiRequestError`              | "ApiRequestError"               | There was an error while making the API request. This can happen due to network issues, invalid endpoints, or server errors.                                                                            |
| `incorrectLifecycleException`  | "IncorrectLifecycleException"   |The lifecycle of the Wepin SDK is incorrect for the requested operation. Ensure that the SDK is in the correct state (e.g., `initialized` and `login`) before proceeding.  |
| `failedRegister`             	 | "FailedRegister"           	   | Failed to register the user. This can occur due to issues with the provided registration details or internal errors during the registration process.                                                    |
| `accountNotFound`              | "AccountNotFound"           	   | The specified account was not found. This error is returned when attempting to access an account that does not exist in the Wepin.                                                                      |
| `nftNotFound`             	 | "NftNotFound"           	   | The specified NFT was not found. This error occurs when the requested NFT does not exist or is not accessible within the user's account.                                                                |
| `failedSend`             	 | "FailedSend"           	   | Failed to send the required data or request. This error could be due to network issues, incorrect data, or internal server errors.                                                                      |


