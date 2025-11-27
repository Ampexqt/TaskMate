import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../domain/entities/task.dart';
import '../../providers/task_provider.dart';
import '../../widgets/badges/priority_badge.dart';
import 'widgets/completion_toggle.dart';
import 'widgets/task_info_card.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Task Details',
          style: AppTextStyles.semibold20(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate700 : AppColors.gray100,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                LucideIcons.edit,
                size: 20,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            onPressed: () {
              context.push('/edit-task/$taskId');
            },
          ),
          const SizedBox(width: AppDimensions.sm),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate700 : AppColors.gray100,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                LucideIcons.trash2,
                size: 20,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              _showDeleteDialog(context, taskId);
            },
          ),
          const SizedBox(width: AppDimensions.md),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final task = taskProvider.getTaskById(taskId);

          if (task == null) {
            return Center(
              child: Text(
                'Task not found',
                style: AppTextStyles.body(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child:
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Completion Toggle
                          CompletionToggle(
                            taskId: task.id,
                            isCompleted: task.isCompleted,
                          ),

                          const SizedBox(height: AppDimensions.xl),

                          // Task Title
                          Text(
                            task.title,
                            style: AppTextStyles.heading2(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),

                          const SizedBox(height: AppDimensions.lg),

                          // Task Description
                          if (task.description.isNotEmpty) ...[
                            Text(
                              task.description,
                              style: AppTextStyles.body(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.xl),
                          ],

                          // Priority
                          TaskInfoCard(
                            label: 'Priority',
                            content: PriorityBadge(priority: task.priority),
                          ),

                          const SizedBox(height: AppDimensions.lg),

                          // Due Date
                          TaskInfoCard(
                            label: 'Due Date',
                            content: Row(
                              children: [
                                Icon(
                                  LucideIcons.calendar,
                                  size: 20,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                                const SizedBox(width: AppDimensions.sm),
                                Text(
                                  app_date_utils.DateUtils.formatDate(
                                    task.dueDate,
                                  ),
                                  style: AppTextStyles.body(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppDimensions.lg),

                          // Created Date
                          TaskInfoCard(
                            label: 'Created',
                            content: Text(
                              app_date_utils.DateUtils.formatDateTime(
                                task.createdAt,
                              ),
                              style: AppTextStyles.body(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(
                        duration: AppDimensions.slideUpDuration,
                        curve: AppDimensions.easeOut,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: AppDimensions.slideUpDuration,
                        curve: AppDimensions.easeOut,
                      ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String taskId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Task',
            style: AppTextStyles.semibold18(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this task? This action cannot be undone.',
            style: AppTextStyles.body(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.medium16(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final taskProvider = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                );
                taskProvider.deleteTask(taskId);
                Navigator.of(dialogContext).pop();
                context.pop();
              },
              child: Text(
                'Delete',
                style: AppTextStyles.medium16(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
