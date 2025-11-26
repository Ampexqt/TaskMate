import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../domain/entities/task.dart';
import '../../providers/task_provider.dart';
import '../badges/priority_badge.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback? onTap;
  final int? index;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.index,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final backgroundColor = widget.task.isCompleted
        ? (isDark ? AppColors.darkBackgroundTertiary : AppColors.gray100)
        : (isDark ? AppColors.slate800 : AppColors.lightBackgroundSecondary);

    final card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDimensions.hoverLiftDuration,
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: widget.task.isCompleted
                ? Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.gray200,
                    width: 2,
                  )
                : null,
            boxShadow: !widget.task.isCompleted
                ? AppDimensions.softShadow(
                    isDark ? AppColors.darkShadow : AppColors.lightShadow,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => taskProvider.toggleTaskCompletion(widget.task.id),
                    child: Icon(
                      widget.task.isCompleted
                          ? LucideIcons.checkCircle2
                          : LucideIcons.circle,
                      size: 24,
                      color: widget.task.isCompleted
                          ? (isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary)
                          : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: AppTextStyles.semibold16(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ).copyWith(
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.task.description.isNotEmpty) ...[
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            widget.task.description,
                            style: AppTextStyles.bodySmall(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  PriorityBadge(priority: widget.task.priority),
                  const SizedBox(width: AppDimensions.md),
                  Icon(
                    LucideIcons.calendar,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    app_date_utils.DateUtils.getRelativeDate(widget.task.dueDate),
                    style: AppTextStyles.caption(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Add slide-up animation with stagger if index is provided
    if (widget.index != null) {
      return card
          .animate(delay: Duration(milliseconds: widget.index! * 100))
          .slideY(
            begin: 0.2,
            end: 0,
            duration: AppDimensions.slideUpDuration,
            curve: AppDimensions.easeOut,
          )
          .fadeIn(
            duration: AppDimensions.slideUpDuration,
            curve: AppDimensions.easeOut,
          );
    }

    return card;
  }
}
