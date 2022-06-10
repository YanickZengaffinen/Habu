import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  bool operator <=(TimeOfDay other) => compareTo(other) <= 0;
  bool operator <(TimeOfDay other) => compareTo(other) < 0;
  bool operator >=(TimeOfDay other) => compareTo(other) >= 0;
  bool operator >(TimeOfDay other) => compareTo(other) > 0;

  DateTime toDateTimeOfToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static TimeOfDay get endOfDay {
    return const TimeOfDay(hour: 23, minute: 59);
  }

  static TimeOfDay get startOfDay {
    return const TimeOfDay(hour: 0, minute: 0);
  }

  static TimeOfDay get nextMinute {
    DateTime nowPlusOne = DateTime.now().add(const Duration(minutes: 1));
    return TimeOfDay(hour: nowPlusOne.hour, minute: nowPlusOne.minute);
  }
}
