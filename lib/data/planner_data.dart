import 'package:flutter/material.dart';
import 'package:habu/storage/json_converters.dart';
import 'package:habu/util/timeofday_ext.dart';
import 'package:json_annotation/json_annotation.dart';

part 'planner_data.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
@RoutineItemConverter()
// Wrapper for List<RoutineItem> to support the dynamic way
class Routine {
  List<RoutineItem> list = [];

  Routine();

  // Sorts the list by starting time
  void sort({bool reverse = false}) {
    list.sort((RoutineItem a, RoutineItem b) {
      if (reverse) {
        RoutineItem t = a;
        a = b;
        b = t;
      }

      TimeOfDay aVal = _getTimeSortingValue(a);
      TimeOfDay bVal = _getTimeSortingValue(b);

      return aVal.compareTo(bVal);
    });
  }

  TimeOfDay _getTimeSortingValue(RoutineItem item) {
    switch (item.runtimeType) {
      case ActivityTemplateData:
        return (item as ActivityTemplateData).startTime ??
            TimeOfDayExtension.startOfDay;
      case TaskTemplateData:
        return (item as TaskTemplateData).time ?? TimeOfDayExtension.startOfDay;
      default:
        return TimeOfDayExtension.startOfDay;
    }
  }

  factory Routine.fromJson(Map<String, dynamic> json) =>
      _$RoutineFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineToJson(this);

  int get length => list.length;

  set length(int length) {
    list.length = length;
  }

  RoutineItem operator [](int index) => list[index];

  void operator []=(int index, RoutineItem value) {
    list[index] = value;
  }

  void add(RoutineItem value) {
    list.add(value);
  }

  void removeAt(int index) {
    list.removeAt(index);
  }
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
@TimeOfDayConverter()
class RoutineItem {
  RoutineItem();

  factory RoutineItem.fromJson(Map<String, dynamic> json) =>
      _$RoutineItemFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineItemToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
@TimeOfDayConverter()
class ActivityTemplateData extends RoutineItem {
  String type = "ActivityTemplateData";

  String? title;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  ActivityTemplateData(this.title, this.startTime, this.endTime);

  factory ActivityTemplateData.fromJson(Map<String, dynamic> json) =>
      _$ActivityTemplateDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ActivityTemplateDataToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
@TimeOfDayConverter()
class TaskTemplateData extends RoutineItem {
  String type = "TaskTemplateData";

  String? title;
  TimeOfDay? time;

  TaskTemplateData(this.title, this.time);

  factory TaskTemplateData.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TaskTemplateDataToJson(this);
}
