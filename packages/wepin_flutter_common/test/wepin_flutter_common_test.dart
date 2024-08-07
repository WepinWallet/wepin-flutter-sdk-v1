import 'package:flutter_test/flutter_test.dart';
import 'package:wepin_flutter_common/wepin_error.dart';

import 'package:wepin_flutter_common/wepin_flutter_common.dart';
import 'package:wepin_flutter_common/wepin_url.dart';

void main() {
  test('getPackageName',  () async {
    final info = await WepinCommon.getPackageName();
    expect(info.isNotEmpty, true);
  });
  test('wepin url', () async {
    expect(getWepinSdkUrl('abc'), throwsA(isA<WepinError>()));
  });
}
