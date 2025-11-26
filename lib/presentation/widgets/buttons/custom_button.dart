import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

enum CustomButtonVariant { primary, secondary, ghost }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final bool isFullWidth;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null;

    Color backgroundColor;
    Color textColor;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case CustomButtonVariant.primary:
        backgroundColor = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
        textColor = Colors.white;
        shadows = AppDimensions.softShadow(
          isDark ? AppColors.darkShadow : AppColors.lightShadow,
        );
        break;
      case CustomButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.slate700 : AppColors.gray100;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        shadows = null;
        break;
      case CustomButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        shadows = null;
        break;
    }

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : (isDisabled ? 1.0 : 1.0),
        duration: AppDimensions.tapScaleDuration,
        child: AnimatedContainer(
          duration: AppDimensions.hoverLiftDuration,
          width: widget.isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.xl,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            gradient: widget.variant == CustomButtonVariant.primary && !isDisabled
                ? LinearGradient(
                    colors: isDark
                        ? [AppColors.darkAccentPrimary, AppColors.primary600]
                        : [AppColors.lightAccentPrimary, AppColors.primary600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.variant != CustomButtonVariant.primary ? backgroundColor : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: !isDisabled ? shadows : null,
          ),
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Row(
              mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: textColor,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                ],
                Text(
                  widget.text,
                  style: AppTextStyles.medium16(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
