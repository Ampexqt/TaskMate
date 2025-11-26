import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : (_isHovered ? 1.1 : 1.0),
          duration: _isPressed
              ? AppDimensions.tapScaleDuration
              : AppDimensions.hoverLiftDuration,
          child: AnimatedContainer(
            duration: AppDimensions.hoverLiftDuration,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkAccentPrimary, AppColors.primary600]
                    : [AppColors.primary500, AppColors.primary600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              boxShadow: [
                ...AppDimensions.softLargeShadow(
                  isDark ? AppColors.darkShadowLarge : AppColors.lightShadowLarge,
                ),
                if (_isHovered) ...AppDimensions.glowShadow,
              ],
            ),
            child: const Icon(
              LucideIcons.plus,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
