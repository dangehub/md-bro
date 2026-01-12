import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:obsi/src/core/tasks/task.dart';

class TasksCache {
  static const String _cacheFileName = 'vault_tasks_cache.json';
  File? _cacheFile;

  Future<void> _init() async {
    if (_cacheFile != null) return;
    try {
      final directory = await getApplicationSupportDirectory();
      _cacheFile = File(p.join(directory.path, _cacheFileName));
    } catch (e) {
      Logger().e("Failed to get cache directory", error: e);
    }
  }

  Future<List<Task>> loadTasks() async {
    await _init();
    if (_cacheFile == null || !await _cacheFile!.exists()) {
      return [];
    }

    try {
      final content = await _cacheFile!.readAsString();
      if (content.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content);
      final List<Task> tasks =
          jsonList.map((json) => Task.fromJson(json)).toList();

      Logger().d("Loaded cached tasks: ${tasks.length} items");
      return tasks;
    } catch (e) {
      Logger().e("Failed to load tasks cache", error: e);
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _init();
    if (_cacheFile == null) return;

    try {
      final List<Map<String, dynamic>> jsonList =
          tasks.map((task) => task.toJsonMap()).toList();

      // Use compute isolate for encoding if list is large?
      // For now, direct encoding.
      final String jsonString = jsonEncode(jsonList);

      await _cacheFile!.writeAsString(jsonString);
      // Logger().d("Saved tasks cache: ${tasks.length} items");
    } catch (e) {
      Logger().e("Failed to save tasks cache", error: e);
    }
  }

  Future<void> clear() async {
    await _init();
    if (_cacheFile != null && await _cacheFile!.exists()) {
      await _cacheFile!.delete();
    }
  }
}
