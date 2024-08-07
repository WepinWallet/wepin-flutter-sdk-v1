library wepin_flutter_common;

import 'package:package_info_plus/package_info_plus.dart';

class WepinCommon {
  static Future<String> getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }
  static String getBalanceWithDecimal(String balance, int decimals) {
    if (decimals == 0 || balance.isEmpty) return '0';

    BigInt balanceValue = BigInt.parse(balance);
    BigInt divisor = BigInt.from(10).pow(decimals);

    BigInt wholePart = balanceValue ~/ divisor;
    BigInt fractionalPart = balanceValue % divisor;

    // 필요한 만큼 소수 자릿수를 제한하거나 조정할 수 있습니다.
    int fractionalPartLength = divisor.toString().length - 1;
    String fractionalPartString = fractionalPart.toString().padLeft(fractionalPartLength, '0').substring(0, fractionalPartLength);

    // 소수점 이하의 값이 0인 경우 제거합니다.
    fractionalPartString = fractionalPartString.replaceFirst(RegExp(r'0+$'), '');

    if (fractionalPartString.isEmpty) {
      return wholePart.toString();
    } else {
      return '$wholePart.$fractionalPartString';
    }
  }
}
