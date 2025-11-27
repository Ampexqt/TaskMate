import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/enums/priority.dart';
import '../../providers/task_provider.dart';
import '../../widgets/buttons/custom_button.dart';
import '../add_task/widgets/priority_selector.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Priority _selectedPriority;
  late DateTime _selectedDate;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = taskProvider.getTaskById(widget.taskId);

      if (task != null) {
        _titleController = TextEditingController(text: task.title);
        _descriptionController = TextEditingController(text: task.description);
        _selectedPriority = task.priority;
        _selectedDate = task.dueDate;
        _isInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = taskProvider.getTaskById(widget.taskId);

      if (task != null) {
        final updatedTask = task.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDate,
        );

        await taskProvider.updateTask(updatedTask);

        if (mounted) {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFormValid = _titleController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Task',
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
          child: Form(
            key: _formKey,
            child:
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Title
                        Text(
                          'Task Title',
                          style: AppTextStyles.medium14(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.gray700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter task title',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a task title';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: AppDimensions.xl),

                        // Description
                        Text(
                          'Description',
                          style: AppTextStyles.medium14(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.gray700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter task description (optional)',
                          ),
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                        ),

                        const SizedBox(height: AppDimensions.xl),

                        // Priority
                        Text(
                          'Priority',
                          style: AppTextStyles.medium14(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.gray700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        PrioritySelector(
                          selectedPriority: _selectedPriority,
                          onPriorityChanged: (priority) {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          },
                        ),

                        const SizedBox(height: AppDimensions.xl),

                        // Due Date
                        Text(
                          'Due Date',
                          style: AppTextStyles.medium14(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.gray700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.lg,
                              vertical: AppDimensions.md,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkBackgroundTertiary
                                  : AppColors.lightBackgroundTertiary,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.calendar,
                                  size: 20,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                                const SizedBox(width: AppDimensions.md),
                                Text(
                                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                                  style: AppTextStyles.body(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.xl2),

                        // Save Button
                        CustomButton(
                          text: 'Save Changes',
                          isFullWidth: true,
                          onPressed: isFormValid ? _saveTask : null,
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
      ),
    );
  }
}
