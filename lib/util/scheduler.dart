import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habu/util/timeofday_ext.dart';

typedef Action = void Function();

class Scheduler {
  static Timer? schedule(TimeOfDay time, Action action) {
    Duration duration = time.toDateTimeOfToday().difference(DateTime.now());
    if (duration.isNegative) return null;

    return Timer(duration, action);
  }

  static void abort(Timer timer) {
    timer.cancel();
  }
}
