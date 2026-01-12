import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileTimestampCache {
  static const String _cacheFileName = 'vault_file_timestamps.json';
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

  Future<Map<String, DateTime>> loadCache() async {
    await _init();
    if (_cacheFile == null || !await _cacheFile!.exists()) {
      return {};
    }

    try {
      final content = await _cacheFile!.readAsString();
      if (content.isEmpty) return {};

      final Map<String, dynamic> jsonMap = jsonDecode(content);
      final Map<String, DateTime> result = {};

      jsonMap.forEach((key, value) {
        if (value is String) {
          result[key] = DateTime.parse(value);
        }
      });

      Logger().d("Loaded timestamp cache with ${result.length} entries");
      return result;
    } catch (e) {
      Logger().e("Failed to load timestamp cache", error: e);
      return {};
    }
  }

  Future<void> saveCache(Map<String, DateTime> cache) async {
    await _init();
    if (_cacheFile == null) return;

    try {
      final Map<String, String> jsonMap = {};
      cache.forEach((key, value) {
        jsonMap[key] = value.toIso8601String();
      });

      await _cacheFile!.writeAsString(jsonEncode(jsonMap));
      // Logger().d("Saved timestamp cache with ${cache.length} entries");
    } catch (e) {
      Logger().e("Failed to save timestamp cache", error: e);
    }
  }
}
