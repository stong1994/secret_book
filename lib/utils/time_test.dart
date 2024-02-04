import 'package:test/test.dart';

import 'time.dart';

void main() {
  group('nowStr', () {
    test('should return the current date and time in the correct format', () {
      String result = nowStr();
      var expectedFormat = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$');
      expect(result, matches(expectedFormat));
    });

    test(
        'should return the current date and time with leading zeros for single-digit values',
        () {
      String result = nowStr();
      var expectedFormat = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$');
      expect(result, matches(expectedFormat));
    });
  });

  group('_twoDigits', () {
    test('should return the same number if it is greater than or equal to 10',
        () {
      var result = twoDigits(15);
      expect(result, '15');
    });

    test('should return the number with a leading zero if it is less than 10',
        () {
      var result = twoDigits(5);
      expect(result, '05');
    });
  });
}
