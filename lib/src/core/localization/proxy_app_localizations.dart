import '../../localization/l10n_gen/app_localizations.dart';
import 'custom_language.dart';

/// A proxy class that overrides AppLocalizations with custom dictionary values.
class ProxyAppLocalizations extends AppLocalizations {
  final AppLocalizations _base;
  final CustomLanguage? _custom;

  ProxyAppLocalizations(this._base, this._custom) : super(_base.localeName);

  @override
  String get appTitle => _custom?.translate('appTitle') ?? _base.appTitle;

  @override
  String get cancel => _custom?.translate('cancel') ?? _base.cancel;

  @override
  String get save => _custom?.translate('save') ?? _base.save;

  @override
  String get delete => _custom?.translate('delete') ?? _base.delete;

  @override
  String get edit => _custom?.translate('edit') ?? _base.edit;

  @override
  String get ok => _custom?.translate('ok') ?? _base.ok;

  @override
  String get confirm => _custom?.translate('confirm') ?? _base.confirm;

  @override
  String get loading => _custom?.translate('loading') ?? _base.loading;

  @override
  String get success => _custom?.translate('success') ?? _base.success;

  @override
  String get error => _custom?.translate('error') ?? _base.error;

  @override
  String get undo => _custom?.translate('undo') ?? _base.undo;

  @override
  String get retry => _custom?.translate('retry') ?? _base.retry;

  @override
  String get settings => _custom?.translate('settings') ?? _base.settings;

  @override
  String get general => _custom?.translate('general') ?? _base.general;

  @override
  String get tasks => _custom?.translate('tasks') ?? _base.tasks;

  @override
  String get memos => _custom?.translate('memos') ?? _base.memos;

  @override
  String get aiAssistant =>
      _custom?.translate('aiAssistant') ?? _base.aiAssistant;

  @override
  String get language => _custom?.translate('language') ?? _base.language;

  @override
  String get importDictionary =>
      _custom?.translate('importDictionary') ?? _base.importDictionary;

  @override
  String get manageDictionaries =>
      _custom?.translate('manageDictionaries') ?? _base.manageDictionaries;

  @override
  String get vaultFolderPrompt =>
      _custom?.translate('vaultFolderPrompt') ?? _base.vaultFolderPrompt;

  @override
  String get select => _custom?.translate('select') ?? _base.select;

  @override
  String get pleaseChooseFolder =>
      _custom?.translate('pleaseChooseFolder') ?? _base.pleaseChooseFolder;

  @override
  String get storagePermissionRequired =>
      _custom?.translate('storagePermissionRequired') ??
      _base.storagePermissionRequired;

  @override
  String get noExternalStorageFound =>
      _custom?.translate('noExternalStorageFound') ??
      _base.noExternalStorageFound;

  @override
  String get showOnboarding =>
      _custom?.translate('showOnboarding') ?? _base.showOnboarding;

  @override
  String get showOnboardingDesc =>
      _custom?.translate('showOnboardingDesc') ?? _base.showOnboardingDesc;

  @override
  String get dailyReminderTasks =>
      _custom?.translate('dailyReminderTasks') ?? _base.dailyReminderTasks;

  @override
  String get dailyReminderCompleted =>
      _custom?.translate('dailyReminderCompleted') ??
      _base.dailyReminderCompleted;

  @override
  String get time => _custom?.translate('time') ?? _base.time;

  @override
  String get notSet => _custom?.translate('notSet') ?? _base.notSet;

  @override
  String get clearReminder =>
      _custom?.translate('clearReminder') ?? _base.clearReminder;

  @override
  String get reviewTasksNotification =>
      _custom?.translate('reviewTasksNotification') ??
      _base.reviewTasksNotification;

  @override
  String get reviewCompletedNotification =>
      _custom?.translate('reviewCompletedNotification') ??
      _base.reviewCompletedNotification;

  @override
  String get tasksFileName =>
      _custom?.translate('tasksFileName') ?? _base.tasksFileName;

  @override
  String get globalTaskFilter =>
      _custom?.translate('globalTaskFilter') ?? _base.globalTaskFilter;

  @override
  String get enterGlobalFilter =>
      _custom?.translate('enterGlobalFilter') ?? _base.enterGlobalFilter;

