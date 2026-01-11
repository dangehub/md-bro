import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:obsi/src/core/tasks/task.dart';
import 'package:obsi/src/core/tasks/task_manager.dart';
import 'package:obsi/src/screens/ai_assistant/cubit/ai_assistant_cubit.dart';
import 'package:obsi/src/screens/settings/settings_controller.dart';
import 'package:obsi/src/screens/task_editor/cubit/task_editor_cubit.dart';
import 'package:obsi/src/screens/task_editor/task_editor.dart';
import 'package:obsi/src/widgets/task_card.dart';
import 'package:obsi/src/core/variable_resolver.dart';
import 'package:path/path.dart' as p;

class ObsiChatBubble extends StatelessWidget {
  final Widget child;
  final types.Message message;
  final TaskManager taskManager;
  final AIAssistantCubit aiAssistantCubit;

  const ObsiChatBubble(
      this.taskManager, this.child, this.message, this.aiAssistantCubit,
      {super.key});

  @override
  Widget build(BuildContext context) {
    types.CustomMessage customMessage = message as types.CustomMessage;
    List<dynamic> response = customMessage.metadata?['response'];
    String? responseType = customMessage.metadata?['type'];
    bool isReasoning = responseType == 'reasoning';
    bool isToolConfirmation = responseType == 'tool_confirmation';
    bool isDataReview = responseType == 'data_review';
    bool showReasoning = aiAssistantCubit.lastMessages.showReasoning;

    if (!showReasoning && isReasoning) {
      return const SizedBox.shrink();
    }

    if (isToolConfirmation && response.isNotEmpty) {
      final payload = response.first as Map<String, dynamic>;
      final int actionId = payload['actionId'] as int;
      final String name = payload['name'] as String;
      final List<dynamic> paramsDynamic =
          payload['parameters'] as List<dynamic>;
      final List<String> parameters =
          paramsDynamic.map((e) => e.toString()).toList();
      final String? description = payload['description'] as String?;
      final String? decision = payload['decision'] as String?;

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm tool call',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tool: $name',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (description != null && description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Description: $description',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
              if (parameters.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Parameters: ${parameters.join(", ")}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (decision == null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          aiAssistantCubit.confirmToolAction(actionId, false),
                      child: const Text('Decline'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          aiAssistantCubit.confirmToolAction(actionId, true),
                      child: const Text('Allow'),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  decision == 'allowed'
                      ? 'User allowed this action.'
                      : 'User declined this action.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Handle data review requests
    if (isDataReview && response.isNotEmpty) {
      final payload = response.first as Map<String, dynamic>;
      final int actionId = payload['actionId'] as int;
      final String name = payload['name'] as String;
      final String? data = payload['data'] as String?;
      final String? decision = payload['decision'] as String?;

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '数据审核: $name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '以下数据将发送给 AI，请检查是否包含敏感信息：',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    data ?? '(无数据)',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (decision == null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          aiAssistantCubit.confirmDataReview(actionId, null),
                      child: const Text('拒绝'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _showEditDialog(context, actionId, data),
                      child: const Text('编辑'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          aiAssistantCubit.confirmDataReview(actionId, data),
                      child: const Text('批准'),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  decision == 'approved' ? '✅ 用户已批准发送此数据' : '❌ 用户已拒绝发送此数据',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: isReasoning
          ? BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: response.map((part) {
            if (part is String) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SelectableText(
                  part,
                  style: TextStyle(
                    fontSize: isReasoning ? 13 : 16,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            } else if (part is Task) {
              String? createTasksPath;
              if (part.taskSource == null) {
                var settings = SettingsController.getInstance();
                var resolvedTasksFile =
                    VariableResolver.resolve(settings.tasksFile);
                createTasksPath =
                    p.join(settings.vaultDirectory!, resolvedTasksFile);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TaskCard(
                  part,
                  editTaskPressed: () {
                    _onTaskCardPressed(context, part, createTasksPath);
                  },
                  rightButtonPressed: part.taskSource != null
                      ? null
                      : () {
                          _onTaskCardAddTaskPressed(
                              context, part, createTasksPath);
                        },
                  rightButtonIcon: Icons.add,
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }

  void _onTaskCardPressed(
      BuildContext context, Task task, String? createTasksPath) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => TaskEditorCubit(taskManager,
                  task: task, createTasksPath: createTasksPath),
              child: const TaskEditor()),
        ));
  }

  Future _onTaskCardAddTaskPressed(
      BuildContext context, Task task, String? createTasksPath) async {
    await taskManager.saveTask(task, filePath: createTasksPath);
  }

  /// Show dialog to edit data before sending to AI
  void _showEditDialog(BuildContext context, int actionId, String? data) {
    final controller = TextEditingController(text: data ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('编辑数据'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '编辑要发送给 AI 的数据...',
            ),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              aiAssistantCubit.confirmDataReview(actionId, controller.text);
            },
            child: const Text('发送编辑后的数据'),
          ),
        ],
      ),
    );
  }
}
