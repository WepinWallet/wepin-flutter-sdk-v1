import 'package:flutter_test/flutter_test.dart';

import 'package:wepin_flutter_pin_pad/wepin_flutter_pin_pad.dart';

void main() {
  test('adds one to input values', () {
    final wepinPinPad = WepinPinPad(wepinAppId: '', wepinAppKey: '');
    expect(wepinPinPad.addOne(2), 3);
    expect(wepinPinPad.addOne(-7), -6);
    expect(wepinPinPad.addOne(0), 1);
  });
}
