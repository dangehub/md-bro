import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:obsi/src/core/filename_date_extractor.dart';
import 'package:obsi/src/core/tasks/markdown_task_markers.dart';
import 'package:obsi/src/core/tasks/task.dart';
import 'package:obsi/src/core/tasks/task_source.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';
import 'package:tuple/tuple.dart';

class TaskParser extends MarkdownTaskMarkers {
  static const taskFeaturePattern = r'\[[^\]]*\]';

  TaskStatus _getStatus(source) {
    var statuses = {
      r'\[[A-Za-z]\]': TaskStatus.done,
      r'\[/\]': TaskStatus.inprogress,
      r'\[-\]': TaskStatus.cancelled
    };

    var found = statuses.entries.firstWhere(
        (element) => source.contains(RegExp(element.key)),
        orElse: () => const MapEntry("", TaskStatus.todo));
    return found.value;
  }

//pattern for time is either (@yyyy-MM-dd HH:mm) or (@yyyy-MM-dd) or (@HH:mm)
  Tuple2<DateTime?, String> _getScheduledDateTimeInReminderFormat(
      String source, DateTime? scheduledDate) {
    // Regex matches:
    // 1. (@yyyy-MM-dd HH:mm)
    // 2. (@yyyy-MM-dd)
    // 3. (@HH:mm)
    final RegExp timeRegex = RegExp(
        r'\(@((\d{4}-\d{2}-\d{2})( (\d{1,2}:\d{2}))?|(\d{1,2}:\d{2}))\)');
    final match = timeRegex.firstMatch(source);

    if (match != null) {
      String content = match.group(1)!;
      DateTime? dateTime;

      if (content.contains('-') && content.contains(':')) {
        // (@yyyy-MM-dd HH:mm)
        try {
          dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(content);
        } catch (e) {
          Logger().e("Error parsing reminder date time: $content");
        }
      } else if (content.contains('-')) {
        // (@yyyy-MM-dd) - Append default time
        try {
          String defaultTime =
              SettingsController.getInstance().defaultReminderTime;
          dateTime =
              DateFormat('yyyy-MM-dd HH:mm').parse("$content $defaultTime");
        } catch (e) {
          Logger().e("Error parsing reminder date only: $content");
        }
      } else if (content.contains(':')) {
        // (@HH:mm) - Attach to scheduled date if available
        if (scheduledDate != null) {
          try {
            DateTime time = DateFormat('HH:mm').parse(content);
            dateTime = DateTime(
              scheduledDate.year,
              scheduledDate.month,
              scheduledDate.day,
              time.hour,
              time.minute,
            );
          } catch (e) {
            Logger().e("Error parsing reminder time only: $content");
          }
        }
      }

      final updatedSource = source.replaceFirst(timeRegex, '');
      return Tuple2(dateTime, updatedSource);
    }

    return Tuple2(null, source);
  }

  /// Search for priority marker and if found it returns priority and found substring
  ///
  Tuple2<TaskPriority, String> _getPriority(source) {
    var found = MarkdownTaskMarkers.priorities.entries.firstWhere(
        (element) => source.contains(element.key),
        orElse: () => const MapEntry("", TaskPriority.normal));
    return Tuple2(found.value, found.key);
  }

  int _findFirstSpaceOrNewStringMarker(String source, int start) {
    var space = source.indexOf(' ', start);
    var newString = source.indexOf('\n', start);

    int end = -1;

    if (space >= 0) {
      if (newString >= 0) {
        end = space < newString ? space : newString;
      } else {
        end = space;
      }
    } else {
      end = newString;
    }

    end = end < 0 ? source.length : end;
    return end;
  }

  bool _isValidTime(String input) {
    final RegExp timeRegex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
    return timeRegex.hasMatch(input.trim());
  }

  /// Search for marker of reccurant task and if found it substring after marker
  Tuple2<String?, String> _extractRecurrenceRuleAfterMarker(
      String source, String marker) {
    var markerIndex = source.indexOf(marker);

    // Marker is not found or string is too short to be a valid recurrence rule
    if (markerIndex < 0 || markerIndex >= source.length - 2) {
      return Tuple2(null, source);
    }

    // Find the first symbol after marker which is not a space
    var start = source.indexOf(RegExp(r'[^\s]'), markerIndex + marker.length);
    if (start < 0 || start >= source.length - 2) {
      return Tuple2(null, source);
    }

    // Find the end of the recurrence rule
    var end = source.indexOf(RegExp(r'[^\w\s]'), start);
    if (end == -1) {
      end = source.length;
    }

    var recurrenceRule = source.substring(start, end).trim();
    var res = source.replaceRange(markerIndex, end, '');
    return Tuple2(recurrenceRule, res);
  }

