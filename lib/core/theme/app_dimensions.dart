import 'package:flutter/material.dart';

class AppDimensions {
  // Spacing Scale
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xl2 = 32.0;
  static const double xl3 = 48.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXl2 = 24.0;
  static const double radiusPill = 9999.0;

  // Shadows
  static List<BoxShadow> softShadow(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> softLargeShadow(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: const Color(0x4D38BDF8), // rgba(56, 189, 248, 0.3)
      offset: const Offset(0, 0),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Animation Durations
  static const Duration fadeInDuration = Duration(milliseconds: 300);
  static const Duration slideUpDuration = Duration(milliseconds: 400);
  static const Duration scaleInDuration = Duration(milliseconds: 200);
  static const Duration hoverLiftDuration = Duration(milliseconds: 200);
  static const Duration tapScaleDuration = Duration(milliseconds: 100);
  static const Duration themeToggleDuration = Duration(milliseconds: 300);
  static const Duration floatingIconDuration = Duration(seconds: 3);
  static const Duration pulseSoftDuration = Duration(seconds: 2);

  // Timing Functions (Curves)
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // Stagger Delay
  static const Duration staggerDelay = Duration(milliseconds: 100);
}
