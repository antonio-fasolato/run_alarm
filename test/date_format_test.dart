import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('Conversion from String to DateTime', () {
    var res = DateFormat("yyyy-MM-dd hh:mm:ss").parse('2024-03-07 21:19:29');

    expect(null != res, true);
  });

  test('Conversion from DateTime to String', () {
    var res = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    expect(null != res, true);
  });
}
