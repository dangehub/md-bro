import 'package:flutter/material.dart';
import 'package:obsi/src/core/task_filter.dart';
import 'package:obsi/src/core/filter_list.dart';
import 'package:obsi/src/localization/l10n_gen/app_localizations.dart';

mixin FilterLocalizationHelpers {
  String getFilterFieldName(BuildContext context, FilterField field) {
    final tr = AppLocalizations.of(context)!;
    switch (field) {
      case FilterField.status:
        return tr.filterStatus;
      case FilterField.scheduledDate:
        return tr.filterScheduledDate;
      case FilterField.dueDate:
        return tr.filterDueDate;
      case FilterField.tag:
        return tr.filterTag;
      case FilterField.path:
        return tr.filterPath;
      case FilterField.priority:
        return tr.filterPriority;
    }
  }

  String getDateOperatorName(BuildContext context, DateOperator op) {
    final tr = AppLocalizations.of(context)!;
    switch (op) {
      case DateOperator.any:
        return tr.opAny;
      case DateOperator.is_:
        return tr.opIs;
      case DateOperator.isNot:
        return tr.opIsNot;
      case DateOperator.isBefore:
        return tr.opIsBefore;
      case DateOperator.isAfter:
        return tr.opIsAfter;
      case DateOperator.isToday:
        return tr.opIsToday;
      case DateOperator.isBeforeToday:
        return tr.opIsBeforeToday;
      case DateOperator.isAfterToday:
        return tr.opIsAfterToday;
      case DateOperator.isInNextDays:
        return tr.opIsInNextDays;
      case DateOperator.isInPrevDays:
        return tr.opIsInPrevDays;
      case DateOperator.isEmpty:
        return tr.opIsEmpty;
      case DateOperator.isNotEmpty:
        return tr.opIsNotEmpty;
    }
  }

  String getStatusFilterName(BuildContext context, StatusFilterType status) {
    final tr = AppLocalizations.of(context)!;
    switch (status) {
      case StatusFilterType.all:
        return tr.taskStatusAll;
      case StatusFilterType.todo:
        return tr.taskStatusTodo;
      case StatusFilterType.done:
        return tr.taskStatusDone;
    }
  }

  String getCombineModeName(BuildContext context, ConditionCombineMode mode) {
    final tr = AppLocalizations.of(context)!;
    switch (mode) {
      case ConditionCombineMode.all:
        return tr.labelAll;
      case ConditionCombineMode.any:
        return tr.labelAny;
    }
  }

  String getGroupByFieldName(BuildContext context, GroupByField field) {
    final tr = AppLocalizations.of(context)!;
    switch (field) {
      case GroupByField.none:
        return tr.groupNone;
      case GroupByField.dueDate:
        return tr.groupDueDate;
      case GroupByField.scheduledDate:
        return tr.groupScheduledDate;
      case GroupByField.filePath:
        return tr.groupFilePath;
      case GroupByField.priority:
        return tr.groupPriority;
      case GroupByField.status:
        return tr.groupStatus;
    }
  }

  String getSortFieldName(BuildContext context, SortField field) {
    final tr = AppLocalizations.of(context)!;
    switch (field) {
      case SortField.dueDate:
        return tr.groupDueDate;
      case SortField.scheduledDate:
        return tr.groupScheduledDate;
      case SortField.priority:
        return tr.groupPriority;
      case SortField.alphabetical:
        return tr.sortAlphabetical;
      case SortField.createdDate:
        return tr.sortCreatedDate;
      case SortField.status:
        return tr.groupStatus;
    }
  }

  String getSortDirectionName(BuildContext context, SortDirection dir) {
    final tr = AppLocalizations.of(context)!;
    switch (dir) {
      case SortDirection.ascending:
        return tr.sortAsc;
      case SortDirection.descending:
        return tr.sortDesc;
    }
  }

  String getDatePresetName(BuildContext context, DatePresetType type) {
    final tr = AppLocalizations.of(context)!;
    switch (type) {
      case DatePresetType.none:
        return tr.datePresetNone;
      case DatePresetType.today:
        return tr.datePresetToday;
      case DatePresetType.todayPlusDays:
        return tr.datePresetTodayPlusDays;
      case DatePresetType.specificDate:
        return tr.labelSpecificDate;
    }
  }

  String getCompletionActionName(
      BuildContext context, TaskCompletionAction action) {
    final tr = AppLocalizations.of(context)!;
    switch (action) {
      case TaskCompletionAction.keep:
        return tr.actionKeep;
      case TaskCompletionAction.delete:
        return tr.actionDelete;
      case TaskCompletionAction.archive:
        return tr.actionArchive;
    }
  }
}
