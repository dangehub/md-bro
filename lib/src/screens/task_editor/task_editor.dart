import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:obsi/src/core/tasks/markdown_task_markers.dart';
import 'package:obsi/src/core/tasks/reccurent_task.dart';
import 'package:obsi/src/core/utils.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';
import 'package:obsi/src/core/tasks/task.dart';
import 'package:obsi/src/screens/task_editor/cubit/task_editor_cubit.dart';
import 'package:obsi/src/localization/l10n_gen/app_localizations.dart';
//import 'package:url_launcher/url_launcher.dart';

class TaskEditor extends StatefulWidget {
  const TaskEditor({Key? key}) : super(key: key);

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  TaskPriority _taskPriority = TaskPriority.normal;
  Text _dueDate = const Text("");
  Text _scheduledDate = const Text("");
  Text _reminderDate = const Text("");
  Text _reminderTime = const Text("");
  Text _startDate = const Text("");
  Text _createdDate = const Text("");
  Text _doneDate = const Text("");
  Text _cancelledDate = const Text("");
  TaskStatus _taskStatus = TaskStatus.todo;
  Text _taskSource = const Text("");
  // Fixed width for labels to keep controls aligned
  final double _labelWidth = 160.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: BlocBuilder<TaskEditorCubit, TaskEditorState>(
        builder: (context, state) {
          if (state is TaskEditorInitial) {
            _init(state.task);
            return SafeArea(
              child: Column(children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      // Description & Tags
                      _buildSection(
                        context,
                        icon: Icons.description_outlined,
                        title: AppLocalizations.of(context)!.labelTask,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: state.task?.description ?? '',
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.hintEnterTask,
                              labelText: AppLocalizations.of(context)!
                                  .labelTaskDescription,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<TaskEditorCubit>()
                                  .setDescription(value);
                            },
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.labelTags,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildTagCloud(context, state),
                            ],
                          ),
                        ],
                      ),

                      // Planning
                      _buildSection(
                        context,
                        icon: Icons.event_note_outlined,
                        title: AppLocalizations.of(context)!.headerPlanning,
                        children: [
                          _buildLabeledRow(
                            "${AppLocalizations.of(context)!.labelPriority}:",
                            DropdownButton<TaskPriority>(
                              isExpanded: true,
                              items: TaskPriority.values
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child:
                                            Text(_getPriorityName(context, e)),
                                      ))
                                  .toList(),
                              value: _taskPriority,
                              onChanged: (value) {
                                if (value == null) return;
                                _taskPriority = value;
                                context
                                    .read<TaskEditorCubit>()
                                    .setPriority(value);
                                setState(() {});
                              },
                            ),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.recurringDateMarker} ${AppLocalizations.of(context)!.labelRecurrence}:",
                            _buildRecurrenceControl(context, state),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.dueDateMarker} ${AppLocalizations.of(context)!.labelDue}:",
                            Row(children: [
                              addDateTimePicker(
                                  _dueDate, state.task?.due, context, (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setDueDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setDueDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.scheduledDateMarker} ${AppLocalizations.of(context)!.labelScheduled}:",
                            Row(children: [
                              addDateTimePicker(_scheduledDate,
                                  state.task?.scheduled, context, (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setScheduledDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setScheduledDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.startDateMarker} ${AppLocalizations.of(context)!.labelStart}:",
                            Row(children: [
                              addDateTimePicker(
                                  _startDate, state.task?.start, context,
                                  (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setStartDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setStartDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                        ],
                      ),

                      // Notifications
                      _buildSection(
                        context,
                        icon: Icons.notifications_outlined,
                        title:
                            AppLocalizations.of(context)!.headerNotifications,
                        children: [
                          _buildLabeledRow(
                            "${AppLocalizations.of(context)!.labelScheduledNotification}:",
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  addDateTimePicker(
                                    _reminderDate,
                                    state.task?.reminder ?? DateTime.now(),
                                    context,
                                    (date) {
                                      // Update Date part only
                                      var currentReminder =
                                          state.task?.reminder ??
                                              DateTime.now();
                                      // Use default time from settings if reminder was null
                                      if (state.task?.reminder == null) {
                                        // Parse default time
                                        var defaultTimeStr =
                                            SettingsController.getInstance()
                                                .defaultReminderTime;
                                        var defaultTime = DateFormat("HH:mm")
                                            .parse(defaultTimeStr);
                                        currentReminder = DateTime(
                                            date.year,
                                            date.month,
                                            date.day,
                                            defaultTime.hour,
                                            defaultTime.minute);
                                      } else {
                                        currentReminder = DateTime(
                                            date.year,
                                            date.month,
                                            date.day,
                                            currentReminder.hour,
                                            currentReminder.minute);
                                      }
                                      context
                                          .read<TaskEditorCubit>()
                                          .setReminder(currentReminder);
                                    },
                                    timePicker: false,
                                  ),
                                  const Text(":"),
                                  addDateTimePicker(
                                    _reminderTime,
                                    state.task?.reminder ?? DateTime.now(),
                                    context,
                                    (time) {
                                      // Update Time part only
                                      var currentReminder =
                                          state.task?.reminder ??
                                              DateTime.now();
                                      currentReminder = DateTime(
                                          currentReminder.year,
                                          currentReminder.month,
                                          currentReminder.day,
                                          time.hour,
                                          time.minute);
                                      context
                                          .read<TaskEditorCubit>()
                                          .setReminder(currentReminder);
                                    },
                                    timePicker: true,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<TaskEditorCubit>()
                                            .setReminder(null);
                                      },
                                      icon: const Icon(Icons.clear_rounded))
                                ])),
                          ),
                        ],
                      ),

                      // Status & metadata
                      _buildSection(
                        context,
                        icon: Icons.info_outline,
                        title:
                            AppLocalizations.of(context)!.headerStatusMetadata,
                        children: [
                          _buildLabeledRow(
                            "${AppLocalizations.of(context)!.labelStatus}:",
                            DropdownButton<TaskStatus>(
                              isExpanded: true,
                              items: TaskStatus.values
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(_getStatusName(context, e)),
                                      ))
                                  .toList(),
                              value: _taskStatus,
                              onChanged: (value) {
                                if (value == null) return;
                                _taskStatus = value;
                                context
                                    .read<TaskEditorCubit>()
                                    .setStatus(value);
                                setState(() {});
                              },
                            ),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.createdDateMarker} ${AppLocalizations.of(context)!.labelCreated}:",
                            Row(children: [
                              addDateTimePicker(
                                  _createdDate, state.task?.created, context,
                                  (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setCreatedDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setCreatedDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.doneDateMarker} ${AppLocalizations.of(context)!.labelDone}:",
                            Row(children: [
                              addDateTimePicker(
                                  _doneDate, state.task?.done, context, (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setDoneDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setDoneDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                          _buildLabeledRow(
                            "${MarkdownTaskMarkers.cancelledDateMarker} ${AppLocalizations.of(context)!.labelCancelled}:",
                            Row(children: [
                              addDateTimePicker(_cancelledDate,
                                  state.task?.cancelled, context, (date) {
                                context
                                    .read<TaskEditorCubit>()
                                    .setCancelledDate(date);
                              }),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskEditorCubit>()
                                        .setCancelledDate(null);
                                  },
                                  icon: const Icon(Icons.clear_rounded))
                            ]),
                          ),
                        ],
                      ),

                      // Source link
                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: GestureDetector(
                              onTap: () {
                                context
                                    .read<TaskEditorCubit>()
                                    .launchObsidian(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.open_in_new, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _initLink(state.task),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                      maxLines: null,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom save button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: Text(AppLocalizations.of(context)!.save),
                        onPressed: () {
                          context.read<TaskEditorCubit>().saveTask(context);
                        },
                      ),
                    ),
                  ),
                )
              ]),
            );
          }

          return Container();
        },
      ),
    );
  }

  String _getPriorityName(BuildContext context, TaskPriority p) {
    var tr = AppLocalizations.of(context)!;
    switch (p) {
      case TaskPriority.lowest:
        return tr.priorityLowest;
      case TaskPriority.low:
        return tr.priorityLow;
      case TaskPriority.normal:
        return tr.priorityNormal;
      case TaskPriority.medium:
        return tr.priorityMedium;
      case TaskPriority.high:
        return tr.priorityHigh;
      case TaskPriority.highest:
        return tr.priorityHighest;
    }
  }

  String _getStatusName(BuildContext context, TaskStatus s) {
    var tr = AppLocalizations.of(context)!;
    switch (s) {
      case TaskStatus.todo:
        return tr.taskStatusTodo;
      case TaskStatus.done:
        return tr.taskStatusDone;
      case TaskStatus.inprogress:
        return tr.taskStatusInprogress;
      case TaskStatus.cancelled:
        return tr.taskStatusCancelled;
    }
  }

  void _init(Task? task) {
    _taskPriority = task?.priority ?? TaskPriority.normal;
    _dueDate = Text(_initDate(task?.due));
    _scheduledDate = Text(_initDate(task?.scheduled));
    _reminderDate =
        Text(_initReminderDate(task?.reminder, AppLocalizations.of(context)!));
    _reminderTime =
        Text(_initReminderTime(task?.reminder, AppLocalizations.of(context)!));
    _startDate = Text(_initDate(task?.start));
    _createdDate = Text(_initDate(task?.created));
    _doneDate = Text(_initDate(task?.done));
    _cancelledDate = Text(_initDate(task?.cancelled));
    _taskStatus = task?.status ?? TaskStatus.todo;
    _taskSource = Text(task?.taskSource?.fileName ?? "");
  }

  String _initDate(DateTime? date) {
    String dateTemplate = SettingsController.getInstance().dateTemplate;
    String formatedDate = dateTemplate;
    if (date != null) {
      formatedDate = DateFormat(dateTemplate).format(date);
    }
    return formatedDate;
  }

  String _getRecurrenceName(BuildContext context, String rule) {
    var tr = AppLocalizations.of(context)!;
    switch (rule) {
      case 'None':
        return tr.recurrenceNone;
      case 'every day':
        return tr.recurrenceDaily;
      case 'every week':
        return tr.recurrenceWeekly;
      case 'every month':
        return tr.recurrenceMonthly;
      case 'every year':
        return tr.recurrenceYearly;
      case 'every weekday':
        return tr.recurrenceWeekday;
      case 'every Monday':
        return tr.recurrenceMonday;
      case 'every Tuesday':
        return tr.recurrenceTuesday;
      case 'every Wednesday':
        return tr.recurrenceWednesday;
      case 'every Thursday':
        return tr.recurrenceThursday;
      case 'every Friday':
        return tr.recurrenceFriday;
      case 'every Saturday':
        return tr.recurrenceSaturday;
      case 'every Sunday':
        return tr.recurrenceSunday;
      default:
        // Attempt to handle case variations or just return rule
        return rule;
    }
  }

  String _initReminderDate(DateTime? dateTime, AppLocalizations l10n) {
    String template = "yyyy-MM-dd";
    String formated = l10n.setDate;
    if (dateTime != null) {
      formated = DateFormat(template).format(dateTime);
    }
    return formated;
  }

  String _initReminderTime(DateTime? dateTime, AppLocalizations l10n) {
    String template = "HH:mm";
    String formated = l10n.setTime; // Default behavior if null

    if (dateTime != null) {
      // Check if it matches default time
      var defaultTimeStr = SettingsController.getInstance().defaultReminderTime;
      var defaultTime = DateFormat("HH:mm").parse(defaultTimeStr);

      if (dateTime.hour == defaultTime.hour &&
          dateTime.minute == defaultTime.minute) {
        // Matches default, showing "Set Time" acts as "Use Default / Blank"
        formated = l10n.setTime;
      } else {
        formated = DateFormat(template).format(dateTime);
      }
    }
    return formated;
  }

  String _initLink(Task? task) {
    if (task != null && task.taskSource != null) {
      return _basename(task.taskSource!.fileName);
    }

    return "";
  }

  // Extracts the last path segment to display only the file name
  String _basename(String path) {
    if (path.isEmpty) return path;
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isNotEmpty ? parts.last : path;
  }

  /// Builds the tag cloud widget showing all available tags with highlighting for selected ones
  Widget _buildTagCloud(BuildContext context, TaskEditorState state) {
    final cubit = context.read<TaskEditorCubit>();
    final allTags = cubit.getAllTags();
    final currentTaskTags = cubit.getCurrentTaskTags();

    if (allTags.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.msgNoTagsAvailable,
        style: const TextStyle(color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: allTags.map((tag) {
        final isSelected = currentTaskTags.contains(tag);
        return GestureDetector(
          onTap: () {
            cubit.toggleTag(tag);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Text(
              '#$tag',
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabeledRow(String label, Widget control) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: control),
      ],
    );
  }

  Widget _buildRecurrenceControl(BuildContext context, TaskEditorState state) {
    final options = RecurrentTask.options;

    final task = (state as TaskEditorInitial).task;
    final currentRule = task?.recurrenceRule;
    if (currentRule != null &&
        currentRule.isNotEmpty &&
        !options.contains(currentRule)) {
      options.insert(0, currentRule);
    }

    final dropdownValue =
        (currentRule == null || currentRule.isEmpty) ? 'None' : currentRule;

    return Row(children: [
      Expanded(
        child: DropdownButton<String>(
          isExpanded: true,
          items: options
              .map((o) => DropdownMenuItem<String>(
                  value: o, child: Text(_getRecurrenceName(context, o))))
              .toList(),
          value: dropdownValue,
          onChanged: (val) {
            if (val == null) return;
            context
                .read<TaskEditorCubit>()
                .setRecurrenceRule(val == 'None' ? null : val);
          },
        ),
      ),
    ]);
  }

  // Section card with header and consistent spacing
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children
                .map((w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: w,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
