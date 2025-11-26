import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/theme_provider.dart';
import 'widgets/settings_list_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.semibold20(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              Text(
                'Appearance',
                style: AppTextStyles.caption(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SettingsListItem(
                icon: isDark ? LucideIcons.moon : LucideIcons.sun,
                title: 'Theme',
                subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: isDark
                      ? AppColors.darkAccentPrimary
                      : AppColors.lightAccentPrimary,
                ),
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Preferences Section
              Text(
                'Preferences',
                style: AppTextStyles.caption(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SettingsListItem(
                icon: LucideIcons.target,
                title: 'Daily Goals',
                subtitle: 'Set your daily task goals',
                onTap: () {
                  // TODO: Implement daily goals
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.md),
              SettingsListItem(
                icon: LucideIcons.bell,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  // TODO: Implement notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Data Section
              Text(
                'Data',
                style: AppTextStyles.caption(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SettingsListItem(
                icon: LucideIcons.database,
                title: 'Backup & Restore',
                subtitle: 'Manage your task data',
                onTap: () => context.push(AppConstants.backupRestoreRoute),
              ),
              
              const SizedBox(height: AppDimensions.xl2),
              
              // Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: AppTextStyles.bodySmall(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.caption(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.gray400,
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
