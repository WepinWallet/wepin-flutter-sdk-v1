import 'package:flutter/material.dart';
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad.dart';
import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad_types.dart';
import 'package:wepin_flutter_pin_pad_example/widgets/account_selection.dart';
import 'package:wepin_flutter_pin_pad_example/widgets/user_drawer.dart';
import 'values/sdk_app_info.dart';
import 'widgets/email_login_dialog.dart';
import 'widgets/custom_dialog.dart';
import 'network.dart';

class WepinSDKScreen extends StatefulWidget {
  const WepinSDKScreen({super.key});
  @override
  WepinSDKScreenState createState() => WepinSDKScreenState();
}

class WepinSDKScreenState extends State<WepinSDKScreen> {
  final Map<String, String> currency = {
    'ko': 'KRW',
    'en': 'USD',
    'ja': 'JPY',
  };

  WepinPinPad? wepinPinPad;
  String? selectedLanguage = 'ko';
  String? selectedValue = sdkConfigs[0]['name'];
  String? wepinAppKey;
  String? wepinAppId;
  String userEmail = '';
  WepinUser? userInfo;
  String loginStatus = 'login_required';

  bool isLoading = false;
  String? privateKey;
  String? googleClientId;
  String? discordClientId;
  String? appleClientId;
  String? naverClientId;

  NetworkManager? networkManager;
  List<IAppAccount> selectedAccounts = [];
  List<IAppAccount> accountsList = [];

  @override
  void initState() {
    super.initState();
    setWepinPinPadInfo();
  }

  void setWepinPinPadInfo() {
    final selectedConfig = sdkConfigs.firstWhere((config) => config['name'] == selectedValue);
    _updateConfig(selectedConfig);
    initWepinSDK(selectedConfig['appId']!, selectedConfig['appKey']!, selectedConfig['privateKey']!);
  }

  void _updateConfig(Map<String, String> config) {
    setState(() {
      wepinAppKey = config['appKey'];
      wepinAppId = config['appId'];
      privateKey = config['privateKey'];
      googleClientId = config['googleClientId'];
      discordClientId = config['discordClientId'];
      appleClientId = config['appleClientId'];
      naverClientId = config['naverClientId'];
    });
  }

  Future<void> initWepinSDK(String appId, String appKey, String privateKey) async {
    wepinPinPad?.finalize();
    wepinPinPad = WepinPinPad(wepinAppKey: appKey, wepinAppId: appId);
    networkManager = NetworkManager(appKey: appKey);
    await wepinPinPad!.init(language: selectedLanguage!, currency: currency[selectedLanguage!]!);
    setLoginInfo();
  }

