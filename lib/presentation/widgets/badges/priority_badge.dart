import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/enums/priority.dart';

class PriorityBadge extends StatelessWidget {
  final Priority priority;
  final bool animated;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;

    switch (priority) {
      case Priority.low:
        backgroundColor = isDark ? AppColors.green700 : AppColors.green100;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.green700;
        break;
      case Priority.medium:
        backgroundColor = isDark ? AppColors.amber700 : AppColors.lightPriorityMediumBg;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightPriorityMediumText;
        break;
      case Priority.high:
        backgroundColor = isDark ? AppColors.red700 : AppColors.lightPriorityHighBg;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightPriorityHighText;
        break;
    }

    final badge = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Text(
        priority.displayName,
        style: AppTextStyles.caption(color: textColor),
      ),
    );

    if (animated) {
      return badge
          .animate()
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: AppDimensions.scaleInDuration,
            curve: AppDimensions.easeOut,
          )
          .fadeIn(
            duration: AppDimensions.scaleInDuration,
            curve: AppDimensions.easeOut,
          );
    }

    return badge;
  }
}
