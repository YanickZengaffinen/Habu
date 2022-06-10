import 'package:flutter/material.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/day_manager.dart';
import 'package:habu/routine_editor.dart';

void main() {
  runApp(const Habu());
}

class Habu extends StatefulWidget {
  const Habu({Key? key}) : super(key: key);

  @override
  State<Habu> createState() => _HabuState();
}

class _HabuState extends State<Habu> {
  Routine? selectedRoutine;

  void selectRoutine(Routine routine) {
    setState(() {
      selectedRoutine = routine;
    });
  }

  void abortRoutine() {
    setState(() {
      selectedRoutine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home = RoutineEditor(
      title: 'Select Or Plan a Routine For Today',
      onRoutineSubmitted: selectRoutine,
    );

    if (selectedRoutine != null) {
      home = DayManager(
        routine: selectedRoutine!,
        onRoutineAborted: abortRoutine,
      );
    }

    return MaterialApp(
      title: 'Habu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
    );
  }
}
