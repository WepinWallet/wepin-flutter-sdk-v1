import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wepin_flutter_login_lib/type/wepin_flutter_login_lib_type.dart';
import 'package:wepin_flutter_login_lib/wepin_flutter_login_lib.dart';
import 'package:wepin_flutter_login_lib_example/value/sdk_app_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isBusy = false;
  // String wepinAppId = 'wepinAppId';
  // String wepinAppKey = Platform.isIOS? 'wepinAppKey_ios' : 'wepinAppKey_android';
  // String privateKey = 'privateKey';
  // String googleClientId = 'googleClientId';
  // String appleClientId = 'appleClientId';
  // String naverClientId = 'naverClientId';
  // String discordClientId = 'discordClientId';
  WepinLogin? wepinLogin;
  LoginResult? loginResult;
  String testIdToken = 'idToken';

  final List<String> items = [
    'init',
    'isInitialized',
    'loginWithOauthProvider(google)',
    'loginWithOauthProvider(apple)',
    'loginWithOauthProvider(naver)',
    'loginWithOauthProvider(discord)',
    'signUpWithEmailAndPassword',
    'loginWithEmailAndPassword',
    'loginWithIdToken',
    'loginWithAccessToken',
    'getRefreshFirebaseToken',
    'loginWepin',
    'getCurrentWepinUser',
    'logout',
    'getSignForLogin',
    'finalize',
  ];
  final Map<String, Future<dynamic> Function()> itemFunctions = {};

  String _selectedMessage = '';
  void _onItemTap(String item) async {
    try {
      _setBusyState();

      final function = itemFunctions[item];
      if (function != null) {
        final res = await function();
        setState(() {
          _selectedMessage = '$item is success: $res';
        });
      } else {
        setState(() {
          _selectedMessage = 'No function defined for $item';
        });
      }
      _clearBusyState();
    }catch(e){
      setState(() {
        _selectedMessage = '$item is failed: $e';
      });
      _clearBusyState();
    }
  }

  @override
  void initState() {
    super.initState();
    wepinLogin = WepinLogin(wepinAppKey: wepinAppKey, wepinAppId: wepinAppId);
    itemFunctions.addAll({
      'init': initWepinLogin,
      'isInitialized': () async => wepinLogin?.isInitialized(),
      'loginWithOauthProvider(google)': () async => loginOauthProvider('google', googleClientId),
      'loginWithOauthProvider(apple)': () async => loginOauthProvider('apple', appleClientId),
      'loginWithOauthProvider(naver)': () async => loginOauthProvider('naver', naverClientId),
      'loginWithOauthProvider(discord)': () async => loginOauthProvider('discord', discordClientId),
      'signUpWithEmailAndPassword': () async => await loginAndSetLoginResult(() async => wepinLogin?.singUpWithEmailAndPassword(email: 'dfcf1d28a921@drmail.in', password: r'abc1234!')),
      'loginWithEmailAndPassword': () async => await loginAndSetLoginResult(() async => await wepinLogin?.loginWithEmailAndPassword(email: 'dfcf1d28a921@drmail.in', password: r'abc1234!')),
      'loginWithIdToken': () async => loginAndSetLoginResult(() async => await wepinLogin?.loginWithIdToken(idToken: '', sign: wepinLogin!.getSignForLogin(privateKey: privateKey, message: ''))),
      'loginWithAccessToken': () async => await loginAndSetLoginResult(() async => await wepinLogin?.loginWithAccessToken(accessToken: '', provider: 'naver', sign: wepinLogin!.getSignForLogin(privateKey: privateKey, message: ''))),
      'getRefreshFirebaseToken': () async => await wepinLogin?.getRefreshFirebaseToken(),
      'loginWepin': () async => await loginWepin(),
      'getCurrentWepinUser': () async => await wepinLogin?.getCurrentWepinUser(),
      'logout': () async => await wepinLogin?.logoutWepin(),
      'getSignForLogin': () async => wepinLogin?.getSignForLogin(privateKey: privateKey, message: testIdToken),
      'finalize': () async => await wepinLogin?.finalize(),
    });
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
      _selectedMessage = 'processing....';
    });
  }

  Future<bool?> initWepinLogin() async {
    await wepinLogin?.init();
    return wepinLogin?.isInitialized();
  }
  Future<LoginResult?> loginOauthProvider(String provider, String clientId) async {
    final res = await wepinLogin?.loginWithOauthProvider(
        provider: provider, clientId: clientId);

    final sign = wepinLogin?.getSignForLogin(privateKey: privateKey, message: res!.token);
    LoginResult? resLogin;
    if(provider == 'naver' || provider == 'discord') {
      resLogin = await loginAndSetLoginResult(() async => await wepinLogin!.loginWithAccessToken(provider: provider, accessToken: res!.token, sign: sign!));
    } else {
      resLogin = await loginAndSetLoginResult(() async => await wepinLogin!.loginWithIdToken(idToken: res!.token, sign: sign!));
    }
    return resLogin;
  }

  Future<dynamic> loginAndSetLoginResult(Function function) async {
    final res = await function();
    setState(() {
      loginResult = res;
    });
    return res;
  }

  Future<dynamic> loginWepin() async {
    if(loginResult == null) return 'loginResult is null';
    final res = await wepinLogin?.loginWepin(loginResult!);
    setState(() {
      loginResult = null;
    });
    return res.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wepin Login Library Flutter Test'),
        ),
        // body: Center(
        //   child: Text('Running on: $_platformVersion\n'),
        // ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Visibility(
              visible: _isBusy,
              child: const LinearProgressIndicator(),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                // child: Text(
                //   'Wepin Login Library Flutter Test',
                //   style: TextStyle(fontSize: 24),
                // ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _onItemTap(items[index]),
                      child: ListTile(
                        title: Text(items[index]),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Test Result',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Text(
                    _selectedMessage,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
