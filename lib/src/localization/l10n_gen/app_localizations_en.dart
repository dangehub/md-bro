// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MD Bro';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get tasks => 'Tasks';

  @override
  String get memos => 'Memos';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get language => 'Language';

  @override
  String get importDictionary => 'Import Dictionary';

  @override
  String get manageDictionaries => 'Manage Dictionaries';

  @override
  String get vaultFolderPrompt =>
      'Folder in the Obsidian vault containing tasks:';

  @override
  String get select => 'Select';

  @override
  String get pleaseChooseFolder => '<Please choose the folder>';

  @override
  String get storagePermissionRequired =>
      'Storage permission is required to select a directory.';

  @override
  String get noExternalStorageFound => 'No external storage directories found.';

  @override
  String get showOnboarding => 'Show on-boarding screen:';

  @override
  String get showOnboardingDesc =>
      'Enable to show the on-boarding screen when the app starts';

  @override
  String get dailyReminderTasks => 'Daily reminder to review tasks:';

  @override
  String get dailyReminderCompleted =>
      'Daily reminder to review completed tasks:';

  @override
  String get time => 'Time:';

  @override
  String get notSet => 'Not set';

  @override
  String get clearReminder => 'Clear reminder';

  @override
  String get reviewTasksNotification =>
      'Review your tasks (you can remove this reminder in Settings)';

  @override
  String get reviewCompletedNotification =>
      'Review your completed tasks (you can remove this reminder in Settings)';

  @override
  String get tasksFileName =>
      'File name for adding new tasks (located at the path below):';

  @override
  String get globalTaskFilter => 'Global Task Filter:';

  @override
  String get enterGlobalFilter => 'Enter a global task filter, e.g. #task';

  @override
  String get memosPath => 'Memos Path:';

  @override
  String get memosPathDesc =>
      'Static path (e.g., memos.md) or dynamic path with date variables (e.g., <YYYY>/<YYYY-MM-DD>.md)';

  @override
  String get dynamicPath => 'Dynamic Path:';

  @override
  String get dynamicPathDesc =>
      'Enable if path contains date variables like <YYYY-MM-DD>';

  @override
  String get widgetSortOrder => 'Widget Sort Order:';

  @override
  String get widgetSortOrderDesc =>
      'Ascending shows oldest memos first; Descending shows newest first';

  @override
  String get asc => 'Asc';

  @override
  String get desc => 'Desc';

  @override
  String get memosAttachmentDir => 'Attachment Directory (assets):';

  @override
  String get memosAttachmentDirDesc =>
      'Path relative to Vault, supports date variables. e.g. assets or <YYYY>/assets';

  @override
  String get enterMemosAttachmentDir => 'e.g., assets or <YYYY>/assets';

  @override
  String get imageCompression => 'Image Compression';

  @override
  String get enableCompression => 'Enable Compression';

  @override
  String get enableCompressionDesc => 'Compress images before saving to vault';

  @override
  String get format => 'Format';

  @override
  String get quality => 'Quality:';

  @override
  String get microblogPublishing => 'Microblog Publishing';

  @override
  String get microblogFilename => 'Filename (in Vault)';

  @override
  String get microblogTitle => 'Blog Title';

  @override
  String get microblogPermalink => 'DG Permalink (Slug)';

  @override
  String get microblogPermalinkHelper =>
      'Permanent link suffix (e.g., mysite.com/microblog)';

  @override
  String get microblogTag => 'Filter Tag';

  @override
  String get microblogAvatarPath => 'Avatar Path (in Vault)';

  @override
  String get microblogUsername => 'Username';

  @override
  String get pushConfig => 'Push Configuration (GitHub)';

  @override
  String get repoUrl => 'Repo URL';

  @override
  String get repoPath => 'Target Path in Repo';

  @override
  String get repoImagePath => 'Image Path in Repo';

  @override
  String get webImagePrefix => 'Web Image Prefix';

  @override
  String get personalAccessToken => 'Personal Access Token';

  @override
  String get enterBaseUrl => 'Enter base URL (optional)';

  @override
  String get enterApiKey => 'Enter API Key';

  @override
  String get aiBaseUrl => 'Base URL (e.g. https://api.openai.com/v1):';

  @override
  String get aiApiKey => 'API Key:';

  @override
  String get aiModelName => 'Model Name (e.g. gpt-4o):';

  @override
  String get about => 'About';

  @override
  String get contactDeveloper => 'Contact the developer:';

  @override
  String get version => 'Version:';

  @override
  String couldNotLaunch(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get memosAttachmentDirNotConfigured =>
      'Please configure Memos attachment directory in settings';

  @override
  String get vaultNotConfigured => 'Please configure Vault directory first';

  @override
  String attachmentSaved(Object path) {
    return 'Attachment saved to: $path';
  }

  @override
  String attachmentSaveFailed(Object error) {
    return 'Failed to save attachment: $error';
  }

  @override
  String get microblogNotConfigured =>
      'Please configure Microblog settings (Repo, Token, Path) in settings';

  @override
  String get publishMicroblog => 'Publish Microblog';

  @override
  String publishConfirmation(Object tag) {
    return 'This will aggregate memos with $tag and push to GitHub.\nAre you sure to continue?';
  }

  @override
  String get publish => 'Publish';

  @override
  String get publishing => 'Generating and pushing...';

  @override
  String get pushingContent => 'Pushing content...';

  @override
  String get noAttachmentsUpdated => 'No attachments updated';

  @override
  String attachmentsUploaded(Object count, Object message) {
    return 'Uploaded $count attachments: $message';
  }

  @override
  String newAttachments(Object count) {
    return 'New $count attachments';
  }

  @override
  String publishSuccess(Object message) {
    return 'Published successfully! $message';
  }

  @override
  String publishFailed(Object error) {
    return 'Publish failed: $error';
  }

  @override
  String editingTime(Object time) {
    return 'Editing $time';
  }

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get deleteImageConfirmation =>
      'Are you sure you want to delete this image? This will permanently delete the file from your vault.';

  @override
  String get imageDeleted => 'Image deleted';

  @override
  String deleteFailed(Object error) {
    return 'Failed to delete: $error';
  }

  @override
  String get enterModelName => 'Enter model name';

  @override
  String get dictionaryImported => 'Dictionary imported successfully';

  @override
  String dictionaryImportFailed(Object error) {
    return 'Failed to import dictionary: $error';
  }

  @override
  String get memoHint => 'What\'s on your mind?';

  @override
  String get memoEditHint => 'Modify content...';

  @override
  String get insertTag => 'Insert tag #';

  @override
  String get insertWikiLink => 'Insert link [[]]';

  @override
  String get addAttachment => 'Add attachment';

  @override
  String get jumpToDate => 'Jump to date';

  @override
  String get shareImageError => 'Image path not found in cache';

  @override
  String get manageFilters => 'Manage Filters';

  @override
  String get deleteFilter => 'Delete Filter';

  @override
  String deleteFilterConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get selectWidgetFilter => 'Select Widget Filter';

  @override
  String get defaultFilter => 'Default';

  @override
  String get widgetDisplay => 'Desktop Widget Display';

  @override
  String get filterName => 'Filter Name';

  @override
  String get taskStatus => 'Task Status';

  @override
  String matchConditions(Object mode) {
    return 'Match $mode conditions';
  }

  @override
  String get allMode => 'ALL';

  @override
  String get anyMode => 'ANY';

  @override
  String get addFilterGroup => 'Add Filter Group';

  @override
  String get addCondition => 'Add condition';

  @override
  String get inheritDate => 'Inherit Date from Filename';

  @override
  String get includeTags => 'Tags (Include)';

  @override
  String get excludeTags => 'Excluded Tags';

  @override
  String get enterTagHint => 'Enter tag and click add';

  @override
  String get pathContains => 'File path contains';

  @override
  String get groupBy => 'Group By';

  @override
  String get none => 'None';

  @override
  String get dueDate => 'Due Date';

  @override
  String get scheduledDate => 'Scheduled Date';

  @override
  String get filePath => 'File Path';

  @override
  String get priority => 'Priority';

  @override
  String get status => 'Status';

  @override
  String get sortRules => 'Sort Rules (Priority from top to bottom)';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get createdDate => 'Created Date';

  @override
  String get alphabetical => 'Alphabetical';

  @override
  String get enterFilterName => 'Please enter filter name';

  @override
  String get filterTasks => 'Filter tasks...';

  @override
  String get newFilter => 'New Filter';

  @override
  String get editFilter => 'Edit Filter';

  @override
  String aiDataReview(Object name) {
    return 'Data Review: $name';
  }

  @override
  String get aiDataReviewDesc =>
      'The following data will be sent to AI, please check for sensitive info:';

  @override
  String get noData => '(No data)';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get approved => '✅ User approved data sending';

  @override
  String get rejected => '❌ User rejected data sending';

  @override
  String get editData => 'Edit Data';

  @override
  String get editDataHint => 'Edit data to send to AI...';

  @override
  String get sendEdited => 'Send edited data';

  @override
  String get apiKeyMissing =>
      '❌ API Key missing. Please configure it in Settings > AI Assistant.';

  @override
  String get todayTaskDefaults => 'Today Task Defaults';

  @override
  String newTaskDefaults(Object name) {
    return 'New Task Defaults ($name)';
  }
}
