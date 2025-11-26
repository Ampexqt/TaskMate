import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/storage_service.dart';
import '../../widgets/buttons/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.slate900, AppColors.slate800]
                : [AppColors.primary50, AppColors.blue50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container with Star outside
                    Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 128,
                              height: 128,
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
                              child: const Center(
                                child: Icon(
                                  LucideIcons.checkSquare,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Star icon positioned OUTSIDE the box (top-right corner)
                            Positioned(
                              top: -8,
                              right: -8,
                              child:
                                  Icon(
                                        LucideIcons.sparkles,
                                        size: 32,
                                        color: AppColors.amber400,
                                      )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(),
                                      )
                                      .rotate(
                                        begin: 0.0,
                                        end: 0.08, // ~15 degrees
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      )
                                      .then()
                                      .rotate(
                                        begin: 0.08,
                                        end: -0.08, // Rotate to -15 degrees
                                        duration: const Duration(seconds: 2),
                                        curve: Curves.easeInOut,
                                      )
                                      .then()
                                      .rotate(
                                        begin: -0.08,
                                        end: 0.0, // Back to 0
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      ),
                            ),
                          ],
                        )
                        .animate()
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: AppDimensions.easeOut,
                        )
                        .fadeIn(
                          duration: const Duration(milliseconds: 500),
                          curve: AppDimensions.easeOut,
                        ),

                    const SizedBox(height: AppDimensions.xl2),

                    // Title
                    Text(
                          AppConstants.appName,
                          style: AppTextStyles.bold36(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        )
                        .animate(delay: const Duration(milliseconds: 200))
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        )
                        .fadeIn(
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        ),

                    const SizedBox(height: AppDimensions.md),

                    // Subtitle
                    Text(
                          AppConstants.appTagline,
                          style: AppTextStyles.bodyLarge(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate(delay: const Duration(milliseconds: 300))
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        )
                        .fadeIn(
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        ),

                    const SizedBox(height: AppDimensions.xl3),

                    // Button
                    CustomButton(
                          text: 'Get Started',
                          isFullWidth: true,
                          onPressed: () async {
                            final storageService = StorageService();
                            await storageService.setOnboardingCompleted(true);
                            if (context.mounted) {
                              context.go(AppConstants.homeRoute);
                            }
                          },
                        )
                        .animate(delay: const Duration(milliseconds: 400))
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        )
                        .fadeIn(
                          duration: AppDimensions.slideUpDuration,
                          curve: AppDimensions.easeOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