  @override
  String get memosPath => _custom?.translate('memosPath') ?? _base.memosPath;

  @override
  String get memosPathDesc =>
      _custom?.translate('memosPathDesc') ?? _base.memosPathDesc;

  @override
  String get dynamicPath =>
      _custom?.translate('dynamicPath') ?? _base.dynamicPath;

  @override
  String get dynamicPathDesc =>
      _custom?.translate('dynamicPathDesc') ?? _base.dynamicPathDesc;

  @override
  String get widgetSortOrder =>
      _custom?.translate('widgetSortOrder') ?? _base.widgetSortOrder;

  @override
  String get widgetSortOrderDesc =>
      _custom?.translate('widgetSortOrderDesc') ?? _base.widgetSortOrderDesc;

  @override
  String get asc => _custom?.translate('asc') ?? _base.asc;

  @override
  String get desc => _custom?.translate('desc') ?? _base.desc;

  @override
  String get memosAttachmentDir =>
      _custom?.translate('memosAttachmentDir') ?? _base.memosAttachmentDir;

  @override
  String get memosAttachmentDirDesc =>
      _custom?.translate('memosAttachmentDirDesc') ??
      _base.memosAttachmentDirDesc;

  @override
  String get enterMemosAttachmentDir =>
      _custom?.translate('enterMemosAttachmentDir') ??
      _base.enterMemosAttachmentDir;

  @override
  String get imageCompression =>
      _custom?.translate('imageCompression') ?? _base.imageCompression;

  @override
  String get enableCompression =>
      _custom?.translate('enableCompression') ?? _base.enableCompression;

  @override
  String get enableCompressionDesc =>
      _custom?.translate('enableCompressionDesc') ??
      _base.enableCompressionDesc;

  @override
  String get format => _custom?.translate('format') ?? _base.format;

  @override
  String get quality => _custom?.translate('quality') ?? _base.quality;

  @override
  String get microblogPublishing =>
      _custom?.translate('microblogPublishing') ?? _base.microblogPublishing;

  @override
  String get microblogFilename =>
      _custom?.translate('microblogFilename') ?? _base.microblogFilename;

  @override
  String get microblogTitle =>
      _custom?.translate('microblogTitle') ?? _base.microblogTitle;

  @override
  String get microblogPermalink =>
      _custom?.translate('microblogPermalink') ?? _base.microblogPermalink;

  @override
  String get microblogPermalinkHelper =>
      _custom?.translate('microblogPermalinkHelper') ??
      _base.microblogPermalinkHelper;

  @override
  String get microblogTag =>
      _custom?.translate('microblogTag') ?? _base.microblogTag;

  @override
  String get microblogAvatarPath =>
      _custom?.translate('microblogAvatarPath') ?? _base.microblogAvatarPath;

  @override
  String get microblogUsername =>
      _custom?.translate('microblogUsername') ?? _base.microblogUsername;

  @override
  String get pushConfig => _custom?.translate('pushConfig') ?? _base.pushConfig;

  @override
  String get repoUrl => _custom?.translate('repoUrl') ?? _base.repoUrl;

  @override
  String get repoPath => _custom?.translate('repoPath') ?? _base.repoPath;

  @override
  String get repoImagePath =>
      _custom?.translate('repoImagePath') ?? _base.repoImagePath;

  @override
  String get webImagePrefix =>
      _custom?.translate('webImagePrefix') ?? _base.webImagePrefix;

  @override
  String get personalAccessToken =>
      _custom?.translate('personalAccessToken') ?? _base.personalAccessToken;

  @override
  String get enterBaseUrl =>
      _custom?.translate('enterBaseUrl') ?? _base.enterBaseUrl;

  @override
  String get enterApiKey =>
      _custom?.translate('enterApiKey') ?? _base.enterApiKey;

  @override
  String get aiBaseUrl => _custom?.translate('aiBaseUrl') ?? _base.aiBaseUrl;

  @override
  String get aiApiKey => _custom?.translate('aiApiKey') ?? _base.aiApiKey;

  @override
  String get aiModelName =>
      _custom?.translate('aiModelName') ?? _base.aiModelName;

  @override
  String get about => _custom?.translate('about') ?? _base.about;

