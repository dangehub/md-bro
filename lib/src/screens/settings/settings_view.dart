import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:obsi/src/core/utils.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:obsi/src/localization/l10n_gen/app_localizations.dart';
import 'package:file_picker/file_picker.dart';

import 'settings_controller.dart';
import 'settings_service.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _dateTemplateController = TextEditingController();
  final _tasksFileNameController = TextEditingController();
  final _globalTaskFilterController = TextEditingController();
  final _aiBaseUrlController = TextEditingController();
  final _aiApiKeyController = TextEditingController();
  final _aiModelNameController = TextEditingController();
  final _memosPathController = TextEditingController();
  final _memosAttachmentDirController = TextEditingController();

  // Image Compression State
  bool _imageCompressionEnabled = true;
  int _imageCompressionQuality = 75;
  String _imageCompressionFormat = 'webp';

  // Microblog State
  final _microblogFilenameController = TextEditingController();
  final _microblogTitleController = TextEditingController();
  final _microblogTagController = TextEditingController();
  final _microblogAvatarPathController = TextEditingController();
  final _microblogUsernameController = TextEditingController();
  final _microblogRepoUrlController = TextEditingController();
  final _microblogRepoTokenController = TextEditingController();
  final _microblogRepoPathController = TextEditingController();
  final _microblogRepoImagePathController = TextEditingController();
  final _microblogWebImagePrefixController = TextEditingController();
  final _microblogPermalinkController = TextEditingController();

  @override
  void initState() {
    _dateTemplateController.text = widget.controller.dateTemplate;
    _tasksFileNameController.text = widget.controller.tasksFile;
    _globalTaskFilterController.text = widget.controller.globalTaskFilter;
    _aiBaseUrlController.text = widget.controller.aiBaseUrl ?? "";
    _aiApiKeyController.text = widget.controller.chatGptKey ?? "";
    _aiModelNameController.text = widget.controller.aiModelName ?? "";
    _memosPathController.text = widget.controller.memosPath ?? "";
    _loadMemosAttachmentDir();
    _loadImageCompressionSettings();
    _loadMicroblogSettings();

    _dateTemplateController.addListener(() {
      widget.controller.updateDateTemplate(_dateTemplateController.text);
    });

    // Listen to controller changes and rebuild UI when needed
    widget.controller.addListener(_onControllerChanged);

    super.initState();
  }

  void _onControllerChanged() {
    setState(() {
      // Trigger rebuild when controller notifies changes
    });
  }

  Future<void> _loadMemosAttachmentDir() async {
    final service = SettingsService();
    final dir = await service.memosAttachmentDirectory();
    _memosAttachmentDirController.text = dir ?? "";
  }

  Future<void> _saveMemosAttachmentDir(String value) async {
    final service = SettingsService();
    await service.updateMemosAttachmentDirectory(value);
  }

  Future<void> _loadImageCompressionSettings() async {
    final service = SettingsService();
    final enabled = await service.imageCompressionEnabled();
    final quality = await service.imageCompressionQuality();
    final format = await service.imageCompressionFormat();
    if (mounted) {
      setState(() {
        _imageCompressionEnabled = enabled;
        _imageCompressionQuality = quality;
        _imageCompressionFormat = format;
      });
    }
  }

  Future<void> _updateImageCompressionEnabled(bool value) async {
    final service = SettingsService();
    await service.updateImageCompressionEnabled(value);
    setState(() {
      _imageCompressionEnabled = value;
    });
  }

  Future<void> _updateImageCompressionQuality(int value) async {
    final service = SettingsService();
    await service.updateImageCompressionQuality(value);
    setState(() {
      _imageCompressionQuality = value;
    });
  }

  Future<void> _updateImageCompressionFormat(String value) async {
    final service = SettingsService();
    await service.updateImageCompressionFormat(value);
    setState(() {
      _imageCompressionFormat = value;
    });
  }

  Future<void> _loadMicroblogSettings() async {
    final service = SettingsService();
    _microblogFilenameController.text = await service.microblogFilename();
    _microblogTitleController.text = await service.microblogTitle();
    _microblogTagController.text = await service.microblogTag();
    _microblogAvatarPathController.text = await service.microblogAvatarPath();
    _microblogUsernameController.text = await service.microblogUsername();
    _microblogRepoUrlController.text = await service.microblogRepoUrl();
    _microblogRepoTokenController.text = await service.microblogRepoToken();
    _microblogRepoPathController.text = await service.microblogRepoPath();
    _microblogRepoImagePathController.text =
        await service.microblogRepoImagePath();
    _microblogWebImagePrefixController.text =
        await service.microblogWebImagePrefix();
    _microblogPermalinkController.text = await service.microblogPermalink();
  }

  Future<void> _saveMicroblogSetting(
      Future<void> Function(String) saveFunc, String value) async {
    await saveFunc(value);
  }

  @override
  void dispose() {
    _tasksFileNameController.dispose();
    _dateTemplateController.dispose();
    _globalTaskFilterController.dispose();
    _aiBaseUrlController.dispose();
    _aiApiKeyController.dispose();
    _aiModelNameController.dispose();
    _memosPathController.dispose();
    _memosAttachmentDirController.dispose();
    _microblogFilenameController.dispose();
    _microblogTitleController.dispose();
    _microblogTagController.dispose();
    _microblogAvatarPathController.dispose();
    _microblogRepoUrlController.dispose();
    _microblogRepoTokenController.dispose();
    _microblogRepoPathController.dispose();
    _microblogRepoImagePathController.dispose();
    _microblogWebImagePrefixController.dispose();
    _microblogPermalinkController.dispose();

    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        bottom: true,
        child: ListView(children: [
          // 0. Language Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(AppLocalizations.of(context)!.language,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: false,
              tilePadding: EdgeInsets.zero,
              children: [
                // Language Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(AppLocalizations.of(context)!.language)),
                      DropdownButton<Locale>(
                        value: widget.controller.locale,
                        items: widget.controller.supportedLocales.map((locale) {
                          return DropdownMenuItem(
                            value: locale,
                            child: Text(_getLocaleDisplayName(locale)),
                          );
                        }).toList(),
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            widget.controller.updateLocale(newLocale);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Import Dictionary
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.importDictionary),
                  trailing: const Icon(Icons.upload_file),
                  onTap: _importDictionary,
                ),

                // Manage Dictionaries
                if (widget.controller.customLanguages.isNotEmpty) ...[
                  const Divider(),
                  Text(AppLocalizations.of(context)!.manageDictionaries,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey)),
                  ...widget.controller.customLanguages.map((lang) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(lang.name),
                        subtitle: Text(lang.locale),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeDictionary(lang.locale),
                        ),
                      )),
                ]
              ],
            ),
          ),
          const Divider(),

          // 1. General Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(AppLocalizations.of(context)!.general,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.vaultFolderPrompt),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.controller.vaultDirectory ??
                                AppLocalizations.of(context)!
                                    .pleaseChooseFolder,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.select),
                            onPressed: () async {
                              var vaultDirectory =
                                  await SettingsController.selectVaultDirectory(
                                      context);

                              if (vaultDirectory != null) {
                                widget.controller
                                    .updateVaultDirectory(vaultDirectory);
                              }
                            }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text(AppLocalizations.of(context)!.showOnboarding)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.showOnboardingDesc,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Switch(
                        value: !widget.controller.onboardingComplete,
                        onChanged: (value) {
                          widget.controller.updateOnboardingComplete(!value);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),
                Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          AppLocalizations.of(context)!.dailyReminderTasks)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("Time: "),
                      addDateTimePicker(
                        widget.controller.reviewTasksReminderTime != null
                            ? Text(
                                DateFormat('HH:mm').format(
                                    widget.controller.reviewTasksReminderTime!),
                                style: const TextStyle(fontSize: 16),
                              )
                            : Text(
                                AppLocalizations.of(context)!.notSet,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                        widget.controller.reviewTasksReminderTime ??
                            DateTime.now(),
                        context,
                        (time) {
                          widget.controller.updateReviewTasksReminderTime(time);
                          setState(() {});
                        },
                        timePicker: true,
                      ),
                      if (widget.controller.reviewTasksReminderTime != null)
                        IconButton(
                          onPressed: () {
                            widget.controller
                                .updateReviewTasksReminderTime(null);
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear reminder',
                        ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),
                Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!
                          .dailyReminderCompleted)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("Time: "),
                      addDateTimePicker(
                        widget.controller.reviewCompletedReminderTime != null
                            ? Text(
                                DateFormat('HH:mm').format(widget
                                    .controller.reviewCompletedReminderTime!),
                                style: const TextStyle(fontSize: 16),
                              )
                            : Text(
                                AppLocalizations.of(context)!.notSet,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                        widget.controller.reviewCompletedReminderTime ??
                            DateTime.now(),
                        context,
                        (time) {
                          widget.controller
                              .updateReviewCompletedReminderTime(time);
                          setState(() {});
                        },
                        timePicker: true,
                      ),
                      if (widget.controller.reviewCompletedReminderTime != null)
                        IconButton(
                          onPressed: () {
                            widget.controller
                                .updateReviewCompletedReminderTime(null);
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear reminder',
                        ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 2. Tasks Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: const Text("Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              tilePadding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.tasksFileName)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tasksFileNameController,
                    onSubmitted: (value) {
                      widget.controller.updateTasksFile(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  )
                ]),
                const SizedBox(height: 16),
                Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text(AppLocalizations.of(context)!.globalTaskFilter)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _globalTaskFilterController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterGlobalFilter,
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      widget.controller.updateGlobalTaskFilter(value);
                    },
                  )
                ]),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 3. Memos Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(AppLocalizations.of(context)!.memos,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              tilePadding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppLocalizations.of(context)!.memosPath),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.memosPathDesc,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _memosPathController,
                    decoration: const InputDecoration(
                      hintText: "Enter memos path or template",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      widget.controller.updateMemosPath(value);
                    },
                  ),
                ]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.dynamicPath),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.dynamicPathDesc,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: widget.controller.memosPathIsDynamic,
                      onChanged: (value) {
                        widget.controller.updateMemosPathIsDynamic(value);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.widgetSortOrder),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.widgetSortOrderDesc,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: true,
                          label: Text(AppLocalizations.of(context)!.asc),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text(AppLocalizations.of(context)!.desc),
                        ),
                      ],
                      selected: {widget.controller.memosWidgetSortAscending},
                      onSelectionChanged: (selected) {
                        widget.controller
                            .updateMemosWidgetSortAscending(selected.first);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.memosAttachmentDir),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.memosAttachmentDirDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _memosAttachmentDirController,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.enterMemosAttachmentDir,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    _saveMemosAttachmentDir(value);
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                Text(AppLocalizations.of(context)!.imageCompression,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.enableCompression),
                  subtitle:
                      Text(AppLocalizations.of(context)!.enableCompressionDesc),
                  value: _imageCompressionEnabled,
                  onChanged: _updateImageCompressionEnabled,
                ),
                if (_imageCompressionEnabled) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _imageCompressionFormat,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.format,
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'webp',
                          child: Text(
                              'WebP (Recommended)')), // Keep WebP as tech term?
                      DropdownMenuItem(value: 'jpeg', child: Text('JPEG')),
                      DropdownMenuItem(value: 'png', child: Text('PNG')),
                    ],
                    onChanged: (value) {
                      if (value != null) _updateImageCompressionFormat(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("${AppLocalizations.of(context)!.quality} "),
                      Expanded(
                        child: Slider(
                          value: _imageCompressionQuality.toDouble(),
                          min: 1,
                          max: 100,
                          divisions: 99,
                          label: _imageCompressionQuality.toString(),
                          onChanged: (value) {
                            _updateImageCompressionQuality(value.round());
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          "$_imageCompressionQuality%",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(),
                Text(AppLocalizations.of(context)!.microblogPublishing,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _microblogFilenameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.microblogFilename,
                    hintText: "function/microblog.md",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogFilename, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogTitleController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.microblogTitle,
                    hintText: "My Microblog",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogTitle, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogPermalinkController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.microblogPermalink,
                    hintText: "microblog",
                    helperText:
                        AppLocalizations.of(context)!.microblogPermalinkHelper,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogPermalink, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogTagController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.microblogTag,
                    hintText: "#mb",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogTag, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogAvatarPathController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.microblogAvatarPath,
                    hintText: "assets/avatar.png",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogAvatarPath, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogUsernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.microblogUsername,
                    hintText: "Me",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogUsername, val),
                ),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.pushConfig,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogRepoUrlController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.repoUrl,
                    hintText: "https://github.com/user/repo.git",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogRepoUrl, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogRepoPathController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.repoPath,
                    hintText: "src/site/notes/",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogRepoPath, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogRepoImagePathController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.repoImagePath,
                    hintText: "src/site/img/user/microblog",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogRepoImagePath, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogWebImagePrefixController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.webImagePrefix,
                    hintText: "/img/user/microblog",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogWebImagePrefix, val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _microblogRepoTokenController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.personalAccessToken,
                    hintText: "github_pat_...",
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (val) => _saveMicroblogSetting(
                      SettingsService().updateMicroblogRepoToken, val),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 4. AI Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(AppLocalizations.of(context)!.aiAssistant,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              tilePadding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.aiBaseUrl),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aiBaseUrlController,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterBaseUrl,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        widget.controller.updateAiBaseUrl(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.aiApiKey),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aiApiKeyController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterApiKey,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        widget.controller.updateChatGptKey(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.aiModelName),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aiModelNameController,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterModelName,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        widget.controller.updateAiModelName(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text(AppLocalizations.of(context)!.contactDeveloper),
                GestureDetector(
                  onTap: () {
                    _launchEmail(context);
                  },
                  child: const Text("wanyy314@foxmail.com",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      )),
                )
              ])),

          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const SizedBox(height: 1),
                FutureBuilder<String>(
                  future: widget.controller.getAppVersion(),
                  builder: (context, snapshot) {
                    return Text(
                      '${AppLocalizations.of(context)!.version} ${snapshot.data ?? 'Loading...'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ])),
        ]),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: "wanyy314@foxmail.com",
      query: 'subject=MD Bro', // Optional query parameters
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!
                .couldNotLaunch(emailUri.toString()))),
      );
    }
  }

  String _getLocaleDisplayName(Locale locale) {
    if (locale.languageCode == 'en') return 'English';
    if (locale.languageCode == 'zh') return '简体中文';

    // For custom languages, find the name
    try {
      final custom = widget.controller.customLanguages.firstWhere(
        (l) => l.locale == locale.languageCode,
      );
      return custom.name;
    } catch (_) {
      return locale.languageCode;
    }
  }

  Future<void> _importDictionary() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      try {
        await widget.controller.importDictionary(result.files.single.path!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.dictionaryImported)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .dictionaryImportFailed("$e"))),
          );
        }
      }
    }
  }

  Future<void> _removeDictionary(String locale) async {
    await widget.controller.removeDictionary(locale);
    setState(() {});
  }
}
