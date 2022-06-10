import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habu/data/planner_data.dart';
import 'package:json_annotation/json_annotation.dart';

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null) return null;

    List<String> t = json.split(':');
    int h = int.parse(t[0]);
    int m = int.parse(t[1]);
    return TimeOfDay(hour: h, minute: m);
  }

  @override
  String? toJson(TimeOfDay? tod) {
    if (tod == null) return null;

    return '${tod.hour}:${tod.minute}';
  }
}

class RoutineItemConverter implements JsonConverter<RoutineItem, String> {
  const RoutineItemConverter();

  @override
  RoutineItem fromJson(String json) {
    if (json.contains('"type":"ActivityTemplateData"')) {
      return ActivityTemplateData.fromJson(jsonDecode(json));
    } else if (json.contains('"type":"TaskTemplateData"')) {
      return TaskTemplateData.fromJson(jsonDecode(json));
    }
    return RoutineItem();
  }

  @override
  String toJson(RoutineItem object) {
    return jsonEncode(object);
  }
}
