import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/task.dart';
import '../../../widgets/cards/task_card.dart';
import 'empty_task_state.dart';

class TaskSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Task> tasks;
  final int sectionIndex;

  const TaskSection({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.tasks,
    this.sectionIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDark
                    ? AppColors.darkAccentPrimary
                    : AppColors.primary500,
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                title,
                style: AppTextStyles.semibold18(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: AppDimensions.sm),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
              ],
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: sectionIndex * 100))
            .fadeIn(
              duration: AppDimensions.fadeInDuration,
              curve: AppDimensions.easeIn,
            )
            .slideX(
              begin: -0.1,
              end: 0,
              duration: AppDimensions.fadeInDuration,
              curve: AppDimensions.easeOut,
            ),
        const SizedBox(height: AppDimensions.md),
        if (tasks.isEmpty)
          EmptyTaskState(
            message: title == 'Completed'
                ? 'No completed tasks yet'
                : 'No tasks for this section',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
            itemCount: tasks.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDimensions.md),
            itemBuilder: (context, index) {
              return TaskCard(
                task: tasks[index],
                index: index,
                onTap: () {
                  context.push(
                    '${AppConstants.taskDetailsRoute}/${tasks[index].id}',
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
