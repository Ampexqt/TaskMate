import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmptyState({
    super.key,
    this.icon = LucideIcons.checkCircle2,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xl,
          vertical: AppDimensions.xl3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: isDark ? AppColors.gray600 : AppColors.gray300,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .moveY(
                  begin: 0,
                  end: -10,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                )
                .then()
                .moveY(
                  begin: -10,
                  end: 0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: AppDimensions.xl),
            Text(
              title,
              style: AppTextStyles.semibold18(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                description,
                style: AppTextStyles.bodySmall(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
            .animate()
            .slideY(
              begin: 0.2,
              end: 0,
              duration: AppDimensions.slideUpDuration,
              curve: AppDimensions.easeOut,
            )
            .fadeIn(
              duration: AppDimensions.slideUpDuration,
              curve: AppDimensions.easeOut,
            ),
      ),
    );
  }
}