  @override
  String get contactDeveloper =>
      _custom?.translate('contactDeveloper') ?? _base.contactDeveloper;

  @override
  String get version => _custom?.translate('version') ?? _base.version;

  @override
  String couldNotLaunch(Object url) {
    String? custom = _custom?.translate('couldNotLaunch');
    if (custom != null) {
      return custom.replaceAll('{url}', url.toString());
    }
    return _base.couldNotLaunch(url);
  }

  @override
  String get memosAttachmentDirNotConfigured =>
      _custom?.translate('memosAttachmentDirNotConfigured') ??
      _base.memosAttachmentDirNotConfigured;

  @override
  String get vaultNotConfigured =>
      _custom?.translate('vaultNotConfigured') ?? _base.vaultNotConfigured;

  @override
  String attachmentSaved(Object path) {
    String? custom = _custom?.translate('attachmentSaved');
    if (custom != null) {
      return custom.replaceAll('{path}', path.toString());
    }
    return _base.attachmentSaved(path);
  }

  @override
  String attachmentSaveFailed(Object error) {
    String? custom = _custom?.translate('attachmentSaveFailed');
    if (custom != null) {
      return custom.replaceAll('{error}', error.toString());
    }
    return _base.attachmentSaveFailed(error);
  }

  @override
  String get microblogNotConfigured =>
      _custom?.translate('microblogNotConfigured') ??
      _base.microblogNotConfigured;

  @override
  String get publishMicroblog =>
      _custom?.translate('publishMicroblog') ?? _base.publishMicroblog;

  @override
  String publishConfirmation(Object tag) {
    String? custom = _custom?.translate('publishConfirmation');
    if (custom != null) {
      return custom.replaceAll('{tag}', tag.toString());
    }
    return _base.publishConfirmation(tag);
  }

  @override
  String get publish => _custom?.translate('publish') ?? _base.publish;

  @override
  String get publishing => _custom?.translate('publishing') ?? _base.publishing;

  @override
  String get pushingContent =>
      _custom?.translate('pushingContent') ?? _base.pushingContent;

  @override
  String get noAttachmentsUpdated =>
      _custom?.translate('noAttachmentsUpdated') ?? _base.noAttachmentsUpdated;

  @override
  String attachmentsUploaded(Object count, Object message) {
    String? custom = _custom?.translate('attachmentsUploaded');
    if (custom != null) {
      return custom
          .replaceAll('{count}', count.toString())
          .replaceAll('{message}', message.toString());
    }
    return _base.attachmentsUploaded(count, message);
  }

  @override
  String newAttachments(Object count) {
    String? custom = _custom?.translate('newAttachments');
    if (custom != null) {
      return custom.replaceAll('{count}', count.toString());
    }
    return _base.newAttachments(count);
  }

  @override
  String publishSuccess(Object message) {
    String? custom = _custom?.translate('publishSuccess');
    if (custom != null) {
      return custom.replaceAll('{message}', message.toString());
    }
    return _base.publishSuccess(message);
  }

  @override
  String publishFailed(Object error) {
    String? custom = _custom?.translate('publishFailed');
    if (custom != null) {
      return custom.replaceAll('{error}', error.toString());
    }
    return _base.publishFailed(error);
  }

  @override
  String editingTime(Object time) {
    String? custom = _custom?.translate('editingTime');
    if (custom != null) {
      return custom.replaceAll('{time}', time.toString());
    }
    return _base.editingTime(time);
  }

  @override
  String get deleteImage =>
      _custom?.translate('deleteImage') ?? _base.deleteImage;

  @override
  String get deleteImageConfirmation =>
      _custom?.translate('deleteImageConfirmation') ??
      _base.deleteImageConfirmation;

  @override
  String get imageDeleted =>
      _custom?.translate('imageDeleted') ?? _base.imageDeleted;

  @override
  String get filterStatus =>
      _custom?.translate('filterStatus') ?? _base.filterStatus;

  @override
  String get filterScheduledDate =>
      _custom?.translate('filterScheduledDate') ?? _base.filterScheduledDate;

  @override
  String get filterDueDate =>
      _custom?.translate('filterDueDate') ?? _base.filterDueDate;

