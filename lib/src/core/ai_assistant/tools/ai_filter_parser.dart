import 'package:obsi/src/core/task_filter.dart';

/// Parser for AI tool filter queries
/// Converts natural language-like queries to TaskFilter or MemoFilter
class AIFilterParser {
  /// Parse task filter query string to TaskFilter
  ///
  /// Syntax: field:value [field:value]...
  /// Fields:
  /// - scheduled: today|tomorrow|this_week|this_month|overdue|next_N_days|no_date
  /// - due: (same as scheduled)
  /// - status: all|todo|done
  /// - tag: #tagname (can have multiple)
  /// - exclude_tag: -#tagname
  /// - path: path_fragment
  /// - logic: and|or (default: or)
  ///
  /// Examples:
  /// - "scheduled:today status:todo"
  /// - "due:overdue"
  /// - "due:next_7_days tag:#work"
  static TaskFilter parseTaskFilter(String query) {
    if (query.trim().isEmpty) {
      return TaskFilter(); // Return default filter (all tasks)
    }

    var filter = TaskFilter();

    // Parse key:value pairs
    final pattern = RegExp(r'(\w+):([^\s]+)');
    final matches = pattern.allMatches(query);

    List<String> tags = [];
    List<String> excludedTags = [];

    for (final match in matches) {
      final key = match.group(1)!.toLowerCase();
      final value = match.group(2)!;

      switch (key) {
        case 'scheduled':
          filter.scheduledDateFilter = _parseDateFilterType(value);
          filter.nextDays = _parseNextDays(value);
          break;

        case 'due':
          filter.dueDateFilter = _parseDateFilterType(value);
          filter.nextDays = _parseNextDays(value);
          break;

        case 'status':
          filter.statusFilter = _parseStatusFilter(value);
          break;

        case 'tag':
          // Remove # prefix if present
          final tagName = value.startsWith('#') ? value.substring(1) : value;
          tags.add(tagName);
          break;

        case 'exclude_tag':
          // Remove -# or # prefix
          var tagName = value;
          if (tagName.startsWith('-#')) {
            tagName = tagName.substring(2);
          } else if (tagName.startsWith('#')) {
            tagName = tagName.substring(1);
          }
          excludedTags.add(tagName);
          break;

        case 'path':
          filter.pathContains = value;
          break;

        case 'logic':
          filter.useOrLogic = value.toLowerCase() == 'or';
          break;
      }
    }

    filter.tags = tags;
    filter.excludedTags = excludedTags;

    return filter;
  }

  /// Parse date filter type from string
  static DateFilterType _parseDateFilterType(String value) {
    final lowerValue = value.toLowerCase();

    if (lowerValue == 'today') return DateFilterType.today;
    if (lowerValue == 'tomorrow') return DateFilterType.tomorrow;
    if (lowerValue == 'this_week') return DateFilterType.thisWeek;
    if (lowerValue == 'this_month') return DateFilterType.thisMonth;
    if (lowerValue == 'overdue') return DateFilterType.overdue;
    if (lowerValue == 'no_date') return DateFilterType.noDate;
    if (lowerValue.startsWith('next_') && lowerValue.endsWith('_days')) {
      return DateFilterType.nextNDays;
    }

    return DateFilterType.none;
  }

  /// Parse the N from next_N_days
  static int _parseNextDays(String value) {
    final lowerValue = value.toLowerCase();
    if (lowerValue.startsWith('next_') && lowerValue.endsWith('_days')) {
      final numStr = lowerValue.substring(5, lowerValue.length - 5);
      return int.tryParse(numStr) ?? 7;
    }
    return 7;
  }

  /// Parse status filter from string
  static StatusFilterType _parseStatusFilter(String value) {
    final lowerValue = value.toLowerCase();
    if (lowerValue == 'todo') return StatusFilterType.todo;
    if (lowerValue == 'done') return StatusFilterType.done;
    return StatusFilterType.all;
  }
}

