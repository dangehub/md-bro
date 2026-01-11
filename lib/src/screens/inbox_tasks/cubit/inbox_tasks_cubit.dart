import 'dart:io';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:obsi/src/core/notification_manager.dart';
import 'package:obsi/src/core/storage/storage_interfaces.dart';
import 'package:obsi/src/core/system_widget.dart';

import 'package:obsi/src/core/filter_list.dart';
import 'package:obsi/src/core/tasks/task.dart';
import 'package:obsi/src/core/tasks/task_manager.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';
import 'package:obsi/src/screens/settings/settings_service.dart';
import 'package:path/path.dart' as p;
part 'inbox_tasks_state.dart';

/// Represents a pending task status change that can be undone
class PendingStatusChange {
  final Task task;
  final TaskStatus oldStatus;
  final TaskStatus newStatus;
  final DateTime? oldDoneTime;
  final Timer timer;

  PendingStatusChange({
    required this.task,
    required this.oldStatus,
    required this.newStatus,
    required this.oldDoneTime,
    required this.timer,
  });

  void cancel() {
    timer.cancel();
  }
}

class InboxTasksCubit extends Cubit<InboxTasksState> {
  final TaskManager _taskManager;
  List<Task> _tasks = []; // Stores all tasks loaded from TaskManager
  TaskManager get taskManager => _taskManager;

  String searchQuery = "";
  final Set<String> _selectedTags = <String>{};
  final Set<String> _excludedTags = <String>{};
  int _taskDoneCount = 0;
  int _taskCount = 0;

  // Undo feature: pending status changes
  final Map<String, PendingStatusChange> _pendingChanges = {};
  Timer? _widgetUpdateTimer;

  // Filter Lists
  List<FilterList> availableFilters = [
    FilterList.upcoming(),
    FilterList.inbox(),
    FilterList.all(),
  ];
  FilterList currentFilterList = FilterList.upcoming();

  SortMode get sortMode => SettingsController.getInstance().sortMode;
  ViewMode get viewMode => SettingsController.getInstance().viewMode;
  // showOverdueOnly might be redundant with FilterList, but we keep it available if UI needs it or if we want to AND it.
  // For simplicity, FilterList takes precedence or works alongside.
  bool get showOverdueOnly => SettingsController.getInstance().showOverdueOnly;

  Set<String> get selectedTags => Set.from(_selectedTags);
  Set<String> get excludedTags => Set.from(_excludedTags);
  List<String> get availableTags => _taskManager.allTags;

  String get caption => currentFilterList.name;

  String get subcaption {
    var todayDate = DateFormat(SettingsController.getInstance().dateTemplate)
        .format(DateTime.now());
    return currentFilterList.id == 'recent' ||
            currentFilterList.id == 'today' // if we had today
        ? "$todayDate\nTasks: $_taskDoneCount/$_taskCount"
        : "Tasks: $_taskDoneCount/$_taskCount";
  }

  InboxTasksCubit(TaskManager taskManager)
      : _taskManager = taskManager,
        super(InboxTasksLoading(
            SettingsController.getInstance().vaultDirectory!)) {
    _init();
    SettingsController.getInstance().addListener(_onSettingsChanged);

    if (_taskManager.status == TaskManagerStatus.loaded) {
      tasksChangedListener();
    }

    _taskManager.addListener(tasksChangedListener);
  }

  void _onSettingsChanged() {
    _refreshAvailableFilters();
    refreshTasks();
  }

  void _init() {
    _refreshAvailableFilters();

    // Load persisted filter selection
    final savedFilterId = SettingsController.getInstance().activeFilterId;
    if (savedFilterId != null) {
      try {
        currentFilterList = availableFilters.firstWhere(
            (f) => f.id == savedFilterId,
            orElse: () => FilterList.upcoming());
      } catch (e) {
        currentFilterList = FilterList.upcoming();
      }
    } else {
      currentFilterList = FilterList.upcoming();
    }
  }

  void _refreshAvailableFilters() {
    availableFilters = SettingsController.getInstance().filters;

    // If current filter was removed (e.g. custom filter deleted), revert to recent
    // But we need to check if currentFilterList is still valid
    if (!availableFilters.any((f) => f.id == currentFilterList.id)) {
      // If filter was deleted, switch to Recent
      if (currentFilterList.id != 'recent') {
        // Prevent loop if recent missing somehow
        selectFilterList(FilterList.upcoming());
      }
    }
  }

  @override
  Future<void> close() {
    SettingsController.getInstance().removeListener(_onSettingsChanged);
    _taskManager.removeListener(tasksChangedListener);
    return super.close();
  }

