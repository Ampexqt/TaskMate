import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../../core/constants/app_constants.dart';
import '../../../widgets/buttons/theme_toggle.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xl,
        vertical: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color:
            (isDark
                    ? AppColors.darkBackgroundPrimary
                    : AppColors.lightBackgroundSecondary)
                .withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.slate700 : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.heading2(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    app_date_utils.DateUtils.getCurrentDate(),
                    style: AppTextStyles.bodySmall(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const ThemeToggle(),
            const SizedBox(width: AppDimensions.md),
            GestureDetector(
              onTap: () => context.push(AppConstants.settingsRoute),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.slate700 : AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  LucideIcons.settings,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
