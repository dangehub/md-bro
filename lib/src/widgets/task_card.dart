import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:obsi/src/core/tasks/markdown_task_markers.dart';
import 'package:obsi/src/core/tasks/task.dart';
import 'package:obsi/src/core/tasks/task_manager.dart';
import 'package:obsi/src/core/utils.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function(bool?)? taskDonePressed;
  final VoidCallback? rightButtonPressed;
  final VoidCallback? editTaskPressed;
  final VoidCallback? startWorkflowPressed;
  final VoidCallback? undoCallback;
  final IconData? rightButtonIcon;
  final String? hightlightedText;
  final bool showInferredDate;
  final bool isUndoPending;
  final TaskStatus? overrideStatus;

  const TaskCard(this.task,
      {super.key,
      this.hightlightedText,
      this.taskDonePressed,
      this.rightButtonPressed,
      this.editTaskPressed,
      this.startWorkflowPressed,
      this.undoCallback,
      this.rightButtonIcon,
      this.showInferredDate = true,
      this.isUndoPending = false,
      this.overrideStatus});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _undoAnimationController;

  @override
  void initState() {
    super.initState();
    if (widget.isUndoPending) {
      _startUndoAnimation();
    }
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUndoPending && !oldWidget.isUndoPending) {
      _startUndoAnimation();
    } else if (!widget.isUndoPending && oldWidget.isUndoPending) {
      _undoAnimationController?.stop();
    }
  }

  void _startUndoAnimation() {
    _undoAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _undoAnimationController!.forward(from: 0.0);
  }

  @override
  void dispose() {
    _undoAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the status to display: use override if provided, else tasks's actual status
    final currentStatus = widget.overrideStatus ?? widget.task.status;
    final isDone = currentStatus == TaskStatus.done;

    var defaultTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
    var hightlightedTextStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              backgroundColor: Colors.yellow,
              color: Colors.black,
            );

    // If undo is pending, override decoration or keep existing?
    // User wants strikethrough for completed task, which is handled by _trancateDescription style logic below

    return Container(
      margin: const EdgeInsets.fromLTRB(2.0, 1.0, 1.0, 1.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: getTaskScheduleStateColor(widget.task),
            width: 4,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(0.0),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.startWorkflowPressed == null
                  ? Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: isDone,
                      onChanged: widget.isUndoPending
                          ? (val) => widget.undoCallback?.call()
                          : widget.taskDonePressed,
                    )
                  : SizedBox(
                      height: 28,
                      width: 28,
                      child: IconButton(
                        onPressed: widget.startWorkflowPressed,
                        icon: Icon(
                          Icons.play_arrow,
                          color: Theme.of(context).colorScheme.primary,
                          size: 22,
                        ),
                        padding: const EdgeInsets.all(4),
                        tooltip: 'Start',
                      ),
                    ),
            ],
          ),
          onTap: widget.isUndoPending ? null : widget.editTaskPressed,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 0.0), // Adjust padding here
          title: widget.hightlightedText != null &&
                  widget.hightlightedText!.isNotEmpty &&
                  widget.task.description!
                      .toLowerCase()
                      .contains(widget.hightlightedText!)
              ? RichText(
                  text: TextSpan(
                  children: buildHighlightedTextSpans(
                      _trancateDescription(widget.task.description!),
                      widget.hightlightedText!,
                      isDone
                          ? defaultTextStyle.copyWith(
                              decoration: TextDecoration.lineThrough)
                          : defaultTextStyle,
                      isDone
                          ? hightlightedTextStyle.copyWith(
                              decoration: TextDecoration.lineThrough)
                          : hightlightedTextStyle),
                  style: defaultTextStyle, // Ensure consistent font size
                ))
              : Text(
                  _trancateDescription(widget.task.description!),
                  style: isDone
                      ? defaultTextStyle.copyWith(
                          decoration: TextDecoration.lineThrough)
                      : defaultTextStyle,
                ),
          subtitle: _getSubtitle(context),
          trailing: widget.isUndoPending
              ? _buildUndoButton(context)
              : (widget.rightButtonPressed != null)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.rightButtonPressed != null)
                          ElevatedButton(
                            onPressed: widget.rightButtonPressed,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8),
                            ),
                            child: widget.rightButtonIcon != null
                                ? Icon(widget.rightButtonIcon!)
                                : null,
                          ),
                      ],
                    )
                  : null,
        ),
      ),
    );
  }

  Widget _buildUndoButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_undoAnimationController != null)
            CircularProgressIndicator(
              value: 1.0 -
                  _undoAnimationController!
                      .value, // Does not update automatically without AnimatedBuilder, but Controller drives it?
              // Need AnimatedBuilder for value update. Or strict use of AnimatedBuilder.
              // Actually, CircularProgressIndicator can take a value. If I want it to animate, I need to wrap it in AnimatedBuilder.
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary),
              strokeWidth: 3,
            ),
          AnimatedBuilder(
            animation: _undoAnimationController!,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: 1.0 - _undoAnimationController!.value,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                strokeWidth: 4,
              );
            },
          ),
          IconButton(
            onPressed: widget.undoCallback,
            icon: const Icon(Icons.undo),
            tooltip: '撤销',
            iconSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _getSubtitle(BuildContext context) {
    var template = SettingsController.getInstance().dateTemplate;
    var subtitle =
        MarkdownTaskMarkers().getPriorityMarker(widget.task.priority);

    if (widget.task.scheduled != null) {
      // Check if we should show the scheduled date
      bool shouldShowDate = true;
      if (widget.task.isScheduledDateInferred && !widget.showInferredDate) {
        shouldShowDate = false;
      }

      if (shouldShowDate) {
        var scheduledTemplate = template;
        if (widget.task.scheduledTime) {
          scheduledTemplate += " HH:mm";
        }
        subtitle +=
            "\n${MarkdownTaskMarkers.scheduledDateMarker} ${DateFormat(scheduledTemplate).format(widget.task.scheduled!)}";
        if (widget.task.recurrenceRule != null) {
          subtitle +=
              " ${MarkdownTaskMarkers.recurringDateMarker} ${widget.task.recurrenceRule}";
        }
      }
    }

    if (widget.task.due != null) {
      var scheduledTemplate = template;
      subtitle +=
          "\n${MarkdownTaskMarkers.dueDateMarker} ${DateFormat(scheduledTemplate).format(widget.task.due!)}";
    }

    // bool debug = true;

    // if (debug) {
    //   subtitle += _debugInfo(task);
    // }

    // If no tags, return simple text
    if (widget.task.tags.isEmpty) {
      return Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    // Build subtitle with inline tags
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (subtitle.isNotEmpty) const TextSpan(text: ' '),
          ...widget.task.tags.map((tag) => WidgetSpan(
                child: Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  String _trancateDescription(String description) {
    const maxLength = 40;
    return description.length > maxLength
        ? '${description.substring(0, maxLength)}...'
        : description;
  }

  String _debugInfo(Task task) {
    String result = "";
    if (task.taskSource != null) {
      result += task.taskSource.toString();
    }

    return result;
  }

  Color getTaskScheduleStateColor(Task task) {
    Color color = Colors.transparent;
    switch (TaskManager.getTaskScheduleState(task)) {
      case TaskScheduleState.dueToday:
        color = Colors.orange;
      case TaskScheduleState.overdue:
        color = Colors.red;
      default:
        color = Colors.transparent;
    }

    return color;
  }
}