  /// Search for marker and if found it return date and substring without marker and date
  Tuple2<DateTime?, String> _extractDateAfterMarker(
      String source, String marker,
      {bool tryReadTime = false}) {
    var markerIndex = source.indexOf(marker);

    //marker is not found or string is too short to be a valid date
    if (markerIndex < 0 || markerIndex >= source.length - 2) {
      return Tuple2(null, source);
    }

    //find the first symbol after marker which is not space
    var start = source.indexOf(RegExp(r'[^\s]'), markerIndex + marker.length);
    if (start < 0 || start >= source.length - 2) {
      return Tuple2(null, source);
    }
    var end = _findFirstSpaceOrNewStringMarker(source, start);
    var timeInitialized = false;
    if (tryReadTime && end + 1 < source.length) {
      var startIndex = end + 1;
      var newEnd = _findFirstSpaceOrNewStringMarker(source, startIndex);
      var probablyTime = source.substring(startIndex, newEnd);
      if (_isValidTime(probablyTime)) {
        end = newEnd;
        timeInitialized = true;
      }
    }

    var dateSubstring = source.substring(start, end);
    var date = DateTime.tryParse(dateSubstring);
    if (date != null && timeInitialized) {
      //set marker that time is pointed out for this file because no way to determine if time is set to 00:00 or not set all
      //when 1 second is set it is used as a marker that use set time (not only date)
      date = date.add(const Duration(seconds: 1));
    }

    var res = date != null ? source.replaceRange(markerIndex, end, '') : source;
    return Tuple2(date, res);
  }

  Tuple2<TaskStatus, String> _extractTaskFeature(String source) {
    String textOnly;

    var closeBracket = source.indexOf(']');

    //find the first symbol after marker which is not space
    var start = source.indexOf(RegExp(r'[^\s]'), closeBracket + 1);

    textOnly = source.substring(start);
    var featureOnly = source.substring(0, closeBracket + 1);
    TaskStatus status = _getStatus(featureOnly);
    return Tuple2(status, textOnly);
  }

  Task _fromString(TaskStatus? status, String source,
      {TaskSource? taskSource}) {
    String textOnly;
    if (status == null) {
      var taskFeature = _extractTaskFeature(source);
      status = taskFeature.item1;
      textOnly = taskFeature.item2;
    } else {
      textOnly = source;
    }

    var priority = _getPriority(source);
    textOnly = textOnly.replaceFirst(priority.item2, '');

    var createdDate = _extractDateAfterMarker(
        textOnly, MarkdownTaskMarkers.createdDateMarker);
    textOnly = createdDate.item2;

    var dueDate =
        _extractDateAfterMarker(textOnly, MarkdownTaskMarkers.dueDateMarker);
    textOnly = dueDate.item2;

    var startDate =
        _extractDateAfterMarker(textOnly, MarkdownTaskMarkers.startDateMarker);
    textOnly = startDate.item2;

    var scheduledDateRes = _extractDateAfterMarker(
        textOnly, MarkdownTaskMarkers.scheduledDateMarker,
        tryReadTime: true);
    textOnly = scheduledDateRes.item2;

    DateTime? scheduledDateTime = scheduledDateRes.item1;

    // Parse reminder independently
    // Note: If parsing (@HH:mm), we need the scheduled date to give it context.
    var reminderRes =
        _getScheduledDateTimeInReminderFormat(textOnly, scheduledDateTime);
    DateTime? reminderDateTime = reminderRes.item1;
    // Only update textOnly if we actually found a reminder OR matched a pattern
    // _getScheduledDateTimeInReminderFormat updates textOnly regardless of whether it returned a valid date (if it matched regex)
    // Wait, it returns updated source.
    textOnly = reminderRes.item2;

    var doneDate =
        _extractDateAfterMarker(textOnly, MarkdownTaskMarkers.doneDateMarker);
    textOnly = doneDate.item2;

    var cancelledDate = _extractDateAfterMarker(
        textOnly, MarkdownTaskMarkers.cancelledDateMarker);
    textOnly = cancelledDate.item2;
    var recurranceRule = _extractRecurrenceRuleAfterMarker(
        textOnly, MarkdownTaskMarkers.recurringDateMarker);
    textOnly = recurranceRule.item2;

    // 如果任务没有 scheduled 日期，尝试从文件名提取日期
    // 如果任务没有 scheduled 日期，尝试从文件名提取日期
    DateTime? finalScheduledDateTime = scheduledDateTime;
    bool inferredDate = false;
    if (finalScheduledDateTime == null && taskSource != null) {
      final fileDate =
          FilenameDateExtractor.extractDateFromPath(taskSource.fileName);
      if (fileDate != null) {
        finalScheduledDateTime = fileDate;
        inferredDate = true;
        Logger().d(
            'Inherited date from filename: ${taskSource.fileName} -> $fileDate');
      }
    }

    return Task(textOnly.trim(),
        status: status,
        priority: priority.item1,
        created: createdDate.item1,
        due: dueDate.item1,
        start: startDate.item1,
        scheduled: finalScheduledDateTime,
        scheduledTime: scheduledDateTime?.second == 1,
        isScheduledDateInferred: inferredDate,
        done: doneDate.item1,
        cancelled: cancelledDate.item1,
        recurranceRule: recurranceRule.item1,
        taskSource: taskSource,
        reminder: reminderDateTime);
  }

