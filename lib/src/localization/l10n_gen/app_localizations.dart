import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n_gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'MD Bro'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @memos.
  ///
  /// In en, this message translates to:
  /// **'Memos'**
  String get memos;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @importDictionary.
  ///
  /// In en, this message translates to:
  /// **'Import Dictionary'**
  String get importDictionary;

  /// No description provided for @manageDictionaries.
  ///
  /// In en, this message translates to:
  /// **'Manage Dictionaries'**
  String get manageDictionaries;

  /// No description provided for @vaultFolderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Folder in the Obsidian vault containing tasks:'**
  String get vaultFolderPrompt;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @pleaseChooseFolder.
  ///
  /// In en, this message translates to:
  /// **'<Please choose the folder>'**
  String get pleaseChooseFolder;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to select a directory.'**
  String get storagePermissionRequired;

  /// No description provided for @noExternalStorageFound.
  ///
  /// In en, this message translates to:
  /// **'No external storage directories found.'**
  String get noExternalStorageFound;

  /// No description provided for @showOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Show on-boarding screen:'**
  String get showOnboarding;

  /// No description provided for @showOnboardingDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable to show the on-boarding screen when the app starts'**
  String get showOnboardingDesc;

  /// No description provided for @dailyReminderTasks.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder to review tasks:'**
  String get dailyReminderTasks;

  /// No description provided for @dailyReminderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder to review completed tasks:'**
  String get dailyReminderCompleted;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get time;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @clearReminder.
  ///
  /// In en, this message translates to:
  /// **'Clear reminder'**
  String get clearReminder;

  /// No description provided for @reviewTasksNotification.
  ///
  /// In en, this message translates to:
  /// **'Review your tasks (you can remove this reminder in Settings)'**
  String get reviewTasksNotification;

  /// No description provided for @reviewCompletedNotification.
  ///
  /// In en, this message translates to:
  /// **'Review your completed tasks (you can remove this reminder in Settings)'**
  String get reviewCompletedNotification;

  /// No description provided for @tasksFileName.
  ///
  /// In en, this message translates to:
  /// **'File name for adding new tasks (located at the path below):'**
  String get tasksFileName;

  /// No description provided for @globalTaskFilter.
  ///
  /// In en, this message translates to:
  /// **'Global Task Filter:'**
  String get globalTaskFilter;

  /// No description provided for @enterGlobalFilter.
  ///
  /// In en, this message translates to:
  /// **'Enter a global task filter, e.g. #task'**
  String get enterGlobalFilter;

  /// No description provided for @memosPath.
  ///
  /// In en, this message translates to:
  /// **'Memos Path:'**
  String get memosPath;

  /// No description provided for @memosPathDesc.
  ///
  /// In en, this message translates to:
  /// **'Static path (e.g., memos.md) or dynamic path with date variables (e.g., <YYYY>/<YYYY-MM-DD>.md)'**
  String get memosPathDesc;

  /// No description provided for @dynamicPath.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Path:'**
  String get dynamicPath;

  /// No description provided for @dynamicPathDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable if path contains date variables like <YYYY-MM-DD>'**
  String get dynamicPathDesc;

  /// No description provided for @widgetSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Widget Sort Order:'**
  String get widgetSortOrder;

  /// No description provided for @widgetSortOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Ascending shows oldest memos first; Descending shows newest first'**
  String get widgetSortOrderDesc;

  /// No description provided for @asc.
  ///
  /// In en, this message translates to:
  /// **'Asc'**
  String get asc;

  /// No description provided for @desc.
  ///
  /// In en, this message translates to:
  /// **'Desc'**
  String get desc;

  /// No description provided for @memosAttachmentDir.
  ///
  /// In en, this message translates to:
  /// **'Attachment Directory (assets):'**
  String get memosAttachmentDir;

  /// No description provided for @memosAttachmentDirDesc.
  ///
  /// In en, this message translates to:
  /// **'Path relative to Vault, supports date variables. e.g. assets or <YYYY>/assets'**
  String get memosAttachmentDirDesc;

  /// No description provided for @enterMemosAttachmentDir.
  ///
  /// In en, this message translates to:
  /// **'e.g., assets or <YYYY>/assets'**
  String get enterMemosAttachmentDir;

  /// No description provided for @imageCompression.
  ///
  /// In en, this message translates to:
  /// **'Image Compression'**
  String get imageCompression;

  /// No description provided for @enableCompression.
  ///
  /// In en, this message translates to:
  /// **'Enable Compression'**
  String get enableCompression;

  /// No description provided for @enableCompressionDesc.
  ///
  /// In en, this message translates to:
  /// **'Compress images before saving to vault'**
  String get enableCompressionDesc;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality:'**
  String get quality;

  /// No description provided for @microblogPublishing.
  ///
  /// In en, this message translates to:
  /// **'Microblog Publishing'**
  String get microblogPublishing;

  /// No description provided for @microblogFilename.
  ///
  /// In en, this message translates to:
  /// **'Filename (in Vault)'**
  String get microblogFilename;

  /// No description provided for @microblogTitle.
  ///
  /// In en, this message translates to:
  /// **'Blog Title'**
  String get microblogTitle;

  /// No description provided for @microblogPermalink.
  ///
  /// In en, this message translates to:
  /// **'DG Permalink (Slug)'**
  String get microblogPermalink;

  /// No description provided for @microblogPermalinkHelper.
  ///
  /// In en, this message translates to:
  /// **'Permanent link suffix (e.g., mysite.com/microblog)'**
  String get microblogPermalinkHelper;

  /// No description provided for @microblogTag.
  ///
  /// In en, this message translates to:
  /// **'Filter Tag'**
  String get microblogTag;

  /// No description provided for @microblogAvatarPath.
  ///
  /// In en, this message translates to:
  /// **'Avatar Path (in Vault)'**
  String get microblogAvatarPath;

  /// No description provided for @microblogUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get microblogUsername;

  /// No description provided for @pushConfig.
  ///
  /// In en, this message translates to:
  /// **'Push Configuration (GitHub)'**
  String get pushConfig;

  /// No description provided for @repoUrl.
  ///
  /// In en, this message translates to:
  /// **'Repo URL'**
  String get repoUrl;

  /// No description provided for @repoPath.
  ///
  /// In en, this message translates to:
  /// **'Target Path in Repo'**
  String get repoPath;

  /// No description provided for @repoImagePath.
  ///
  /// In en, this message translates to:
  /// **'Image Path in Repo'**
  String get repoImagePath;

  /// No description provided for @webImagePrefix.
  ///
  /// In en, this message translates to:
  /// **'Web Image Prefix'**
  String get webImagePrefix;

  /// No description provided for @personalAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Personal Access Token'**
  String get personalAccessToken;

  /// No description provided for @enterBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter base URL (optional)'**
  String get enterBaseUrl;

  /// No description provided for @enterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter API Key'**
  String get enterApiKey;

  /// No description provided for @aiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL (e.g. https://api.openai.com/v1):'**
  String get aiBaseUrl;

  /// No description provided for @aiApiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key:'**
  String get aiApiKey;

  /// No description provided for @aiModelName.
  ///
  /// In en, this message translates to:
  /// **'Model Name (e.g. gpt-4o):'**
  String get aiModelName;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contactDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer:'**
  String get contactDeveloper;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version:'**
  String get version;

  /// No description provided for @couldNotLaunch.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunch(Object url);

  /// No description provided for @memosAttachmentDirNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Please configure Memos attachment directory in settings'**
  String get memosAttachmentDirNotConfigured;

  /// No description provided for @vaultNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Please configure Vault directory first'**
  String get vaultNotConfigured;

  /// No description provided for @attachmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Attachment saved to: {path}'**
  String attachmentSaved(Object path);

  /// No description provided for @attachmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save attachment: {error}'**
  String attachmentSaveFailed(Object error);

  /// No description provided for @microblogNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Please configure Microblog settings (Repo, Token, Path) in settings'**
  String get microblogNotConfigured;

  /// No description provided for @publishMicroblog.
  ///
  /// In en, this message translates to:
  /// **'Publish Microblog'**
  String get publishMicroblog;

  /// No description provided for @publishConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will aggregate memos with {tag} and push to GitHub.\nAre you sure to continue?'**
  String publishConfirmation(Object tag);

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @publishing.
  ///
  /// In en, this message translates to:
  /// **'Generating and pushing...'**
  String get publishing;

  /// No description provided for @pushingContent.
  ///
  /// In en, this message translates to:
  /// **'Pushing content...'**
  String get pushingContent;

  /// No description provided for @noAttachmentsUpdated.
  ///
  /// In en, this message translates to:
  /// **'No attachments updated'**
  String get noAttachmentsUpdated;

  /// No description provided for @attachmentsUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {count} attachments: {message}'**
  String attachmentsUploaded(Object count, Object message);

  /// No description provided for @newAttachments.
  ///
  /// In en, this message translates to:
  /// **'New {count} attachments'**
  String newAttachments(Object count);

  /// No description provided for @publishSuccess.
  ///
  /// In en, this message translates to:
  /// **'Published successfully! {message}'**
  String publishSuccess(Object message);

  /// No description provided for @publishFailed.
  ///
  /// In en, this message translates to:
  /// **'Publish failed: {error}'**
  String publishFailed(Object error);

  /// No description provided for @editingTime.
  ///
  /// In en, this message translates to:
  /// **'Editing {time}'**
  String editingTime(Object time);

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @deleteImageConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image? This will permanently delete the file from your vault.'**
  String get deleteImageConfirmation;

  /// No description provided for @imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image deleted'**
  String get imageDeleted;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @filterScheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date'**
  String get filterScheduledDate;

  /// No description provided for @filterDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get filterDueDate;

  /// No description provided for @filterTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get filterTag;

  /// No description provided for @filterPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get filterPath;

  /// No description provided for @filterPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get filterPriority;

  /// No description provided for @opAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get opAny;

  /// No description provided for @opIs.
  ///
  /// In en, this message translates to:
  /// **'Is'**
  String get opIs;

  /// No description provided for @opIsNot.
  ///
  /// In en, this message translates to:
  /// **'Is not'**
  String get opIsNot;

  /// No description provided for @opIsBefore.
  ///
  /// In en, this message translates to:
  /// **'Is before'**
  String get opIsBefore;

  /// No description provided for @opIsAfter.
  ///
  /// In en, this message translates to:
  /// **'Is after'**
  String get opIsAfter;

  /// No description provided for @opIsToday.
  ///
  /// In en, this message translates to:
  /// **'Is today'**
  String get opIsToday;

  /// No description provided for @opIsBeforeToday.
  ///
  /// In en, this message translates to:
  /// **'Is before today'**
  String get opIsBeforeToday;

  /// No description provided for @opIsAfterToday.
  ///
  /// In en, this message translates to:
  /// **'Is after today'**
  String get opIsAfterToday;

  /// No description provided for @opIsInNextDays.
  ///
  /// In en, this message translates to:
  /// **'Is in next days'**
  String get opIsInNextDays;

  /// No description provided for @opIsInPrevDays.
  ///
  /// In en, this message translates to:
  /// **'Is in previous days'**
  String get opIsInPrevDays;

  /// No description provided for @opIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Is empty'**
  String get opIsEmpty;

  /// No description provided for @opIsNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Is not empty'**
  String get opIsNotEmpty;

  /// No description provided for @taskStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get taskStatusAll;

  /// No description provided for @taskStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get taskStatusTodo;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @labelMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get labelMatch;

  /// No description provided for @labelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// No description provided for @labelAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get labelAny;

  /// No description provided for @labelConditions.
  ///
  /// In en, this message translates to:
  /// **'conditions'**
  String get labelConditions;

  /// No description provided for @btnAddCondition.
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get btnAddCondition;

  /// No description provided for @hintDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get hintDays;

  /// No description provided for @hintTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get hintTag;

  /// No description provided for @hintPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get hintPath;

  /// No description provided for @hintPriority.
  ///
  /// In en, this message translates to:
  /// **'1-5'**
  String get hintPriority;

  /// No description provided for @btnSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get btnSelectDate;

  /// No description provided for @msgEnterFilterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a filter name'**
  String get msgEnterFilterName;

  /// No description provided for @titleNewFilter.
  ///
  /// In en, this message translates to:
  /// **'New Filter'**
  String get titleNewFilter;

  /// No description provided for @titleEditFilter.
  ///
  /// In en, this message translates to:
  /// **'Edit Filter'**
  String get titleEditFilter;

  /// No description provided for @labelFilterName.
  ///
  /// In en, this message translates to:
  /// **'Filter Name'**
  String get labelFilterName;

  /// No description provided for @headerFilterConditions.
  ///
  /// In en, this message translates to:
  /// **'Filter Conditions'**
  String get headerFilterConditions;

  /// No description provided for @memosToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get memosToday;

  /// No description provided for @memosYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get memosYesterday;

  /// No description provided for @btnSelectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get btnSelectMonth;

  /// No description provided for @labelYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get labelYear;

  /// No description provided for @labelMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get labelMonth;

  /// No description provided for @labelInheritDate.
  ///
  /// In en, this message translates to:
  /// **'Inherit Date from Filename'**
  String get labelInheritDate;

  /// No description provided for @labelTagsInclude.
  ///
  /// In en, this message translates to:
  /// **'Tags (Include)'**
  String get labelTagsInclude;

  /// No description provided for @labelTagsExclude.
  ///
  /// In en, this message translates to:
  /// **'Excluded Tags'**
  String get labelTagsExclude;

  /// No description provided for @hintEnterTag.
  ///
  /// In en, this message translates to:
  /// **'Enter tag and submit'**
  String get hintEnterTag;

  /// No description provided for @labelPathContains.
  ///
  /// In en, this message translates to:
  /// **'Path Contains'**
  String get labelPathContains;

  /// No description provided for @hintPathExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Work/Projects'**
  String get hintPathExample;

  /// No description provided for @labelGroupBy.
  ///
  /// In en, this message translates to:
  /// **'Group By'**
  String get labelGroupBy;

  /// No description provided for @groupNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get groupNone;

  /// No description provided for @groupDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get groupDueDate;

  /// No description provided for @groupScheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date'**
  String get groupScheduledDate;

  /// No description provided for @groupFilePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get groupFilePath;

  /// No description provided for @groupPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get groupPriority;

  /// No description provided for @groupStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get groupStatus;

  /// No description provided for @labelSortRules.
  ///
  /// In en, this message translates to:
  /// **'Sorting Rules'**
  String get labelSortRules;

  /// No description provided for @sortAsc.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortAsc;

  /// No description provided for @sortDesc.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortDesc;

  /// No description provided for @sortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortAlphabetical;

  /// No description provided for @sortCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get sortCreatedDate;

  /// No description provided for @btnAddSortRule.
  ///
  /// In en, this message translates to:
  /// **'Add Sort Rule'**
  String get btnAddSortRule;

  /// No description provided for @headerNewTaskDefaults.
  ///
  /// In en, this message translates to:
  /// **'New Task Defaults'**
  String get headerNewTaskDefaults;

  /// No description provided for @labelDefaultTags.
  ///
  /// In en, this message translates to:
  /// **'Default Tags'**
  String get labelDefaultTags;

  /// No description provided for @hintDefaultTag.
  ///
  /// In en, this message translates to:
  /// **'Enter default tag'**
  String get hintDefaultTag;

  /// No description provided for @labelDefaultDueDate.
  ///
  /// In en, this message translates to:
  /// **'Default Due Date'**
  String get labelDefaultDueDate;

  /// No description provided for @labelOffsetDays.
  ///
  /// In en, this message translates to:
  /// **'Offset Days (0=Today)'**
  String get labelOffsetDays;

  /// No description provided for @labelSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific Date'**
  String get labelSpecificDate;

  /// No description provided for @datePresetNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get datePresetNone;

  /// No description provided for @datePresetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get datePresetToday;

  /// No description provided for @datePresetTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get datePresetTomorrow;

  /// No description provided for @datePresetTodayPlusDays.
  ///
  /// In en, this message translates to:
  /// **'Today + Days'**
  String get datePresetTodayPlusDays;

  /// No description provided for @actionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get actionKeep;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get actionArchive;

  /// No description provided for @titleManageFilters.
  ///
  /// In en, this message translates to:
  /// **'Manage Filters'**
  String get titleManageFilters;

  /// No description provided for @labelWidgetDisplay.
  ///
  /// In en, this message translates to:
  /// **'Widget Display'**
  String get labelWidgetDisplay;

  /// No description provided for @labelDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get labelDefault;

  /// No description provided for @confirmDeleteFilter.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteFilter(String name);

  /// No description provided for @titleDeleteFilter.
  ///
  /// In en, this message translates to:
  /// **'Delete Filter'**
  String get titleDeleteFilter;

  /// No description provided for @titleSelectWidgetFilter.
  ///
  /// In en, this message translates to:
  /// **'Select Widget Filter'**
  String get titleSelectWidgetFilter;

  /// No description provided for @labelCompletionAction.
  ///
  /// In en, this message translates to:
  /// **'Completion Action'**
  String get labelCompletionAction;

  /// No description provided for @headerTaskStatus.
  ///
  /// In en, this message translates to:
  /// **'Task Status'**
  String get headerTaskStatus;

  /// No description provided for @labelTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get labelTask;

  /// No description provided for @labelTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Task description'**
  String get labelTaskDescription;

  /// No description provided for @hintEnterTask.
  ///
  /// In en, this message translates to:
  /// **'Enter your task here'**
  String get hintEnterTask;

  /// No description provided for @labelTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get labelTags;

  /// No description provided for @msgNoTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags available'**
  String get msgNoTagsAvailable;

  /// No description provided for @headerPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get headerPlanning;

  /// No description provided for @labelPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get labelPriority;

  /// No description provided for @labelRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get labelRecurrence;

  /// No description provided for @labelDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get labelDue;

  /// No description provided for @labelScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get labelScheduled;

  /// No description provided for @labelStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get labelStart;

  /// No description provided for @headerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get headerNotifications;

  /// No description provided for @labelScheduledNotification.
  ///
  /// In en, this message translates to:
  /// **'Scheduled notification'**
  String get labelScheduledNotification;

  /// No description provided for @headerStatusMetadata.
  ///
  /// In en, this message translates to:
  /// **'Status & metadata'**
  String get headerStatusMetadata;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get labelCreated;

  /// No description provided for @labelDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get labelDone;

  /// No description provided for @labelCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get labelCancelled;

  /// No description provided for @priorityLowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get priorityLowest;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityHighest.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get priorityHighest;

  /// No description provided for @taskStatusInprogress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get taskStatusInprogress;

  /// No description provided for @taskStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get taskStatusCancelled;

  /// No description provided for @recurrenceNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get recurrenceNone;

  /// No description provided for @recurrenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get recurrenceDaily;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get recurrenceMonthly;

  /// No description provided for @recurrenceYearly.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get recurrenceYearly;

  /// No description provided for @recurrenceWeekday.
  ///
  /// In en, this message translates to:
  /// **'Every weekday'**
  String get recurrenceWeekday;

  /// No description provided for @recurrenceMonday.
  ///
  /// In en, this message translates to:
  /// **'Every Monday'**
  String get recurrenceMonday;

  /// No description provided for @recurrenceTuesday.
  ///
  /// In en, this message translates to:
  /// **'Every Tuesday'**
  String get recurrenceTuesday;

  /// No description provided for @recurrenceWednesday.
  ///
  /// In en, this message translates to:
  /// **'Every Wednesday'**
  String get recurrenceWednesday;

  /// No description provided for @recurrenceThursday.
  ///
  /// In en, this message translates to:
  /// **'Every Thursday'**
  String get recurrenceThursday;

  /// No description provided for @recurrenceFriday.
  ///
  /// In en, this message translates to:
  /// **'Every Friday'**
  String get recurrenceFriday;

  /// No description provided for @recurrenceSaturday.
  ///
  /// In en, this message translates to:
  /// **'Every Saturday'**
  String get recurrenceSaturday;

  /// No description provided for @recurrenceSunday.
  ///
  /// In en, this message translates to:
  /// **'Every Sunday'**
  String get recurrenceSunday;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String deleteFailed(Object error);

  /// No description provided for @enterModelName.
  ///
  /// In en, this message translates to:
  /// **'Enter model name'**
  String get enterModelName;

  /// No description provided for @dictionaryImported.
  ///
  /// In en, this message translates to:
  /// **'Dictionary imported successfully'**
  String get dictionaryImported;

  /// No description provided for @dictionaryImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import dictionary: {error}'**
  String dictionaryImportFailed(Object error);

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get memoHint;

  /// No description provided for @memoEditHint.
  ///
  /// In en, this message translates to:
  /// **'Modify content...'**
  String get memoEditHint;

  /// No description provided for @insertTag.
  ///
  /// In en, this message translates to:
  /// **'Insert tag #'**
  String get insertTag;

  /// No description provided for @insertWikiLink.
  ///
  /// In en, this message translates to:
  /// **'Insert link [[]]'**
  String get insertWikiLink;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get addAttachment;

  /// No description provided for @jumpToDate.
  ///
  /// In en, this message translates to:
  /// **'Jump to date'**
  String get jumpToDate;

  /// No description provided for @shareImageError.
  ///
  /// In en, this message translates to:
  /// **'Image path not found in cache'**
  String get shareImageError;

  /// No description provided for @manageFilters.
  ///
  /// In en, this message translates to:
  /// **'Manage Filters'**
  String get manageFilters;

  /// No description provided for @deleteFilter.
  ///
  /// In en, this message translates to:
  /// **'Delete Filter'**
  String get deleteFilter;

  /// No description provided for @deleteFilterConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteFilterConfirmation(Object name);

  /// No description provided for @selectWidgetFilter.
  ///
  /// In en, this message translates to:
  /// **'Select Widget Filter'**
  String get selectWidgetFilter;

  /// No description provided for @defaultFilter.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultFilter;

  /// No description provided for @widgetDisplay.
  ///
  /// In en, this message translates to:
  /// **'Desktop Widget Display'**
  String get widgetDisplay;

  /// No description provided for @filterName.
  ///
  /// In en, this message translates to:
  /// **'Filter Name'**
  String get filterName;

  /// No description provided for @taskStatus.
  ///
  /// In en, this message translates to:
  /// **'Task Status'**
  String get taskStatus;

  /// No description provided for @matchConditions.
  ///
  /// In en, this message translates to:
  /// **'Match {mode} conditions'**
  String matchConditions(Object mode);

  /// No description provided for @allMode.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get allMode;

  /// No description provided for @anyMode.
  ///
  /// In en, this message translates to:
  /// **'ANY'**
  String get anyMode;

  /// No description provided for @addFilterGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Filter Group'**
  String get addFilterGroup;

  /// No description provided for @addCondition.
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get addCondition;

  /// No description provided for @inheritDate.
  ///
  /// In en, this message translates to:
  /// **'Inherit Date from Filename'**
  String get inheritDate;

  /// No description provided for @includeTags.
  ///
  /// In en, this message translates to:
  /// **'Tags (Include)'**
  String get includeTags;

  /// No description provided for @excludeTags.
  ///
  /// In en, this message translates to:
  /// **'Excluded Tags'**
  String get excludeTags;

  /// No description provided for @enterTagHint.
  ///
  /// In en, this message translates to:
  /// **'Enter tag and click add'**
  String get enterTagHint;

  /// No description provided for @pathContains.
  ///
  /// In en, this message translates to:
  /// **'File path contains'**
  String get pathContains;

  /// No description provided for @groupBy.
  ///
  /// In en, this message translates to:
  /// **'Group By'**
  String get groupBy;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @scheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date'**
  String get scheduledDate;

  /// No description provided for @filePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get filePath;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @sortRules.
  ///
  /// In en, this message translates to:
  /// **'Sort Rules (Priority from top to bottom)'**
  String get sortRules;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @alphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get alphabetical;

  /// No description provided for @enterFilterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter filter name'**
  String get enterFilterName;

  /// No description provided for @filterTasks.
  ///
  /// In en, this message translates to:
  /// **'Filter tasks...'**
  String get filterTasks;

  /// No description provided for @newFilter.
  ///
  /// In en, this message translates to:
  /// **'New Filter'**
  String get newFilter;

  /// No description provided for @editFilter.
  ///
  /// In en, this message translates to:
  /// **'Edit Filter'**
  String get editFilter;

  /// No description provided for @aiDataReview.
  ///
  /// In en, this message translates to:
  /// **'Data Review: {name}'**
  String aiDataReview(Object name);

  /// No description provided for @aiDataReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'The following data will be sent to AI, please check for sensitive info:'**
  String get aiDataReviewDesc;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'(No data)'**
  String get noData;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'✅ User approved data sending'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'❌ User rejected data sending'**
  String get rejected;

  /// No description provided for @editData.
  ///
  /// In en, this message translates to:
  /// **'Edit Data'**
  String get editData;

  /// No description provided for @editDataHint.
  ///
  /// In en, this message translates to:
  /// **'Edit data to send to AI...'**
  String get editDataHint;

  /// No description provided for @sendEdited.
  ///
  /// In en, this message translates to:
  /// **'Send edited data'**
  String get sendEdited;

  /// No description provided for @apiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'❌ API Key missing. Please configure it in Settings > AI Assistant.'**
  String get apiKeyMissing;

  /// No description provided for @todayTaskDefaults.
  ///
  /// In en, this message translates to:
  /// **'Today Task Defaults'**
  String get todayTaskDefaults;

  /// No description provided for @newTaskDefaults.
  ///
  /// In en, this message translates to:
  /// **'New Task Defaults ({name})'**
  String newTaskDefaults(Object name);

  /// No description provided for @setDate.
  ///
  /// In en, this message translates to:
  /// **'Set Date'**
  String get setDate;

  /// No description provided for @setTime.
  ///
  /// In en, this message translates to:
  /// **'Set Time'**
  String get setTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
