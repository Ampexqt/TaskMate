import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../providers/task_provider.dart';
import '../../widgets/buttons/floating_action_button.dart';
import 'widgets/home_header.dart';
import 'widgets/task_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.xl),

                      // Today's Tasks
                      TaskSection(
                        icon: LucideIcons.checkCircle2,
                        title: "Today's Tasks",
                        tasks: taskProvider.todayTasks,
                        sectionIndex: 0,
                      ),

                      const SizedBox(height: AppDimensions.xl2),

                      // Upcoming Tasks
                      TaskSection(
                        icon: LucideIcons.calendar,
                        title: 'Upcoming',
                        tasks: taskProvider.upcomingTasks,
                        sectionIndex: 1,
                      ),

                      // Completed Tasks - Only show if there are completed tasks
                      if (taskProvider.completedTasks.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.xl2),
                        TaskSection(
                          icon: LucideIcons.check,
                          title: 'Completed',
                          subtitle: '(tap to undo)',
                          tasks: taskProvider.completedTasks,
                          sectionIndex: 2,
                        ),
                      ],

                      const SizedBox(height: AppDimensions.xl3),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => context.push(AppConstants.addTaskRoute),
      ),
    );
  }
}
