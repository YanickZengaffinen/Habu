import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habu/util/timeofday_ext.dart';

void main() {
  test(
    'Test TimeOfDay Extension',
    () {
      TimeOfDay before = const TimeOfDay(hour: 04, minute: 14);
      TimeOfDay after = const TimeOfDay(hour: 09, minute: 14);

      expect(before < after, true);
      expect(after < before, false);

      expect(before <= after, true);
      expect(after <= before, false);
      expect(after <= after, true);

      expect(before > after, false);
      expect(after > before, true);

      expect(before >= after, false);
      expect(after >= before, true);
      expect(after >= after, true);

      expect(before == after, false);
      expect(after == after, true);

      expect(before != after, true);
      expect(after != after, false);
    },
  );
}
