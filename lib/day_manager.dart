import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habu/__styles__.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/notification/routine_notifier.dart';
import 'package:habu/util/scheduler.dart';
import 'package:habu/util/timeofday_ext.dart';

class DayManager extends StatefulWidget {
  static const TextStyle baseStyle = TextStyles.h4;
  static final Map<String, TextStyle> styles = {
    'past': baseStyle.copyWith(color: ColorPalette.dark.withOpacity(0.2)),
    'active': baseStyle,
    'future': baseStyle.copyWith(color: ColorPalette.dark.withOpacity(0.5)),
  };

  const DayManager({
    Key? key,
    required this.routine,
    this.onRoutineAborted,
  }) : super(key: key);

  final Routine routine;
  final void Function()? onRoutineAborted;

  @override
  State<DayManager> createState() => _DayManagerState();
}

class _DayManagerState extends State<DayManager> {
  final RoutineNotifier notifier =
      RoutineNotifier('Habu', 'Habu', '@YanickZengaffinen');

  Timer? timer;

  @override
  void initState() {
    super.initState();
    notifier.schedule(widget.routine);

    timer = Scheduler.schedule(TimeOfDayExtension.nextMinute, () {
      timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        setState(() {});
      });
    });
  }

  void abortRoutine() {
    notifier.abort();
    timer?.cancel();
    widget.onRoutineAborted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Day'),
      ),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: buildOverview(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abortRoutine,
        tooltip: 'Abort this routine',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget buildOverview(BuildContext context) {
    return ListView.builder(
        key: UniqueKey(),
        itemCount: widget.routine.length,
        itemBuilder: (BuildContext ctxt, int index) =>
            buildListItem(ctxt, index));
  }

  Widget buildListItem(BuildContext context, int index) {
    RoutineItem item = widget.routine[index];
    switch (item.runtimeType) {
      case ActivityTemplateData:
        return renderActivity(context, item as ActivityTemplateData);
      case TaskTemplateData:
        return renderTask(context, item as TaskTemplateData);
      default:
        return const Text('Invalid routine item found');
    }
  }

  Widget renderActivity(BuildContext context, ActivityTemplateData activity) {
    TimeOfDay startTime = activity.startTime ?? TimeOfDayExtension.endOfDay;
    TimeOfDay endTime = activity.endTime ?? TimeOfDayExtension.startOfDay;
    String timeRelation = 'active';
    if (startTime > TimeOfDay.now()) {
      timeRelation = 'future';
    } else if (endTime < TimeOfDay.now()) {
      timeRelation = 'past';
    }

    return Row(
      key: UniqueKey(),
      children: [
        Expanded(
            flex: 1,
            child: Text(
              '${activity.title}',
              style: DayManager.styles[timeRelation],
            )),
        Expanded(
          flex: 3,
          child: Text(
            '(${activity.startTime?.format(context)} - ${activity.endTime?.format(context)})',
            style: DayManager.styles[timeRelation],
          ),
        ),
      ],
    );
  }

  Widget renderTask(BuildContext context, TaskTemplateData task) {
    TimeOfDay time = task.time ?? TimeOfDayExtension.endOfDay;
    String timeRelation = 'active';
    if (time > TimeOfDay.now()) {
      timeRelation = 'future';
    } else if (time < TimeOfDay.now()) {
      timeRelation = 'past';
    }

    return Row(
      key: UniqueKey(),
      children: [
        Expanded(
            flex: 1,
            child: Text(
              '${task.title}',
              style: DayManager.styles[timeRelation],
            )),
        Expanded(
          flex: 3,
          child: Text(
            '(${task.time?.format(context)})',
            style: DayManager.styles[timeRelation],
          ),
        ),
      ],
    );
  }
}
