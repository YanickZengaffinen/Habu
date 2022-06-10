import 'package:flutter/material.dart';
import 'package:habu/__styles__.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/util/timeofday_ext.dart';
import 'package:habu/widgets/dynamic_listview.dart';
import 'package:habu/widgets/text_dropdown.dart';
import 'package:habu/storage/routine_manager.dart';
import 'package:habu/widgets/tap_to_edit_text.dart';
import 'package:habu/task.dart';
import 'package:habu/activity.dart';

class RoutineEditor extends StatefulWidget {
  const RoutineEditor({
    Key? key,
    required this.title,
    required this.onRoutineSubmitted,
  }) : super(key: key);

  final String title;
  final void Function(Routine) onRoutineSubmitted;

  @override
  State<RoutineEditor> createState() => _RoutineEditorState();
}

class _RoutineEditorState extends State<RoutineEditor> {
  static const String emptyRoutineName = 'empty';

  final RoutineManager routineManager = const RoutineManager();

  List<String> allRoutines = [];
  String routineName = emptyRoutineName;
  Routine routine = Routine();

  @override
  void initState() {
    super.initState();

    reloadRoutines();
    reloadRoutine();
  }

  void setRoutine(String name) async {
    setState(() {
      routineName = name;
    });

    reloadRoutine();
  }

  void reloadRoutine() async {
    // need to always reset otherwise flutter uses the existing 0th listitem without overriding the values...
    setState(() {
      routine = Routine();
    });

    if (routineName == emptyRoutineName) return;

    if (await routineManager.exists(routineName)) {
      routineManager.loadRoutine(routineName).then(
        (Routine value) {
          setState(() {
            routine = value;
            routine.sort();
          });
        },
      );
    }
  }

  void reloadRoutines() async {
    var routineNames = await routineManager.getAllRoutineNames();
    routineNames.sort();
    if (!routineNames.contains(emptyRoutineName)) {
      routineNames.add(emptyRoutineName);
    }
    setState(() {
      allRoutines = routineNames;
    });
  }

  void save() async {
    routineManager.saveRoutine(routineName, routine);

    // reload the routine options after saving
    reloadRoutines();
  }

  void _addRoutineItem(String type) {
    RoutineItem newRoutine;
    switch (type) {
      case 'Activity':
        newRoutine = ActivityTemplateData('New Activity',
            TimeOfDayExtension.endOfDay, TimeOfDayExtension.endOfDay);
        break;
      case 'Task':
        newRoutine = TaskTemplateData('New Task', TimeOfDayExtension.endOfDay);
        break;
      default:
        return;
    }

    setState(() {
      routine.add(newRoutine);
      routine.sort();
    });
  }

  void _removeRoutineItem(int index) {
    setState(() {
      routine.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            Expanded(
              child: DynamicListView<RoutineItem>(
                key: UniqueKey(),
                elements: routine.list,
                elementTypes: const ['Activity', 'Task'],
                renderElement: renderRoutineItem,
                onAddElement: _addRoutineItem,
                onRemoveElement: _removeRoutineItem,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: save,
            tooltip: 'Return to Home',
            child: const Icon(Icons.arrow_back),
          ),
          FloatingActionButton(
            onPressed: save,
            tooltip: 'Save the current routine',
            child: const Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: () {
              widget.onRoutineSubmitted(routine);
            },
            tooltip: 'Choose the current routine for today',
            child: const Icon(Icons.check),
          )
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TapToEditText(
                key: UniqueKey(),
                style: TextStyles.h1,
                initialText: routineName,
                onSubmitted: (String? value) => setState(() {
                  routineName = value ?? emptyRoutineName;
                }),
              ),
            ),
            const Text(
              'Selected template: ',
              style: TextStyles.h5,
            ),
            TextDropdown(
              key: UniqueKey(),
              selectedOption: routineName,
              options: allRoutines,
              onChanged: (String? value) {
                setRoutine(value ?? emptyRoutineName);
              },
              textStyle: TextStyles.h5,
            ),
          ],
        ),
        const Divider(color: ColorPalette.dark),
      ],
    );
  }

  Widget renderRoutineItem(RoutineItem item) {
    Type type = item.runtimeType;
    switch (type) {
      case ActivityTemplateData:
        return Activity(
          key: UniqueKey(),
          initialTemplateData: item as ActivityTemplateData,
          onChanged: (ActivityTemplateData data) {
            setState(() {
              routine.sort();
            });
          },
        );
      case TaskTemplateData:
        return Task(
          key: UniqueKey(),
          initialTemplateData: item as TaskTemplateData,
        );
      default:
        return const Text('Wrong type of activity');
    }
  }
}