/// Filter result for Memos
class MemoFilterResult {
  final DateTime? startDate;
  final DateTime? endDate;
  final int limit;

  MemoFilterResult({
    this.startDate,
    this.endDate,
    this.limit = 20,
  });

  /// Check if a memo date matches this filter
  bool matches(DateTime memoDate) {
    final normalizedMemo =
        DateTime(memoDate.year, memoDate.month, memoDate.day);

    if (startDate != null) {
      final normalizedStart =
          DateTime(startDate!.year, startDate!.month, startDate!.day);
      if (normalizedMemo.isBefore(normalizedStart)) return false;
    }

    if (endDate != null) {
      final normalizedEnd =
          DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (normalizedMemo.isAfter(normalizedEnd)) return false;
    }

    return true;
  }
}

/// Parser for Memo filter queries
class MemoFilterParser {
  /// Parse memo filter query string
  ///
  /// Syntax: date:value [limit:N]
  ///
  /// date values:
  /// - today
  /// - yesterday
  /// - this_week
  /// - YYYY-MM-DD (specific date)
  /// - YYYY-MM-DD~YYYY-MM-DD (date range)
  ///
  /// limit: optional, default 20
  ///
  /// Examples:
  /// - "date:today"
  /// - "date:2026-01-11"
  /// - "date:2026-01-04~2026-01-10"
  /// - "date:today limit:5"
  static MemoFilterResult parseMemoFilter(String query) {
    if (query.trim().isEmpty) {
      return MemoFilterResult(); // Default: no date filter, limit 20
    }

    DateTime? startDate;
    DateTime? endDate;
    int limit = 20;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse key:value pairs
    final pattern = RegExp(r'(\w+):([^\s]+)');
    final matches = pattern.allMatches(query);

    for (final match in matches) {
      final key = match.group(1)!.toLowerCase();
      final value = match.group(2)!;

      switch (key) {
        case 'date':
          final dateParsed = _parseDateValue(value, today);
          startDate = dateParsed.start;
          endDate = dateParsed.end;
          break;

        case 'limit':
          limit = int.tryParse(value) ?? 20;
          break;
      }
    }

    return MemoFilterResult(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  /// Parse date value to start/end range
  static ({DateTime? start, DateTime? end}) _parseDateValue(
      String value, DateTime today) {
    final lowerValue = value.toLowerCase();

    // Preset values
    if (lowerValue == 'today') {
      return (start: today, end: today);
    }

    if (lowerValue == 'yesterday') {
      final yesterday = today.subtract(const Duration(days: 1));
      return (start: yesterday, end: yesterday);
    }

    if (lowerValue == 'this_week') {
      // Calculate start of week (Monday)
      final weekday = today.weekday;
      final startOfWeek = today.subtract(Duration(days: weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return (start: startOfWeek, end: endOfWeek);
    }

    if (lowerValue == 'last_week') {
      final weekday = today.weekday;
      final startOfThisWeek = today.subtract(Duration(days: weekday - 1));
      final endOfLastWeek = startOfThisWeek.subtract(const Duration(days: 1));
      final startOfLastWeek = endOfLastWeek.subtract(const Duration(days: 6));
      return (start: startOfLastWeek, end: endOfLastWeek);
    }

    if (lowerValue == 'this_month') {
      final startOfMonth = DateTime(today.year, today.month, 1);
      final endOfMonth = DateTime(today.year, today.month + 1, 0);
      return (start: startOfMonth, end: endOfMonth);
    }

    // Date range: YYYY-MM-DD~YYYY-MM-DD
    if (value.contains('~')) {
      final parts = value.split('~');
      if (parts.length == 2) {
        final start = DateTime.tryParse(parts[0]);
        final end = DateTime.tryParse(parts[1]);
        return (start: start, end: end);
      }
    }

    // Specific date: YYYY-MM-DD
    final specificDate = DateTime.tryParse(value);
    if (specificDate != null) {
      return (start: specificDate, end: specificDate);
    }

    return (start: null, end: null);
  }
}
