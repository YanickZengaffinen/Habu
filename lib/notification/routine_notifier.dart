import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/util/scheduler.dart';
import 'package:habu/util/timeofday_ext.dart';
import 'package:win_toast/win_toast.dart';

class RoutineNotifier {
  List<Timer> timers = [];

  RoutineNotifier(String appName, String productName, String companyName) {
    scheduleMicrotask(() async {
      final ret = await WinToast.instance().initialize(
        appName: appName,
        productName: productName,
        companyName: companyName,
      );
      assert(ret);
    });
  }

  void schedule(Routine routine) {
    for (RoutineItem item in routine.list) {
      _scheduleRoutineItem(item);
    }
  }

  void abort() {
    for (Timer timer in timers) {
      Scheduler.abort(timer);
    }
  }

  void _windowsNotification(
    ToastType type,
    String title, {
    String subtitle = '',
    String imagePath = '',
    List<String> actions = const <String>[],
  }) async {
    final toast = await WinToast.instance().showToast(
      type: type,
      title: title,
      subtitle: subtitle,
      imagePath: imagePath,
      actions: actions,
    );
    assert(toast != null);
  }

  void _scheduleRoutineItem(RoutineItem item) {
    switch (item.runtimeType) {
      case ActivityTemplateData:
        _scheduleActivity(item as ActivityTemplateData);
        break;
      case TaskTemplateData:
        _scheduleTask(item as TaskTemplateData);
        break;
      default:
    }
  }

  void _scheduleActivity(ActivityTemplateData activity) {
    TimeOfDay startTime = activity.startTime ?? TimeOfDayExtension.startOfDay;
    TimeOfDay endTime = activity.endTime ?? TimeOfDayExtension.endOfDay;

    Timer? startTimer = Scheduler.schedule(startTime, () {
      _windowsNotification(ToastType.text02, 'Start: ${activity.title}');
    });
    Timer? endTimer = Scheduler.schedule(endTime, () {
      _windowsNotification(ToastType.text02, 'Stop: ${activity.title}');
    });

    if (startTimer != null) {
      timers.add(startTimer);
    }
    if (endTimer != null) {
      timers.add(endTimer);
    }
  }

  void _scheduleTask(TaskTemplateData task) {
    TimeOfDay time = task.time ?? TimeOfDayExtension.startOfDay;
    Timer? timer = Scheduler.schedule(time, () {
      _windowsNotification(ToastType.text02, task.title ?? '');
    });
    if (timer != null) {
      timers.add(timer);
    }
  }
}