  Task build(String contentSource,
      {TaskStatus? status, TaskSource? taskSource}) {
    return _fromString(status, contentSource, taskSource: taskSource);
  }

  static var taskStatuses = {
    TaskStatus.todo: "[ ]",
    TaskStatus.inprogress: "[/]",
    TaskStatus.done: "[x]",
    TaskStatus.cancelled: "[-]"
  };

  String _saveDate(String marker, String inputFormat, DateTime? date) {
    if (date == null) {
      return "";
    }

    // var format = inputFormat;
    // // this is marker to save also time
    // if (date.second == 1) {
    //   format += " HH:mm";
    // }
    var formatedDate = DateFormat(inputFormat).format(date);
    String res = " $marker $formatedDate";
    return res;
  }

  String toTaskString(Task task,
      {String dateTemplate = "yyyy-MM-dd", String taskFilter = ""}) {
    var serializedTask = "- ${taskStatuses[task.status]} ";
    if (task.description != null) {
      serializedTask += task.description!;
      if (taskFilter.isNotEmpty) {
        serializedTask += " $taskFilter";
      }
    }

    // Add tags as hashtags
    if (task.tags.isNotEmpty) {
      final tagsString = task.tags.map((tag) => '#$tag').join(' ');
      serializedTask += ' $tagsString';
    }

    // Write reminder if exists
    if (task.reminder != null) {
      // Use standard format (@yyyy-MM-dd HH:mm)
      var reminderStr = DateFormat("yyyy-MM-dd HH:mm").format(task.reminder!);
      serializedTask += " (@$reminderStr)";
    }

    serializedTask += getPriorityMarker(task.priority);

    serializedTask += _saveDate(
        MarkdownTaskMarkers.createdDateMarker, dateTemplate, task.created);

    serializedTask +=
        _saveDate(MarkdownTaskMarkers.doneDateMarker, dateTemplate, task.done);
    serializedTask += _saveDate(
        MarkdownTaskMarkers.cancelledDateMarker, dateTemplate, task.cancelled);
    serializedTask +=
        _saveDate(MarkdownTaskMarkers.dueDateMarker, dateTemplate, task.due);

    serializedTask += _saveDate(
        MarkdownTaskMarkers.startDateMarker, dateTemplate, task.start);

    serializedTask += _saveDate(
        MarkdownTaskMarkers.scheduledDateMarker, dateTemplate, task.scheduled);

    if (task.recurrenceRule != null) {
      serializedTask +=
          " ${MarkdownTaskMarkers.recurringDateMarker} ${task.recurrenceRule}";
    }
    Logger().d("TaskParser.toTaskString: serializedTask: $serializedTask");
    return serializedTask;
  }

  DateTime? _setScheduledTime(DateTime? dateTime, bool scheduledTime) {
    if (dateTime == null) return null;

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      scheduledTime ? 1 : 0, // Set seconds to 0
      0, // Set milliseconds to 0 (optional)
    );
  }
}