  @override
  String get filterTag => _custom?.translate('filterTag') ?? _base.filterTag;

  @override
  String get filterPath => _custom?.translate('filterPath') ?? _base.filterPath;

  @override
  String get filterPriority =>
      _custom?.translate('filterPriority') ?? _base.filterPriority;

  @override
  String get opAny => _custom?.translate('opAny') ?? _base.opAny;

  @override
  String get opIs => _custom?.translate('opIs') ?? _base.opIs;

  @override
  String get opIsNot => _custom?.translate('opIsNot') ?? _base.opIsNot;

  @override
  String get opIsBefore => _custom?.translate('opIsBefore') ?? _base.opIsBefore;

  @override
  String get opIsAfter => _custom?.translate('opIsAfter') ?? _base.opIsAfter;

  @override
  String get opIsToday => _custom?.translate('opIsToday') ?? _base.opIsToday;

  @override
  String get opIsBeforeToday =>
      _custom?.translate('opIsBeforeToday') ?? _base.opIsBeforeToday;

  @override
  String get opIsAfterToday =>
      _custom?.translate('opIsAfterToday') ?? _base.opIsAfterToday;

  @override
  String get opIsInNextDays =>
      _custom?.translate('opIsInNextDays') ?? _base.opIsInNextDays;

  @override
  String get opIsInPrevDays =>
      _custom?.translate('opIsInPrevDays') ?? _base.opIsInPrevDays;

  @override
  String get opIsEmpty => _custom?.translate('opIsEmpty') ?? _base.opIsEmpty;

  @override
  String get opIsNotEmpty =>
      _custom?.translate('opIsNotEmpty') ?? _base.opIsNotEmpty;

  @override
  String get taskStatusAll =>
      _custom?.translate('taskStatusAll') ?? _base.taskStatusAll;

  @override
  String get taskStatusTodo =>
      _custom?.translate('taskStatusTodo') ?? _base.taskStatusTodo;

  @override
  String get taskStatusDone =>
      _custom?.translate('taskStatusDone') ?? _base.taskStatusDone;

  @override
  String get labelMatch => _custom?.translate('labelMatch') ?? _base.labelMatch;

  @override
  String get labelAll => _custom?.translate('labelAll') ?? _base.labelAll;

  @override
  String get labelAny => _custom?.translate('labelAny') ?? _base.labelAny;

  @override
  String get labelConditions =>
      _custom?.translate('labelConditions') ?? _base.labelConditions;

  @override
  String get btnAddCondition =>
      _custom?.translate('btnAddCondition') ?? _base.btnAddCondition;

  @override
  String get hintDays => _custom?.translate('hintDays') ?? _base.hintDays;

  @override
  String get hintTag => _custom?.translate('hintTag') ?? _base.hintTag;

  @override
  String get hintPath => _custom?.translate('hintPath') ?? _base.hintPath;

  @override
  String get hintPriority =>
      _custom?.translate('hintPriority') ?? _base.hintPriority;

  @override
  String get btnSelectDate =>
      _custom?.translate('btnSelectDate') ?? _base.btnSelectDate;

  @override
  String get msgEnterFilterName =>
      _custom?.translate('msgEnterFilterName') ?? _base.msgEnterFilterName;

  @override
  String get titleNewFilter =>
      _custom?.translate('titleNewFilter') ?? _base.titleNewFilter;

  @override
  String get titleEditFilter =>
      _custom?.translate('titleEditFilter') ?? _base.titleEditFilter;

  @override
  String get labelFilterName =>
      _custom?.translate('labelFilterName') ?? _base.labelFilterName;

  @override
  String get headerFilterConditions =>
      _custom?.translate('headerFilterConditions') ??
      _base.headerFilterConditions;

  @override
  String get memosToday => _custom?.translate('memosToday') ?? _base.memosToday;

  @override
  String get memosYesterday =>
      _custom?.translate('memosYesterday') ?? _base.memosYesterday;

  @override
  String get btnSelectMonth =>
      _custom?.translate('btnSelectMonth') ?? _base.btnSelectMonth;

  @override
  String get labelYear => _custom?.translate('labelYear') ?? _base.labelYear;

  @override
  String get labelMonth => _custom?.translate('labelMonth') ?? _base.labelMonth;

