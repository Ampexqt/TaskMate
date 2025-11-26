import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../widgets/buttons/custom_button.dart';

class BackupCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const BackupCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: isDark
                    ? [AppColors.darkBackgroundTertiary, AppColors.darkBackgroundSecondary]
                    : [AppColors.primary50, AppColors.blue50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary
            ? null
            : (isDark
                ? AppColors.darkBackgroundTertiary
                : AppColors.lightBackgroundTertiary),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: isDark
                ? AppColors.darkAccentPrimary
                : AppColors.primary600,
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            title,
            style: AppTextStyles.semibold18(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            description,
            style: AppTextStyles.bodySmall(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          CustomButton(
            text: title,
            isFullWidth: true,
            variant: isPrimary ? CustomButtonVariant.primary : CustomButtonVariant.secondary,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
