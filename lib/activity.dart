import 'package:flutter/material.dart';
import 'package:habu/__styles__.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/widgets/tap_to_edit_text.dart';

class Activity extends StatefulWidget {
  const Activity({
    Key? key,
    required this.initialTemplateData,
    this.onChanged,
  }) : super(key: key);

  final ActivityTemplateData initialTemplateData;
  final ValueChanged<ActivityTemplateData>? onChanged;

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late ActivityTemplateData data;

  @override
  void initState() {
    super.initState();

    data = widget.initialTemplateData;
  }

  void _setTitle(String? title) async {
    setState(() {
      data.title = title;
    });

    widget.onChanged?.call(data);
  }

  void _selectStartTime(BuildContext context) async {
    TimeOfDay startTime = data.startTime ?? TimeOfDay.now();
    TimeOfDay endTime = data.endTime ?? TimeOfDay.now();

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != startTime) {
      if ((endTime.hour < startTime.hour) ||
          (endTime.hour == startTime.hour &&
              endTime.minute < startTime.minute)) {
        setState(() {
          data.startTime = timeOfDay;
          data.endTime = timeOfDay;
        });
      } else {
        setState(() {
          data.startTime = timeOfDay;
        });
      }
    }

    widget.onChanged?.call(data);
  }

  void _selectEndTime(BuildContext context) async {
    TimeOfDay endTime = data.endTime ?? TimeOfDay.now();

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: endTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != endTime) {
      setState(() {
        data.endTime = timeOfDay;
      });
    }

    widget.onChanged?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TapToEditText(
              initialText: data.title ?? '',
              onSubmitted: _setTitle,
              style: TextStyles.h4,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                TextButton.icon(
                    onPressed: () {
                      _selectStartTime(context);
                    },
                    icon: const Icon(Icons.timelapse),
                    label: Text(data.startTime?.format(context) ?? "")),
                const Text("-"),
                TextButton.icon(
                    onPressed: () {
                      _selectEndTime(context);
                    },
                    icon: const Icon(Icons.timelapse),
                    label: Text(data.endTime?.format(context) ?? "")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