  @override
  String get labelInheritDate =>
      _custom?.translate('labelInheritDate') ?? _base.labelInheritDate;

  @override
  String get labelTagsInclude =>
      _custom?.translate('labelTagsInclude') ?? _base.labelTagsInclude;

  @override
  String get labelTagsExclude =>
      _custom?.translate('labelTagsExclude') ?? _base.labelTagsExclude;

  @override
  String get hintEnterTag =>
      _custom?.translate('hintEnterTag') ?? _base.hintEnterTag;

  @override
  String get labelPathContains =>
      _custom?.translate('labelPathContains') ?? _base.labelPathContains;

  @override
  String get hintPathExample =>
      _custom?.translate('hintPathExample') ?? _base.hintPathExample;

  @override
  String get labelGroupBy =>
      _custom?.translate('labelGroupBy') ?? _base.labelGroupBy;

  @override
  String get groupNone => _custom?.translate('groupNone') ?? _base.groupNone;

  @override
  String get groupDueDate =>
      _custom?.translate('groupDueDate') ?? _base.groupDueDate;

  @override
  String get groupScheduledDate =>
      _custom?.translate('groupScheduledDate') ?? _base.groupScheduledDate;

  @override
  String get groupFilePath =>
      _custom?.translate('groupFilePath') ?? _base.groupFilePath;

  @override
  String get groupPriority =>
      _custom?.translate('groupPriority') ?? _base.groupPriority;

  @override
  String get groupStatus =>
      _custom?.translate('groupStatus') ?? _base.groupStatus;

  @override
  String get labelSortRules =>
      _custom?.translate('labelSortRules') ?? _base.labelSortRules;

  @override
  String get sortAsc => _custom?.translate('sortAsc') ?? _base.sortAsc;

  @override
  String get sortDesc => _custom?.translate('sortDesc') ?? _base.sortDesc;

  @override
  String get sortAlphabetical =>
      _custom?.translate('sortAlphabetical') ?? _base.sortAlphabetical;

  @override
  String get sortCreatedDate =>
      _custom?.translate('sortCreatedDate') ?? _base.sortCreatedDate;

  @override
  String get btnAddSortRule =>
      _custom?.translate('btnAddSortRule') ?? _base.btnAddSortRule;

  @override
  String get headerNewTaskDefaults =>
      _custom?.translate('headerNewTaskDefaults') ??
      _base.headerNewTaskDefaults;

  @override
  String get labelDefaultTags =>
      _custom?.translate('labelDefaultTags') ?? _base.labelDefaultTags;

  @override
  String get hintDefaultTag =>
      _custom?.translate('hintDefaultTag') ?? _base.hintDefaultTag;

  @override
  String get labelDefaultDueDate =>
      _custom?.translate('labelDefaultDueDate') ?? _base.labelDefaultDueDate;

  @override
  String get labelOffsetDays =>
      _custom?.translate('labelOffsetDays') ?? _base.labelOffsetDays;

  @override
  String get labelSpecificDate =>
      _custom?.translate('labelSpecificDate') ?? _base.labelSpecificDate;

  @override
  String get datePresetNone =>
      _custom?.translate('datePresetNone') ?? _base.datePresetNone;

  @override
  String get datePresetToday =>
      _custom?.translate('datePresetToday') ?? _base.datePresetToday;

  @override
  String get datePresetTomorrow =>
      _custom?.translate('datePresetTomorrow') ?? _base.datePresetTomorrow;

  @override
  String get datePresetTodayPlusDays =>
      _custom?.translate('datePresetTodayPlusDays') ??
      _base.datePresetTodayPlusDays;

  @override
  String get actionKeep => _custom?.translate('actionKeep') ?? _base.actionKeep;

  @override
  String get actionDelete =>
      _custom?.translate('actionDelete') ?? _base.actionDelete;

  @override
  String get actionArchive =>
      _custom?.translate('actionArchive') ?? _base.actionArchive;

  @override
  String get titleManageFilters =>
      _custom?.translate('titleManageFilters') ?? _base.titleManageFilters;

  @override
  String get labelWidgetDisplay =>
      _custom?.translate('labelWidgetDisplay') ?? _base.labelWidgetDisplay;