  Future<void> setLoginInfo() async {
    if (!wepinPinPad!.isInitialized()) {
      showError('WepinSDK is not initialized.');
    }
    try {
      userInfo = await wepinPinPad!.login.getCurrentWepinUser();
      userEmail = userInfo?.userInfo?.email ?? '';
      networkManager?.setAuthToken(userInfo!.token!.accessToken, userInfo!.token!.refreshToken);
      loginStatus = 'login';
    } catch(e) {
      userEmail = '';
      loginStatus = 'login_required';
    }
    setState(() {});
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialog(message: message, isError: true),
    );
  }

  void showSuccess(String title, String message, {String? buttonText, VoidCallback? buttonCallback}) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialog(title: title, message: message, okButtonText: buttonText, onOkPressed: buttonCallback),
    );
  }

  Future<void> performActionWithLoading(Function action) async {
    setState(() => isLoading = true);
    try {
      await action();
    } catch(e){
      showError(e.toString());
    }finally {
      setState(() => isLoading = false);
    }
  }


  Future<void> loginWithProvider(String provider, String? clientId) async {
    await performActionWithLoading(() async {
      try {
        final oauthToken = await wepinPinPad!.login.loginWithOauthProvider(provider: provider, clientId: clientId!);
        final idToken = oauthToken?.token;
        final sign = wepinPinPad?.login.getSignForLogin(privateKey: privateKey!, message: idToken!);
        final type = oauthToken?.type;

        LoginResult? fbToken;
        if (type == WepinOauthTokenType.idToken) {
          fbToken = await wepinPinPad!.login.loginWithIdToken(idToken: idToken!, sign: sign!);
        } else {
          fbToken = await wepinPinPad!.login.loginWithAccessToken(provider: provider, accessToken: idToken!, sign: sign!);
        }

        final wepinUser = await wepinPinPad?.login.loginWepin(fbToken);
        userEmail = wepinUser!.userInfo!.email;
        await setLoginInfo();
      } catch (e) {
        if (!e.toString().contains('UserCancelled')) {
          showError('Login Failed. (error code - $e)');
        }
      }
    });
  }

  Future<void> loginWithEmail(String email, String password) async {
    await performActionWithLoading(() async {
      try {
        final fbToken = await wepinPinPad!.login.loginWithEmailAndPassword(email: email, password: password);
        final wepinUser = await wepinPinPad?.login.loginWepin(fbToken);
        userEmail = wepinUser!.userInfo!.email;
        await setLoginInfo();
      } catch (e) {
        if (e.toString().contains('RequiredSignupEmail')) {
          showError('Required Signup Email. error code - $e');
        } else {
          showError('Login Failed. (error code - $e)');
        }
      }
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await performActionWithLoading(() async {
      try {
        final fbToken = await wepinPinPad!.login.singUpWithEmailAndPassword(email: email, password: password);
        final wepinUser = await wepinPinPad?.login.loginWepin(fbToken);
        userEmail = wepinUser!.userInfo!.email;
        await setLoginInfo();
      } catch (e) {
        if (e.toString().contains('ExistEmail')) {
          showError('Exist Email Address. (error code - $e)');
        } else {
          showError('Signup Failed. (error code - $e)');
        }
      }
    });
  }

  // Future<void> getCurrentUser() async {
  //   try {
  //     userInfo = await wepinPinPad!.login.getCurrentWepinUser();
  //     loginStatus = 'login';
  //   }catch(e) {
  //     userInfo = null;
  //     loginStatus = 'login_required';
  //   }
  //
  // }

  void getStatus() async {
    await performActionWithLoading(() async {
      if (wepinPinPad != null) {
        await setLoginInfo();
      }
    });
  }

  Future<void> navigateToAccountSelection({bool? selection, bool? allowMultiSelection, bool? withoutToken}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountSelectionScreen(
          getAccounts: accountsList,
          selection: selection,
          allowMultiSelection: allowMultiSelection?? false,
          withoutToken: withoutToken,
        ),
      ),
    );

    if (result != null) {
      setState(() => selectedAccounts = result);
    }
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wepin Pin Pad Example'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (wepinPinPad != null) ...[
                  const SizedBox(height: 16.0),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text('Wepin Login Status: $loginStatus', style: const TextStyle(fontSize: 16)),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                        onPressed: getStatus,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView(
                    children: [
                      if (loginStatus == 'login_required') ...[
                        _buildActionButton('Login with Google', () => loginWithProvider('google', googleClientId)),
                        _buildActionButton('Login with Apple', () => loginWithProvider('apple', appleClientId)),
                        _buildActionButton('Login with Discord', () => loginWithProvider('discord', discordClientId)),
                        _buildActionButton('Login with Naver', () => loginWithProvider('naver', naverClientId)),
                        _buildActionButton('SignUp with Email', () {
                          showDialog(
                            context: context,
                            builder: (ctx) => EmailLoginDialog(onLogin: signUpWithEmail),
                          );
                        }),
                        _buildActionButton('Login with Email', () {
                          showDialog(
                            context: context,
                            builder: (ctx) => EmailLoginDialog(onLogin: loginWithEmail),
                          );
                        }),
                      ],
                      if (loginStatus == 'login') ...[
                        _buildActionButton('generateRegistrationPINBlock', () async {
                          await performActionWithLoading(() async {
                            final res = await wepinPinPad!.generateRegistrationPINBlock(context);
                            showSuccess('generateRegistrationPINBlock result', res.toString(), buttonText: 'register', buttonCallback: () async {
                              try {
                                final registerRes = await networkManager
                                    ?.register(RegisterRequest(
                                    appId: wepinAppId!,
                                    userId: userInfo!.userInfo!.userId,
                                    loginStatus: userInfo!.userStatus!
                                        .loginStatus,
                                    UVD: res.uvd,
                                    hint: res.hint));
                                showSuccess(
                                    'register result', registerRes.toString());
                              } catch(e) {
                                showError(e.toString());
                              }
                              await setLoginInfo();
                            });
                          });
                        }),
                        _buildActionButton('generateAuthPINBlock', () async {
                          await performActionWithLoading(() async {
                            if(!context.mounted) {
                              showError('context is not mounted');
                              return;
                            }
                            final res = await wepinPinPad!.generateAuthPINBlock(context, 1);
                            showSuccess('generateAuthPINBlock result', res.toString(), buttonText: 'msg_sign', buttonCallback: () async {
                              final accountRes = await networkManager?.getAppAccountList(GetAccountListRequest(walletId: userInfo!.walletId!, userId: userInfo!.userInfo!.userId, localeId: '1'));
                              accountsList = accountRes!.accounts;
                              await navigateToAccountSelection(selection: true, allowMultiSelection: false, withoutToken: true);
                              if(selectedAccounts.isEmpty){
                                return;
                              }
                              try {
                                final registerRes = await networkManager
                                    ?.sign(SignRequest(
                                    userId: userInfo!.userInfo!.userId,
                                    type: 'msg_sign',
                                    accountId: selectedAccounts.first.accountId,
                                    walletId: userInfo!.walletId!,
                                    tokenId: selectedAccounts.first.accountTokenId,
                                    contract: selectedAccounts.first.contract,
                                    txData: {
                                        'data': 'test1234'
                                    },
                                    pin: res.uvdList.first,
                                    otpCode: res.otp != null ? OtpCode(
                                      code: res.otp!,
                                      recovery: false
                                    ) : null
                                  ));
                                showSuccess(
                                    'register result', registerRes.toString());
                              } catch(e) {
                                showError(e.toString());
                              }
                              await setLoginInfo();
                            });
                            await setLoginInfo();
                          });
                        }),
                        _buildActionButton('generateChangePINBlock', () async {
                          await performActionWithLoading(() async {
                            final res = await wepinPinPad!.generateChangePINBlock(context);
                            showSuccess('generateChangePINBlock result', res.toString(), buttonText: 'changePIN', buttonCallback: () async {
                              try {
                                final registerRes = await networkManager
                                    ?.changePin(ChangePinRequest(
                                    userId: userInfo!.userInfo!.userId,
                                    walletId: userInfo!.walletId!,
                                    UVD: res.uvd,
                                    newUVD: res.newUVD,
                                    hint: res.hint,
                                    otpCode: res.otp != null ? OtpCode(
                                        code: res.otp!,
                                        recovery: false
                                    ) : null
                                ));
                                showSuccess(
                                    'register result', registerRes.toString());
                              } catch(e) {
                                showError(e.toString());
                              }
                              await setLoginInfo();
                            });
                            await setLoginInfo();
                          });
                        }),
                        _buildActionButton('generateAuthOTP', () async {
                          await performActionWithLoading(() async {
                            final res = await wepinPinPad!.generateAuthOTP(context);
                            showSuccess('generateAuthOTP result', res.toString());
                            await setLoginInfo();
                          });
                        }),


                        _buildActionButton('Logout', () async {
                          await performActionWithLoading(() async {
                            await wepinPinPad!.login.logoutWepin();
                            await setLoginInfo();
                          });
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            ModalBarrier(color: Colors.black.withOpacity(0.5), dismissible: false),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      endDrawer: UserDrawer(
        userEmail: userEmail,
        wepinStatus: loginStatus,
        selectedLanguage: selectedLanguage!,
        selectedMode: selectedValue,
        sdkConfigs: sdkConfigs,
        currency: currency,
        onModeChanged: (value) {
          selectedValue = value;
          final selectedConfig = sdkConfigs.firstWhere((config) => config['name'] == value);
          _updateConfig(selectedConfig);
          initWepinSDK(selectedConfig['appId']!, selectedConfig['appKey']!, selectedConfig['privateKey']!);
        },
        onLanguageChanged: (value) {
          setState(() {
            selectedLanguage = value;
            if (wepinPinPad != null) {
              wepinPinPad?.changeLanguage(
                language: selectedLanguage,
                currency: currency[selectedLanguage]!,
              );
            }
          });
        },
      ),
    );
  }
}
