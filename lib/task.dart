import 'package:flutter/material.dart';
import 'package:habu/__styles__.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/widgets/tap_to_edit_text.dart';

class Task extends StatefulWidget {
  const Task({Key? key, required this.initialTemplateData}) : super(key: key);

  final TaskTemplateData initialTemplateData;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late TaskTemplateData data;

  @override
  void initState() {
    super.initState();

    data = widget.initialTemplateData;
  }

  _selectTime(BuildContext context) async {
    TimeOfDay time = data.time ?? TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != time) {
      setState(() {
        data.time = timeOfDay;
      });
    }
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
              onSubmitted: (String value) {
                setState(() {
                  data.title = value;
                });
              },
              style: TextStyles.h4,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                TextButton.icon(
                    onPressed: () {
                      _selectTime(context);
                    },
                    icon: const Icon(Icons.timelapse),
                    label: Text(data.time?.format(context) ?? '')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