  @override
  String get labelDefault =>
      _custom?.translate('labelDefault') ?? _base.labelDefault;

  @override
  String confirmDeleteFilter(String name) {
    String? custom = _custom?.translate('confirmDeleteFilter');
    if (custom != null) {
      return custom.replaceAll('{name}', name.toString());
    }
    return _base.confirmDeleteFilter(name);
  }

  @override
  String get titleDeleteFilter =>
      _custom?.translate('titleDeleteFilter') ?? _base.titleDeleteFilter;

  @override
  String get titleSelectWidgetFilter =>
      _custom?.translate('titleSelectWidgetFilter') ??
      _base.titleSelectWidgetFilter;

  @override
  String get labelCompletionAction =>
      _custom?.translate('labelCompletionAction') ??
      _base.labelCompletionAction;

  @override
  String get headerTaskStatus =>
      _custom?.translate('headerTaskStatus') ?? _base.headerTaskStatus;

  @override
  String get labelTask => _custom?.translate('labelTask') ?? _base.labelTask;

  @override
  String get labelTaskDescription =>
      _custom?.translate('labelTaskDescription') ?? _base.labelTaskDescription;

  @override
  String get hintEnterTask =>
      _custom?.translate('hintEnterTask') ?? _base.hintEnterTask;

  @override
  String get labelTags => _custom?.translate('labelTags') ?? _base.labelTags;

  @override
  String get msgNoTagsAvailable =>
      _custom?.translate('msgNoTagsAvailable') ?? _base.msgNoTagsAvailable;

  @override
  String get headerPlanning =>
      _custom?.translate('headerPlanning') ?? _base.headerPlanning;

  @override
  String get labelPriority =>
      _custom?.translate('labelPriority') ?? _base.labelPriority;

  @override
  String get labelRecurrence =>
      _custom?.translate('labelRecurrence') ?? _base.labelRecurrence;

  @override
  String get labelDue => _custom?.translate('labelDue') ?? _base.labelDue;

  @override
  String get labelScheduled =>
      _custom?.translate('labelScheduled') ?? _base.labelScheduled;

  @override
  String get labelStart => _custom?.translate('labelStart') ?? _base.labelStart;

  @override
  String get headerNotifications =>
      _custom?.translate('headerNotifications') ?? _base.headerNotifications;

  @override
  String get labelScheduledNotification =>
      _custom?.translate('labelScheduledNotification') ??
      _base.labelScheduledNotification;

  @override
  String get headerStatusMetadata =>
      _custom?.translate('headerStatusMetadata') ?? _base.headerStatusMetadata;

  @override
  String get labelStatus =>
      _custom?.translate('labelStatus') ?? _base.labelStatus;

  @override
  String get labelCreated =>
      _custom?.translate('labelCreated') ?? _base.labelCreated;

  @override
  String get labelDone => _custom?.translate('labelDone') ?? _base.labelDone;

  @override
  String get labelCancelled =>
      _custom?.translate('labelCancelled') ?? _base.labelCancelled;

  @override
  String get priorityLowest =>
      _custom?.translate('priorityLowest') ?? _base.priorityLowest;

  @override
  String get priorityLow =>
      _custom?.translate('priorityLow') ?? _base.priorityLow;

  @override
  String get priorityNormal =>
      _custom?.translate('priorityNormal') ?? _base.priorityNormal;

  @override
  String get priorityMedium =>
      _custom?.translate('priorityMedium') ?? _base.priorityMedium;

  @override
  String get priorityHigh =>
      _custom?.translate('priorityHigh') ?? _base.priorityHigh;

  @override
  String get priorityHighest =>
      _custom?.translate('priorityHighest') ?? _base.priorityHighest;

  @override
  String get taskStatusInprogress =>
      _custom?.translate('taskStatusInprogress') ?? _base.taskStatusInprogress;

  @override
  String get taskStatusCancelled =>
      _custom?.translate('taskStatusCancelled') ?? _base.taskStatusCancelled;

  @override
  String get recurrenceNone =>
      _custom?.translate('recurrenceNone') ?? _base.recurrenceNone;

  @override
  String get recurrenceDaily =>
      _custom?.translate('recurrenceDaily') ?? _base.recurrenceDaily;

