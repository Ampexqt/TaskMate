import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/task_provider.dart';

class CompletionToggle extends StatelessWidget {
  final String taskId;
  final bool isCompleted;

  const CompletionToggle({
    super.key,
    required this.taskId,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => taskProvider.toggleTaskCompletion(taskId),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackgroundTertiary
              : AppColors.lightBackgroundTertiary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: Row(
          children: [
            Icon(
              isCompleted ? LucideIcons.checkCircle2 : LucideIcons.circle,
              size: 32,
              color: isCompleted
                  ? (isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary)
                  : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCompleted ? 'Completed' : 'Mark as Complete',
                    style: AppTextStyles.semibold16(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    isCompleted ? 'Tap to mark as incomplete' : 'Tap to complete this task',
                    style: AppTextStyles.bodySmall(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
