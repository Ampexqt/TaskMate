import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class EmptyTaskState extends StatelessWidget {
  final String message;

  const EmptyTaskState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xl,
        vertical: AppDimensions.xl,
      ),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodySmall(
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
