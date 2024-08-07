import 'package:flutter_test/flutter_test.dart';

import 'package:wepin_flutter_storage/wepin_flutter_storage.dart';

void main() {
  test('wepinStorage appId', () {
    final wepinStorage = WepinStorage(appId: '');
    expect(wepinStorage.appId, '');
  });
}
