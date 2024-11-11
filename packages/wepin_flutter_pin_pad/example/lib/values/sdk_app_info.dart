import 'dart:io';

final List<Map<String, String>> sdkConfigs = [
  {
    'name': 'sample app',
    'appId': 'wepin-app-id',
    'appKey': Platform.isIOS ? 'wepin-app-key-ios': 'wepin-app-key-android',
    'privateKey': 'wepin-oauth-private-key',
    'googleClientId': 'google-client-id',
    'appleClientId': 'ios-client-id',
    'discordClientId': 'discord-client-id',
    'naverClientId': 'naver-client-id',
  },
];