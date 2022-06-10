import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static Future<String> get directoryPath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String?> readFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      try {
        return await file.readAsString();
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    return null;
  }

  static void writeFile(String path, String text) async {
    var file = File(path);

    if (!await file.exists()) await file.create(recursive: true);

    try {
      file.writeAsString(text);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<List<String>> getFilesInFolder(String path) async {
    var dir = Directory(path);
    var list = await dir.list().toList();
    return list.whereType<File>().map((e) => e.path).map(basename).toList();
  }

  static Future<bool> exists(String path) async {
    File file = File(path);
    return file.exists();
  }
}