  void selectFilterList(FilterList filterList) {
    if (currentFilterList.id == filterList.id) return;
    currentFilterList = filterList;
    SettingsController.getInstance().updateActiveFilterId(filterList.id);
    _applySearchFilter();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    _applySearchFilter();
  }

  void toggleTag(String tag) {
    if (_excludedTags.contains(tag)) {
      _excludedTags.remove(tag);
    }

    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _applySearchFilter();
  }

  void toggleExcludeTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    }

    if (_excludedTags.contains(tag)) {
      _excludedTags.remove(tag);
    } else {
      _excludedTags.add(tag);
    }
    _applySearchFilter();
  }

  void clearTagFilter() {
    _selectedTags.clear();
    _excludedTags.clear();
    _applySearchFilter();
  }

  void _updateView(List<Task> tasks) {
    if (taskManager.lastError != null) {
      emit(InboxTasksMessage(taskManager.lastError.toString(), []));
      taskManager.lastError = null;
    } else {
      emit(InboxTasksList(tasks));
    }
  }

  void _applySearchFilter() {
    int taskDoneCount = 0;

    // Always work on ALL tasks from TaskManager
    var sourceTasks = _tasks;

    if (sourceTasks.isEmpty) {
      if (taskManager.status != TaskManagerStatus.loaded) {
        return;
      }
      Logger().d("_applySearchFilter: _tasks is empty");
      _updateView([]);
      return;
    }

    var filteredTasks = sourceTasks.where((task) {
      // 1. Apply FilterList criteria
      if (!currentFilterList.matches(task)) {
        return false;
      }

      // 2. Count done tasks (within this filter scope?)
      // Original logic counted done tasks in `_tasks`.
      // If we filter by FilterList first, we count done matching logic.
      if (task.status == TaskStatus.done) {
        taskDoneCount++;
      }

      // 3. Search Query
      var description = task.description ?? "";
      var fileName = task.taskSource?.fileName ?? "";
      fileName = p.basenameWithoutExtension(fileName);
      bool matchesQuery =
          description.toLowerCase().contains(searchQuery.toLowerCase()) ||
              (viewMode == ViewMode.file &&
                  fileName.toLowerCase().contains(searchQuery.toLowerCase()));

      // 4. Tags
      bool matchesTags = true;
      if (_selectedTags.isNotEmpty) {
        matchesTags =
            _selectedTags.any((selectedTag) => task.tags.contains(selectedTag));
      }

      bool notExcluded = true;
      if (_excludedTags.isNotEmpty) {
        notExcluded = !_excludedTags
            .any((excludedTag) => task.tags.contains(excludedTag));
      }

      // 5. Overdue (Legacy setting)
      // If user enabled "Show Overdue Only", AND filter list allows it.
      // E.g. Recent includes overdue. Inbox excludes.
      // If Inbox, filterList logic already excluded overdue (via noDate).
      // So checking showOverdueOnly (force overdue) might result in empty for Inbox.
      // We will apply this logic as an additional AND.
      if (showOverdueOnly) {
        var taskState = TaskManager.getTaskScheduleState(task) !=
            TaskScheduleState.none; // None means not overdue (none/dueToday) ?
        // Wait, getTaskScheduleState returns overdue, dueToday, none.
        // If showOverdueOnly means "Show Scheduled/Due tasks"?
        // Original code: `taskState != TaskScheduleState.none`.
        // TaskScheduleState has: none, dueToday, overdue.
        // So this filters out tasks WITHOUT schedule/due.
        // But "showOverdueOnly" setting name implies Overdue only.
        // Let's assume original intention was "Show Active/Timed Tasks".
        // We keep logic same.
        matchesQuery = matchesQuery && taskState;
      }

      return matchesQuery && matchesTags && notExcluded;
    }).toList();

    // 6. Apply Sorting
    if (currentFilterList.sortRules.isNotEmpty) {
      filteredTasks.sort((a, b) {
        for (var rule in currentFilterList.sortRules) {
          int cmp = 0;
          switch (rule.field) {
            case SortField.alphabetical:
              cmp = (a.description ?? "").compareTo(b.description ?? "");
              break;
            case SortField.dueDate:
              cmp = _compareDates(a.due, b.due);
              break;
            case SortField.scheduledDate:
              // For scheduled, maybe consider inferred? using a.scheduled directly
              cmp = _compareDates(a.scheduled, b.scheduled);
              break;
            case SortField.createdDate:
              cmp = _compareDates(a.created, b.created);
              break;
            case SortField.priority:
              // Enum order: lowest(0) -> highest(5).
              // Ascending: 0->5. Descending: 5->0.
              cmp = a.priority.index.compareTo(b.priority.index);
              break;
            case SortField.status:
              cmp = a.status.index.compareTo(b.status.index);
              break;
          }
          if (cmp != 0) {
            return rule.direction == SortDirection.ascending ? cmp : -cmp;
          }
        }
        return 0; // All rules equal
      });
    } else {
      // Fallback to legacy SortMode
      filteredTasks.sort((a, b) => _compareTasksLegacy(a, b, sortMode));
    }

    _taskDoneCount = taskDoneCount;
    _taskCount = filteredTasks.length;
    _updateView(filteredTasks);
  }

  void tasksChangedListener() {
    Logger().i("Tasks changed listener called");

    // Always schedule notifications for all tasks (now handling all tasks in manager)
    _scheduleNotifications(_taskManager.tasks);

    // Delay widget update
    // If we have pending undo changes, wait 6 seconds (to cover the 5s undo window + buffer)
    // Otherwise update quickly (500ms debounce)
    _widgetUpdateTimer?.cancel();
    int delaySeconds = _pendingChanges.isNotEmpty ? 6 : 1;

    _widgetUpdateTimer = Timer(Duration(seconds: delaySeconds), () {
      if (Platform.isAndroid) {
        HomeWidgetHandler.updateWidget(_taskManager.tasks);
      }
    });

    // Load ALL tasks
    // _taskManager.tasks getter returns a list copy.
    _tasks = _taskManager.tasks;
    _applySearchFilter();
  }

  /// Change task status with 5-second undo window
  /// Returns the taskId that can be used to undo
  String changeTaskStatusWithUndo(Task task, TaskStatus newStatus) {
    final taskId = task.taskSource?.id.toString() ??
        task.description ??
        DateTime.now().toString();
    final oldStatus = task.status;
    final oldDoneTime = task.done;

    // Cancel any existing pending change for this task
    if (_pendingChanges.containsKey(taskId)) {
      _pendingChanges[taskId]!.cancel();
      _pendingChanges.remove(taskId);
    }

    // 1. Optimistic UI update (Defered!)
    // We DO NOT update task.status here to prevent it from jumping in the list
    // if the list is sorted/grouped by status.
    // The UI (TaskCard) must handle the visual state based on PendingStatusChange.

    // Refresh UI to show pending state
    _applySearchFilter();

    // 2. Create delayed commit timer
    final timer = Timer(const Duration(seconds: 5), () {
      _commitStatusChange(taskId);
    });

    // 3. Store pending change
    _pendingChanges[taskId] = PendingStatusChange(
      task: task,
      oldStatus: oldStatus,
      newStatus: newStatus,
      oldDoneTime: oldDoneTime,
      timer: timer,
    );

    // 4. Get filtered tasks for state
    var filteredTasks = _getFilteredTasks();

    // 5. Emit undo available state
    emit(InboxTasksUndoAvailable(
      tasks: filteredTasks,
      taskId: taskId,
      taskDescription: task.description ?? '',
      wasCompleted: newStatus == TaskStatus.done,
    ));

    return taskId;
  }

  /// Undo a pending task status change
  void undoTaskStatusChange(String taskId) {
    final pending = _pendingChanges.remove(taskId);
    if (pending != null) {
      pending.cancel();
      // No need to revert task.status as it wasn't changed yet!
      _applySearchFilter();
      Logger().i('Task status change undone for: ${pending.task.description}');
    }
  }

  /// Commit a pending status change to storage
  void _commitStatusChange(String taskId) {
    final pending = _pendingChanges.remove(taskId);
    if (pending != null) {
      // Now we actually update the task
      pending.task.status = pending.newStatus;
      if (pending.newStatus == TaskStatus.done) {
        pending.task.done = DateTime.now();
      } else {
        pending.task.done = null;
      }

      // Handle completion actions
      if (pending.newStatus == TaskStatus.done) {
        switch (currentFilterList.completionAction) {
          case TaskCompletionAction.delete:
            _taskManager.deleteTask(pending.task);
            return;
          case TaskCompletionAction.archive:
            _taskManager.archiveTask(pending.task);
            return;
          case TaskCompletionAction.keep:
          default:
            break;
        }
      }

      // Save to storage
      _taskManager.setStatus(pending.task, pending.newStatus);
      Logger().i(
          'Task status committed: ${pending.task.description} -> ${pending.newStatus}');

      // Refresh UI to reflect final state (might move task now)
      _applySearchFilter();

      // If we are on Android, update widget now
      if (Platform.isAndroid) {
        HomeWidgetHandler.updateWidget(_taskManager.tasks);
      }
    }
  }

  /// Get currently filtered tasks (helper for state emission)
  List<Task> _getFilteredTasks() {
    return _tasks.where((task) {
      // Check if task is pending undo
      final taskId = task.taskSource?.id.toString() ?? task.description ?? '';
      if (_pendingChanges.containsKey(taskId)) {
        // Always include pending undo tasks regardless of filter status (e.g. done status)
        // But still respect search query
        var description = task.description ?? "";
        return description.toLowerCase().contains(searchQuery.toLowerCase());
      }

      if (!currentFilterList.matches(task)) return false;
      var description = task.description ?? "";
      return description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  /// Legacy method - immediate status change without undo
  Future changeTaskStatus(Task task, TaskStatus status) async {
    if (status == TaskStatus.done) {
      task.done = DateTime.now();

      // Apply Completion Action
      switch (currentFilterList.completionAction) {
        case TaskCompletionAction.delete:
          await _taskManager.deleteTask(task);
          return;
        case TaskCompletionAction.archive:
          task.status = status; // Ensure status is updated before archiving
          await _taskManager.archiveTask(task);
          return;
        case TaskCompletionAction.keep:
        default:
          break;
      }
    } else {
      task.done = null;
    }

    _taskManager.setStatus(task, status);
    // Notification update is handled via listener which calls _scheduleNotifications
  }

  // Settings Updates
  Future<void> updateShowOverdueTasksOnly(bool val) async {
    await SettingsController.getInstance().updateShowOverdueOnly(val);
    _applySearchFilter();
  }

  Future<void> updateViewMode(ViewMode val) async {
    await SettingsController.getInstance().updateViewMode(val);
    _applySearchFilter();
  }

  Future<void> updateSortMode(SortMode val) async {
    await SettingsController.getInstance().updateSortMode(val);
    _applySearchFilter();
  }

  void refreshTasks() {
    var settings = SettingsController.getInstance();
    taskManager.dateTemplate = settings.dateTemplate;
    taskManager.includeDueTasksInToday = settings.includeDueTasksInToday;
    taskManager.storage = TasksFileStorage.getInstance();
    var vaultDirectory = settings.vaultDirectory;

    if (vaultDirectory != null) {
      emit(InboxTasksLoading(vaultDirectory));
      _taskManager.loadTasks(vaultDirectory,
          taskFilter: settings.globalTaskFilter);
    }
  }

  void removeFromTodayPressed(Task task) {
    if (_taskManager.includeDueTasksInToday &&
        TaskManager.sameDate(task.due, DateTime.now())) {
      Logger().d('Task not removed from today because it is due today');
      emit(InboxTasksMessage(
        'Task cannot be removed from today because it is due today',
        _tasks, // Should pass filtered? Original passed _tasks. State message typically transient.
      ));
      return;
    }
    _taskManager.removeFromToday(task);
  }

  void assignForTodayPressed(Task task) {
    _taskManager.scheduleForToday(task);
  }

  Future<void> _scheduleNotifications(List<Task> tasks) async {
    var notificationManager = NotificationManager.getInstance();
    if (!await notificationManager.notificationPermissionGranted()) return;

    await notificationManager.cancelAllNotifications();
    for (var task in tasks) {
      if (task.scheduledTime &&
          task.scheduled != null &&
          task.description != null &&
          task.status != TaskStatus.done &&
          task.scheduled!.isAfter(DateTime.now())) {
        var notificationId = task.taskSource?.id ?? 0;
        await notificationManager.createScheduledNotification(
            scheduledDate: task.scheduled!,
            text: task.description!,
            notificationId: notificationId);
      }
    }

    // Reminders
    var reviewTasksReminderTime =
        SettingsController.getInstance().reviewTasksReminderTime;
    var reviewCompletedReminderTime =
        SettingsController.getInstance().reviewCompletedReminderTime;

    if (reviewTasksReminderTime != null) {
      await SettingsController.getInstance()
          .updateReviewTasksReminderTime(reviewTasksReminderTime);
    }
    if (reviewCompletedReminderTime != null) {
      await SettingsController.getInstance()
          .updateReviewCompletedReminderTime(reviewCompletedReminderTime);
    }
  }

  int _compareDates(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1; // Null is "larger" -> End of list (for ASC)
    if (b == null) return -1;
    return a.compareTo(b);
  }

  int _compareTasksLegacy(Task a, Task b, SortMode mode) {
    switch (mode) {
      case SortMode.byCreationDate:
        return _compareDates(a.created, b.created);
      case SortMode.none:
        return 0; // Maintain original order
    }
  }
}
