import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:habu/data/planner_data.dart';
import 'package:habu/storage/file_manager.dart';
import 'package:path/path.dart' as p;

class RoutineManager {
  static final String routineFolderPath = p.join('hubu', 'data', 'routines');
  const RoutineManager();

  Future<Routine> loadRoutine(String name) async {
    String path = await getFilePath(name);
    String? json = await FileManager.readFile(path);
    if (json == null) throw ErrorDescription('Error loading routine from json');

    return Routine.fromJson(jsonDecode(json));
  }

  void saveRoutine(String name, Routine routine) async {
    String path = await getFilePath(name);
    String json = jsonEncode(routine);
    FileManager.writeFile(path, json);
  }

  Future<bool> exists(String name) async {
    String path = await getFilePath(name);
    return FileManager.exists(path);
  }

  Future<List<String>> getAllRoutineNames() async {
    var paths = await FileManager.getFilesInFolder(await directoryPath);
    var names = paths.map((e) => e.split('.')[0]).toList();
    return names;
  }

  static Future<String> get directoryPath async =>
      p.join(await FileManager.directoryPath, routineFolderPath);

  static Future<String> getFilePath(String name) async =>
      p.join(await directoryPath, '$name.json');
}
