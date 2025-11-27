import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/storage_service.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/add_task/add_task_screen.dart';
import '../presentation/screens/edit_task/edit_task_screen.dart';
import '../presentation/screens/task_details/task_details_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/backup_restore/backup_restore_screen.dart';

class AppRouter {
  static final StorageService _storageService = StorageService();

  static Future<String> _determineInitialRoute() async {
    final hasCompletedOnboarding = await _storageService
        .hasCompletedOnboarding();
    return hasCompletedOnboarding
        ? AppConstants.homeRoute
        : AppConstants.onboardingRoute;
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.homeRoute,
    redirect: (BuildContext context, GoRouterState state) async {
      final hasCompletedOnboarding = await _storageService
          .hasCompletedOnboarding();
      final isOnOnboarding =
          state.matchedLocation == AppConstants.onboardingRoute;

      // If user hasn't completed onboarding and is not on onboarding screen, redirect to onboarding
      if (!hasCompletedOnboarding && !isOnOnboarding) {
        return AppConstants.onboardingRoute;
      }

      // If user has completed onboarding and is on onboarding screen, redirect to home
      if (hasCompletedOnboarding && isOnOnboarding) {
        return AppConstants.homeRoute;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.onboardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.addTaskRoute,
        builder: (context, state) => const AddTaskScreen(),
      ),
      GoRoute(
        path: '${AppConstants.taskDetailsRoute}/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailsScreen(taskId: taskId);
        },
      ),
      GoRoute(
        path: '/edit-task/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return EditTaskScreen(taskId: taskId);
        },
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppConstants.backupRestoreRoute,
        builder: (context, state) => const BackupRestoreScreen(),
      ),
    ],
  );
}
