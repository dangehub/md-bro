import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:obsi/src/core/ai_assistant/n8n_web_hook.dart';
import 'package:obsi/src/core/ai_assistant/tools/ai_filter_parser.dart';
import 'package:obsi/src/core/memos/memo.dart';
import 'package:obsi/src/core/memos/memo_parser.dart';
import 'package:obsi/src/core/storage/changed_files_storage.dart';
import 'package:obsi/src/core/storage/storage_interfaces.dart';
import 'package:obsi/src/core/tasks/task_manager.dart';
import 'package:obsi/src/core/tasks/task_parser.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';

class Tools {
  final TaskManager _taskManager;

  Tools(TaskManager taskManager) : _taskManager = taskManager;

  /// Get current date and time (no privacy data, no review required)
  Future<String> getCurrentTime() async {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(now);

    // Get weekday name in Chinese
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[now.weekday - 1];

    return "$dateStr ($weekday)";
  }

  /// Get tasks with optional filter
  /// filter syntax: scheduled:today status:todo tag:#work etc.
  Future<String> getTasksFiltered(String filter) async {
    try {
      final taskFilter = AIFilterParser.parseTaskFilter(filter);

      var content = "";
      var count = 0;
      for (var task in _taskManager.tasks) {
        if (taskFilter.matches(task)) {
          content += TaskParser().toTaskString(task);
          content += "\n";
          count++;
        }
      }

      if (count == 0) {
        return "没有找到符合条件的任务 (filter: $filter)";
      }

      return "找到 $count 个任务:\n$content";
    } catch (e) {
      return "Error:$e";
    }
  }

  /// Get memos with optional filter
  /// filter syntax: date:today limit:10 etc.
  Future<String> getMemosFiltered(String filter) async {
    try {
      final memoFilter = MemoFilterParser.parseMemoFilter(filter);
      final settings = SettingsController.getInstance();

      final vaultDir = settings.vaultDirectory ?? '';
      final memosPath = settings.memosPath ?? '';
      final isDynamic = settings.memosPathIsDynamic;

      if (vaultDir.isEmpty || memosPath.isEmpty) {
        return "Error: Memos path not configured";
      }

      // Parse all memos
      final allMemos = await MemoParser.parseAll(
        vaultDir: vaultDir,
        memosPath: memosPath,
        isDynamic: isDynamic,
      );

      // Filter memos by date
      List<Memo> filteredMemos = allMemos.where((memo) {
        return memoFilter.matches(memo.dateTime);
      }).toList();

      // Sort by datetime descending (newest first)
      filteredMemos.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      // Apply limit
      if (filteredMemos.length > memoFilter.limit) {
        filteredMemos = filteredMemos.take(memoFilter.limit).toList();
      }

      if (filteredMemos.isEmpty) {
        return "没有找到符合条件的 Memo (filter: $filter)";
      }

      // Format output
      var content = "找到 ${filteredMemos.length} 条 Memo:\n\n";
      for (var memo in filteredMemos) {
        final dateStr = DateFormat('yyyy-MM-dd').format(memo.dateTime);
        content += "[$dateStr ${memo.timeString}] ${memo.content}\n";
      }

      return content;
    } catch (e) {
      return "Error:$e";
    }
  }

  /// Legacy: Get all tasks (no filter)
  Future<String> getTasksTool() async {
    try {
      var content = "";
      for (var task in _taskManager.tasks) {
        content += TaskParser().toTaskString(task);
        if (_taskManager.tasks.length > 1) {
          content += "\n";
        }
      }
      return content;
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<String> getFileContentTool(String fileName) async {
    try {
      var file = _taskManager.storage.getFile(fileName);
      var content = await file.readAsString();
      return content;
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<String> writeFileContentTool(String fileName, String content) async {
    try {
      String filePath = fileName;
      if (!fileName.contains(_taskManager.vaultPath)) {
        var vaultPath = _taskManager.vaultPath;
        filePath = "$vaultPath/$fileName";
      }

      var file = _taskManager.storage.getFile(filePath);
      if (!await file.exists()) {
        await file.create();
      }

      await file.writeAsString(content);
    } catch (e) {
      return "Error:$e";
    }
    return "File saved successfully";
  }

  Future<String> renameFileTool(String oldFileName, String newFileName) async {
    try {
      //await _taskManager.storage.renameFile(oldFileName, newFileName);
    } catch (e) {
      return "Error:$e";
    }
    return "not implemented yet"; // "File renamed successfully";
  }

  Future<String> changeTaskTool(
      String oldTaskName, String newTaskContent) async {
    try {
      var tasks = _taskManager.tasks;
      var newTask = TaskParser().build(newTaskContent);
      var foundTask =
          tasks.firstWhere((task) => task.description!.startsWith(oldTaskName));
      newTask.taskSource = foundTask.taskSource;
      await _taskManager.saveTask(newTask);
    } catch (e) {
      return "Error:$e";
    }
    return "Task changed successfully";
  }

  Future<String> findTask(String taskName) async {
    try {
      var tasks = _taskManager.tasks;
      var foundTask = tasks.firstWhere((task) =>
          task.description!.toLowerCase().startsWith(taskName.toLowerCase()));
      return TaskParser().toTaskString(foundTask);
    } catch (e) {
      return "Error:Task not found";
    }
  }

  Future<String> httpPost(String uri, String param) async {
    try {
      var response = await n8nWebHook.post(uri, param);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.transform(utf8.decoder).join();
      } else {
        return "Failed request: ${response.statusCode}";
      }
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<String> httpGet(String uri) async {
    try {
      var response = await n8nWebHook.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.transform(utf8.decoder).join();
      } else {
        return "Failed request: ${response.statusCode}";
      }
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<String> getFileList() async {
    try {
      List<TasksFile> files;
      if (_taskManager.storage is ChangedFilesStorage) {
        var changedFilesStorage = _taskManager.storage as ChangedFilesStorage;
        files = await changedFilesStorage.wrapped
            .getAllFiles(_taskManager.vaultPath);
      } else {
        files = await _taskManager.storage.getAllFiles(_taskManager.vaultPath);
      }
      var result = files.join("\n");
      return result;
    } catch (e) {
      return "Error:$e";
    }
  }
}
