import 'package:obsi/src/core/tasks/task_source.dart';

enum TaskStatus { todo, done, inprogress, cancelled }

enum TaskPriority { lowest, low, normal, medium, high, highest }

class Task implements Comparable<Task> {
  bool _changed = false;
  String? _description;
  List<String> _tags = [];
  TaskStatus _status;
  TaskPriority _priority;
  DateTime? _created;
  DateTime? _done;
  DateTime? _cancelled;
  DateTime? _due;
  DateTime? _start;
  DateTime? _scheduled;
  bool _scheduledTime;
  bool _isScheduledDateInferred;
  TaskSource? taskSource;
  String? _recurrenceRule = "";
  DateTime? _reminder;

  bool get changed => _changed;

  String? get description => _description;
  set description(String? val) {
    _changed = true;
    _description = val;
    _parseTags();
  }

  List<String> get tags => List.unmodifiable(_tags);
  set tags(List<String> val) {
    _changed = true;
    _tags = List.from(val);
  }

  String? get recurrenceRule => _recurrenceRule;
  set recurrenceRule(String? val) {
    _changed = true;
    _recurrenceRule = val;
  }

  TaskStatus get status => _status;
  set status(TaskStatus val) {
    _changed = true;
    _status = val;
  }

  TaskPriority get priority => _priority;
  set priority(TaskPriority val) {
    _changed = true;
    _priority = val;
  }

  DateTime? get created => _created;
  set created(DateTime? created) {
    _changed = true;
    _created = created;
  }

  DateTime? get done => _done;
  set done(DateTime? done) {
    _changed = true;
    _done = done;
  }

  DateTime? get cancelled => _cancelled;
  set cancelled(DateTime? cancelled) {
    _changed = true;
    _cancelled = cancelled;
  }

  DateTime? get due => _due;
  set due(DateTime? due) {
    _changed = true;
    _due = due;
  }

  DateTime? get start => _start;
  set start(DateTime? start) {
    _changed = true;
    _start = start;
  }

  DateTime? get scheduled => _scheduled;
  set scheduled(DateTime? scheduled) {
    _changed = true;
    _scheduled = scheduled;
  }

  bool get scheduledTime => _scheduledTime;
  set scheduledTime(bool val) {
    _changed = true;
    _scheduledTime = val;
  }

  bool get isScheduledDateInferred => _isScheduledDateInferred;
  set isScheduledDateInferred(bool val) {
    _changed = true;
    _isScheduledDateInferred = val;
  }

  DateTime? get reminder => _reminder;
  set reminder(DateTime? val) {
    _changed = true;
    _reminder = val;
  }

  /// Parses hashtags from the description, stores them in tags array, and cleans description
  void _parseTags() {
    //   _tags.clear();
    if (_description != null && _description!.isNotEmpty) {
      // Capture tags as a sequence starting with '#' up to the next space.
      // Avoid matching inside words by ensuring '#' is at start or preceded by whitespace.
      // Example: "Do #tag-1, #another" -> captures "tag-1," and "another" (until space).
      final RegExp tagRegex = RegExp(r'(?<!\S)#(\S+)');

      final Iterable<RegExpMatch> matches = tagRegex.allMatches(_description!);
      var tags = matches.map((match) => match.group(1)!).toSet().toList();

      // Remove hashtags from description
      _description = _description!.replaceAll(tagRegex, ' ').trim();
      // Clean up multiple spaces that might result from tag removal
      _description = _description!.replaceAll(RegExp(r'\s+'), ' ').trim();
      _tags.addAll(tags);
    }
  }

  Task(
    this._description, {
    status = TaskStatus.todo,
    priority = TaskPriority.normal,
    created,
    done,
    cancelled,
    due,
    scheduled,
    scheduledTime = false,
    bool isScheduledDateInferred = false,
    start,
    this.taskSource,
    recurranceRule,
    List<String>? tags,
    DateTime? reminder,
  })  : _status = status,
        _priority = priority,
        _created = created,
        _done = done,
        _cancelled = cancelled,
        _due = due,
        _scheduled = scheduled,
        _start = start,
        _scheduledTime = scheduledTime,
        _isScheduledDateInferred = isScheduledDateInferred,
        _recurrenceRule = recurranceRule,
        _reminder = reminder {
    if (tags != null) {
      _tags.addAll(tags);
    }
    _parseTags();
  }

