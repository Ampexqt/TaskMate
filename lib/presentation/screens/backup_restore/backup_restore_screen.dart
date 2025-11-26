import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/services/backup_service.dart';
import '../../../data/services/connectivity_service.dart';
import '../../providers/task_provider.dart';
import 'widgets/backup_card.dart';
import 'widgets/backup_auth_dialog.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final BackupService _backupService = BackupService();
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<void> _showBackupDialog() async {
    // Check internet connection first
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      if (mounted) {
        _showWarningSnackBar(
          'No internet connection. Please connect to backup your tasks.',
        );
      }
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackupAuthDialog(
        title: 'Backup to Cloud',
        subtitle: 'Enter your credentials to backup',
        onSubmit: _handleBackup,
      ),
    );
  }

  Future<void> _showRestoreDialog() async {
    // Check internet connection first
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      if (mounted) {
        _showWarningSnackBar(
          'No internet connection. Please connect to restore your tasks.',
        );
      }
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackupAuthDialog(
        title: 'Restore from Cloud',
        subtitle: 'Enter your credentials to restore',
        onSubmit: _handleRestore,
      ),
    );
  }

  Future<void> _handleBackup(String email, String password) async {
    try {
      // First, authenticate
      final authResult = await _backupService.createOrLoginAccount(
        email: email,
        password: password,
      );

      if (!authResult.success) {
        // Show error toast but DON'T close the dialog - keep it open
        if (mounted) {
          _showErrorSnackBar(authResult.message);
        }
        return;
      }

      // Get all tasks from provider
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final tasks = taskProvider.tasks;

      // Backup tasks
      final backupResult = await _backupService.backupTasks(
        email: email,
        tasks: tasks,
      );

      if (mounted) {
        // Close dialog only on success or backup failure (not auth failure)
        Navigator.pop(context);

        if (backupResult.success) {
          _showSuccessSnackBar('Your data is backed up!');
        } else {
          _showErrorSnackBar(backupResult.message);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar('Backup failed: $e');
      }
    }
  }

  Future<void> _handleRestore(String email, String password) async {
    try {
      // First, authenticate
      final authResult = await _backupService.createOrLoginAccount(
        email: email,
        password: password,
      );

      if (!authResult.success) {
        // Show error toast but DON'T close the dialog - keep it open
        if (mounted) {
          _showErrorSnackBar(authResult.message);
        }
        return;
      }

      // Restore tasks
      final restoreResult = await _backupService.restoreTasks(email: email);

      if (!restoreResult.success) {
        if (mounted) {
          Navigator.pop(context);
          _showErrorSnackBar(restoreResult.message);
        }
        return;
      }

      // Show confirmation dialog
      if (mounted) {
        Navigator.pop(context);

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Restore Confirmation'),
            content: Text(
              'Found ${restoreResult.tasks.length} tasks in backup. This will replace all your current tasks. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Restore'),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          // Clear current tasks and add restored tasks
          final taskProvider = Provider.of<TaskProvider>(
            context,
            listen: false,
          );
          await taskProvider.clearAllTasks();

          for (var task in restoreResult.tasks) {
            await taskProvider.addTask(
              title: task.title,
              description: task.description,
              priority: task.priority,
              dueDate: task.dueDate,
            );
          }

          _showSuccessSnackBar('Your data is restored!');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar('Restore failed: $e');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.green600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.white, size: 20),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.red600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.wifiOff, color: Colors.white, size: 20),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.amber700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

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
          'Backup & Restore',
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
          child:
              Column(
                    children: [
                      // Hero Section
                      Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary400,
                                  AppColors.primary600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXl2,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.cloud,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : Colors.white,
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .moveY(
                            begin: 0,
                            end: -10,
                            duration: AppDimensions.floatingIconDuration,
                            curve: Curves.easeInOut,
                          )
                          .then()
                          .moveY(
                            begin: -10,
                            end: 0,
                            duration: AppDimensions.floatingIconDuration,
                            curve: Curves.easeInOut,
                          ),

                      const SizedBox(height: AppDimensions.xl2),

                      // Backup Card
                      BackupCard(
                        title: 'Backup Data',
                        description: 'Save your tasks to cloud storage',
                        icon: LucideIcons.upload,
                        isPrimary: true,
                        onPressed: _showBackupDialog,
                      ),

                      const SizedBox(height: AppDimensions.lg),

                      // Restore Card
                      BackupCard(
                        title: 'Restore Data',
                        description: 'Restore your tasks from cloud backup',
                        icon: LucideIcons.download,
                        onPressed: _showRestoreDialog,
                      ),

                      const SizedBox(height: AppDimensions.xl),

                      // Info Note
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.lg),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.amber800.withValues(alpha: 0.2)
                              : AppColors.amber50,
                          border: Border.all(
                            color: isDark
                                ? AppColors.amber800
                                : AppColors.amber200,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              LucideIcons.info,
                              size: 20,
                              color: isDark
                                  ? AppColors.amber400
                                  : AppColors.amber800,
                            ),
                            const SizedBox(width: AppDimensions.md),
                            Expanded(
                              child: Text(
                                'Your tasks are backed up to Firebase Cloud. Use the same email and password to restore on any device.',
                                style: AppTextStyles.bodySmall(
                                  color: isDark
                                      ? AppColors.amber400
                                      : AppColors.amber800,
                                ),
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
