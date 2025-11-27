import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../domain/enums/priority.dart';
import '../../../widgets/badges/priority_badge.dart';

class PrioritySelector extends StatelessWidget {
  final Priority selectedPriority;
  final ValueChanged<Priority> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: Priority.values.map((priority) {
        final isSelected = selectedPriority == priority;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: priority != Priority.high ? AppDimensions.md : 0,
            ),
            child: GestureDetector(
              onTap: () => onPriorityChanged(priority),
              child: AnimatedContainer(
                duration: AppDimensions.hoverLiftDuration,
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                            ? AppColors.darkBackgroundTertiary
                            : AppColors.primary50)
                      : (isDark
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.lightBackgroundSecondary),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                              ? AppColors.darkAccentPrimary
                              : AppColors.primary500)
                        : (isDark ? AppColors.darkBorder : AppColors.gray200),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Center(
                  child: PriorityBadge(
                    priority: priority,
                    animated: isSelected,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