  @override
  String get recurrenceWeekly =>
      _custom?.translate('recurrenceWeekly') ?? _base.recurrenceWeekly;

  @override
  String get recurrenceMonthly =>
      _custom?.translate('recurrenceMonthly') ?? _base.recurrenceMonthly;

  @override
  String get recurrenceYearly =>
      _custom?.translate('recurrenceYearly') ?? _base.recurrenceYearly;

  @override
  String get recurrenceWeekday =>
      _custom?.translate('recurrenceWeekday') ?? _base.recurrenceWeekday;

  @override
  String get recurrenceMonday =>
      _custom?.translate('recurrenceMonday') ?? _base.recurrenceMonday;

  @override
  String get recurrenceTuesday =>
      _custom?.translate('recurrenceTuesday') ?? _base.recurrenceTuesday;

  @override
  String get recurrenceWednesday =>
      _custom?.translate('recurrenceWednesday') ?? _base.recurrenceWednesday;

  @override
  String get recurrenceThursday =>
      _custom?.translate('recurrenceThursday') ?? _base.recurrenceThursday;

  @override
  String get recurrenceFriday =>
      _custom?.translate('recurrenceFriday') ?? _base.recurrenceFriday;

  @override
  String get recurrenceSaturday =>
      _custom?.translate('recurrenceSaturday') ?? _base.recurrenceSaturday;

  @override
  String get recurrenceSunday =>
      _custom?.translate('recurrenceSunday') ?? _base.recurrenceSunday;

  @override
  String deleteFailed(Object error) {
    String? custom = _custom?.translate('deleteFailed');
    if (custom != null) {
      return custom.replaceAll('{error}', error.toString());
    }
    return _base.deleteFailed(error);
  }

  @override
  String get enterModelName =>
      _custom?.translate('enterModelName') ?? _base.enterModelName;

  @override
  String get dictionaryImported =>
      _custom?.translate('dictionaryImported') ?? _base.dictionaryImported;

  @override
  String dictionaryImportFailed(Object error) {
    String? custom = _custom?.translate('dictionaryImportFailed');
    if (custom != null) {
      return custom.replaceAll('{error}', error.toString());
    }
    return _base.dictionaryImportFailed(error);
  }

  @override
  String get memoHint => _custom?.translate('memoHint') ?? _base.memoHint;

  @override
  String get memoEditHint =>
      _custom?.translate('memoEditHint') ?? _base.memoEditHint;

  @override
  String get insertTag => _custom?.translate('insertTag') ?? _base.insertTag;

  @override
  String get insertWikiLink =>
      _custom?.translate('insertWikiLink') ?? _base.insertWikiLink;

  @override
  String get addAttachment =>
      _custom?.translate('addAttachment') ?? _base.addAttachment;

  @override
  String get jumpToDate => _custom?.translate('jumpToDate') ?? _base.jumpToDate;

  @override
  String get shareImageError =>
      _custom?.translate('shareImageError') ?? _base.shareImageError;

  @override
  String get manageFilters =>
      _custom?.translate('manageFilters') ?? _base.manageFilters;

  @override
  String get deleteFilter =>
      _custom?.translate('deleteFilter') ?? _base.deleteFilter;

  @override
  String deleteFilterConfirmation(Object name) {
    String? custom = _custom?.translate('deleteFilterConfirmation');
    if (custom != null) {
      return custom.replaceAll('{name}', name.toString());
    }
    return _base.deleteFilterConfirmation(name);
  }

  @override
  String get selectWidgetFilter =>
      _custom?.translate('selectWidgetFilter') ?? _base.selectWidgetFilter;

  @override
  String get defaultFilter =>
      _custom?.translate('defaultFilter') ?? _base.defaultFilter;

  @override
  String get widgetDisplay =>
      _custom?.translate('widgetDisplay') ?? _base.widgetDisplay;

  @override
  String get filterName => _custom?.translate('filterName') ?? _base.filterName;

  @override
  String get taskStatus => _custom?.translate('taskStatus') ?? _base.taskStatus;

  @override
  String matchConditions(Object mode) {
    String? custom = _custom?.translate('matchConditions');
    if (custom != null) {
      return custom.replaceAll('{mode}', mode.toString());
    }
    return _base.matchConditions(mode);
  }

