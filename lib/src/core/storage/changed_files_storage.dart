import 'package:logger/logger.dart';
import 'package:obsi/src/core/storage/file_timestamp_cache.dart';

import 'storage_interfaces.dart';
import 'dart:io';

class ChangedFilesStorage implements TasksFileStorage {
  final TasksFileStorage wrapped;
  String _path;
  final Map<String, DateTime> _lastModifiedTimes = {};
  final FileTimestampCache _cache = FileTimestampCache();
  bool _cacheLoaded = false;

  ChangedFilesStorage(this.wrapped) : _path = "";

  Future<void> _ensureCacheLoaded() async {
    if (!_cacheLoaded) {
      final cachedTimes = await _cache.loadCache();
      _lastModifiedTimes.addAll(cachedTimes);
      _cacheLoaded = true;
    }
  }

  @override
  Future<List<TasksFile>> getAllFiles(String path) async {
    // Determine if we need to reset the in-memory cache
    if (_path != path) {
      _lastModifiedTimes.clear();
      _cacheLoaded = false;
    }
    _path = path;

    await _ensureCacheLoaded();

    final allFiles = await wrapped.getAllFiles(_path);
    final changedFiles = <TasksFile>[];
    bool cacheDirty = false;

    for (final file in allFiles) {
      try {
        final lastModified = await File(file.path).lastModified();

        if (!_lastModifiedTimes.containsKey(file.path) ||
            _lastModifiedTimes[file.path]!.isBefore(lastModified)) {
          _lastModifiedTimes[file.path] = lastModified;
          changedFiles.add(file);
          cacheDirty = true;
        }
      } catch (e) {
        Logger()
            .e("Error checking file modification time: ${file.path}", error: e);
        changedFiles.add(file);
      }
    }

    Logger()
        .d("Changed files: ${changedFiles.length} (Total: ${allFiles.length})");

    if (cacheDirty) {
      await _cache.saveCache(_lastModifiedTimes);
    }

    return changedFiles;
  }

  Future<void> clearCache() async {
    _lastModifiedTimes.clear();
    // Force re-scan by pretending loaded but empty (or just clearing it is enough as getAllFiles checks containsKey)
    // To be safe, we just clear map. getAllFiles will repopulate and save.
    _cacheLoaded = true;
    // Also optional: clear disk cache?
    // await _cache.saveCache({});
    // But logic in getAllFiles will simply see files don't exist in map and add them.
  }

  Future<void> updateFileTimestamp(String path, DateTime time) async {
    await _ensureCacheLoaded();
    _lastModifiedTimes[path] = time;
    await _cache.saveCache(_lastModifiedTimes);
  }

  @override
  TasksFile getFile(String path) {
    return wrapped.getFile(path);
  }

  @override
  String? get todayFile => wrapped.todayFile;

  @override
  set todayFile(String? value) {
    wrapped.todayFile = value;
  }
}