  @override
  String toString() {
    return "Status: $status\nDescription: $description\nSource: $taskSource";
  }

  @override
  int compareTo(Task other) {
    if (taskSource != null && other.taskSource != null) {
      return taskSource!.fileNumber.compareTo(other.taskSource!.fileNumber);
    } else {
      return 0;
    }
  }

  bool equals(Task other) {
    return _description == other._description &&
        //_status == other._status &&
        _priority == other._priority &&
        _created == other._created &&
        _done == other._done &&
        _cancelled == other._cancelled &&
        _due == other._due &&
        _start == other._start &&
        _scheduled == other._scheduled &&
        _scheduledTime == other._scheduledTime &&
        _isScheduledDateInferred == other._isScheduledDateInferred &&
        //taskSource == other.taskSource &&
        _recurrenceRule == other._recurrenceRule &&
        _reminder == other._reminder &&
        _tagsEqual(other._tags);
  }

  bool _tagsEqual(List<String> otherTags) {
    if (_tags.length != otherTags.length) return false;
    final sortedTags = List<String>.from(_tags)..sort();
    final sortedOtherTags = List<String>.from(otherTags)..sort();
    for (int i = 0; i < sortedTags.length; i++) {
      if (sortedTags[i] != sortedOtherTags[i]) return false;
    }
    return true;
  }

  void update(Task task) {
    _description = task._description;
    _tags = List.from(task._tags);
    _status = task._status;
    _priority = task._priority;
    _created = task._created;
    _done = task._done;
    _cancelled = task._cancelled;
    _due = task._due;
    _start = task._start;
    _scheduled = task._scheduled;
    _scheduledTime = task._scheduledTime;
    _isScheduledDateInferred = task._isScheduledDateInferred;
    taskSource = task.taskSource;
    // createdDateMarker = task.createdDateMarker;
    // scheduledDateMarker = task.scheduledDateMarker;
    _reminder = task._reminder;
    _changed = true;
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'description': _description,
      'tags': _tags,
      'status': _status.name,
      'priority': _priority.name,
      'created': _created?.toIso8601String(),
      'done': _done?.toIso8601String(),
      'cancelled': _cancelled?.toIso8601String(),
      'due': _due?.toIso8601String(),
      'start': _start?.toIso8601String(),
      'scheduled': _scheduled?.toIso8601String(),
      // 'scheduledTime': _scheduledTime,
      'isScheduledDateInferred': _isScheduledDateInferred,
      'recurrenceRule': _recurrenceRule,
      'reminder': _reminder?.toIso8601String(),
      'filePath': taskSource?.fileName,
      'fileOffset': taskSource?.offset.toString(),
      'fileNumber': taskSource?.fileNumber.toString(),
      'length': taskSource?.length.toString(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    var task = Task(
      json['description'],
      status: TaskStatus.values.firstWhere((e) => e.name == json['status'],
          orElse: () => TaskStatus.todo),
      priority: TaskPriority.values.firstWhere(
          (e) => e.name == json['priority'],
          orElse: () => TaskPriority.normal),
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      done: json['done'] != null ? DateTime.parse(json['done']) : null,
      cancelled:
          json['cancelled'] != null ? DateTime.parse(json['cancelled']) : null,
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      scheduled:
          json['scheduled'] != null ? DateTime.parse(json['scheduled']) : null,
      scheduledTime: json['scheduledTime'] ?? false,
      isScheduledDateInferred: json['isScheduledDateInferred'] ?? false,
      recurranceRule: json['recurrenceRule'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      reminder:
          json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
    );

    if (json['filePath'] != null) {
      task.taskSource = TaskSource(
        int.tryParse(json['fileNumber'] ?? '0') ?? 0,
        json['filePath'],
        int.tryParse(json['fileOffset'] ?? '0') ?? 0,
        int.tryParse(json['length'] ?? '0') ?? 0,
      );
    }
    return task;
  }
}
