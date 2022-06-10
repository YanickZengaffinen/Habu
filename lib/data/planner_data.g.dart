// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<String, dynamic> json) => Routine()
  ..list = (json['list'] as List<dynamic>)
      .map((e) => const RoutineItemConverter().fromJson(e as String))
      .toList()
  ..length = json['length'] as int;

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'list': instance.list.map(const RoutineItemConverter().toJson).toList(),
      'length': instance.length,
    };

RoutineItem _$RoutineItemFromJson(Map<String, dynamic> json) => RoutineItem();

Map<String, dynamic> _$RoutineItemToJson(RoutineItem instance) =>
    <String, dynamic>{};

ActivityTemplateData _$ActivityTemplateDataFromJson(
        Map<String, dynamic> json) =>
    ActivityTemplateData(
      json['title'] as String?,
      const TimeOfDayConverter().fromJson(json['start_time'] as String?),
      const TimeOfDayConverter().fromJson(json['end_time'] as String?),
    )..type = json['type'] as String;

Map<String, dynamic> _$ActivityTemplateDataToJson(
        ActivityTemplateData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'start_time': const TimeOfDayConverter().toJson(instance.startTime),
      'end_time': const TimeOfDayConverter().toJson(instance.endTime),
    };

TaskTemplateData _$TaskTemplateDataFromJson(Map<String, dynamic> json) =>
    TaskTemplateData(
      json['title'] as String?,
      const TimeOfDayConverter().fromJson(json['time'] as String?),
    )..type = json['type'] as String;

Map<String, dynamic> _$TaskTemplateDataToJson(TaskTemplateData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'time': const TimeOfDayConverter().toJson(instance.time),
    };
