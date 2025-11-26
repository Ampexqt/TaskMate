import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../providers/theme_provider.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: AppDimensions.themeToggleDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
        if (isDark) {
          _rotationController.reverse();
        } else {
          _rotationController.forward();
        }
      },
      child: AnimatedContainer(
        duration: AppDimensions.themeToggleDuration,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate700 : AppColors.gray100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 0.5).animate(_rotationController),
          child: Icon(
            isDark ? LucideIcons.moon : LucideIcons.sun,
            size: 20,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}