  @override
  String get allMode => _custom?.translate('allMode') ?? _base.allMode;

  @override
  String get anyMode => _custom?.translate('anyMode') ?? _base.anyMode;

  @override
  String get addFilterGroup =>
      _custom?.translate('addFilterGroup') ?? _base.addFilterGroup;

  @override
  String get addCondition =>
      _custom?.translate('addCondition') ?? _base.addCondition;

  @override
  String get inheritDate =>
      _custom?.translate('inheritDate') ?? _base.inheritDate;

  @override
  String get includeTags =>
      _custom?.translate('includeTags') ?? _base.includeTags;

  @override
  String get excludeTags =>
      _custom?.translate('excludeTags') ?? _base.excludeTags;

  @override
  String get enterTagHint =>
      _custom?.translate('enterTagHint') ?? _base.enterTagHint;

  @override
  String get pathContains =>
      _custom?.translate('pathContains') ?? _base.pathContains;

  @override
  String get groupBy => _custom?.translate('groupBy') ?? _base.groupBy;

  @override
  String get none => _custom?.translate('none') ?? _base.none;

  @override
  String get dueDate => _custom?.translate('dueDate') ?? _base.dueDate;

  @override
  String get scheduledDate =>
      _custom?.translate('scheduledDate') ?? _base.scheduledDate;

  @override
  String get filePath => _custom?.translate('filePath') ?? _base.filePath;

  @override
  String get priority => _custom?.translate('priority') ?? _base.priority;

  @override
  String get status => _custom?.translate('status') ?? _base.status;

  @override
  String get sortRules => _custom?.translate('sortRules') ?? _base.sortRules;

  @override
  String get ascending => _custom?.translate('ascending') ?? _base.ascending;

  @override
  String get descending => _custom?.translate('descending') ?? _base.descending;

  @override
  String get createdDate =>
      _custom?.translate('createdDate') ?? _base.createdDate;

  @override
  String get alphabetical =>
      _custom?.translate('alphabetical') ?? _base.alphabetical;

  @override
  String get enterFilterName =>
      _custom?.translate('enterFilterName') ?? _base.enterFilterName;

  @override
  String get filterTasks =>
      _custom?.translate('filterTasks') ?? _base.filterTasks;

  @override
  String get newFilter => _custom?.translate('newFilter') ?? _base.newFilter;

  @override
  String get editFilter => _custom?.translate('editFilter') ?? _base.editFilter;

  @override
  String aiDataReview(Object name) {
    String? custom = _custom?.translate('aiDataReview');
    if (custom != null) {
      return custom.replaceAll('{name}', name.toString());
    }
    return _base.aiDataReview(name);
  }

  @override
  String get aiDataReviewDesc =>
      _custom?.translate('aiDataReviewDesc') ?? _base.aiDataReviewDesc;

  @override
  String get noData => _custom?.translate('noData') ?? _base.noData;

  @override
  String get reject => _custom?.translate('reject') ?? _base.reject;

  @override
  String get approve => _custom?.translate('approve') ?? _base.approve;

  @override
  String get approved => _custom?.translate('approved') ?? _base.approved;

  @override
  String get rejected => _custom?.translate('rejected') ?? _base.rejected;

  @override
  String get editData => _custom?.translate('editData') ?? _base.editData;

  @override
  String get editDataHint =>
      _custom?.translate('editDataHint') ?? _base.editDataHint;

  @override
  String get sendEdited => _custom?.translate('sendEdited') ?? _base.sendEdited;

  @override
  String get apiKeyMissing =>
      _custom?.translate('apiKeyMissing') ?? _base.apiKeyMissing;

  @override
  String get todayTaskDefaults =>
      _custom?.translate('todayTaskDefaults') ?? _base.todayTaskDefaults;

  @override
  String newTaskDefaults(Object name) {
    String? custom = _custom?.translate('newTaskDefaults');
    if (custom != null) {
      return custom.replaceAll('{name}', name.toString());
    }
    return _base.newTaskDefaults(name);
  }

  @override
  String get setDate => _custom?.translate('setDate') ?? _base.setDate;

  @override
  String get setTime => _custom?.translate('setTime') ?? _base.setTime;
}
