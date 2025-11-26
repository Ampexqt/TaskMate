import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Font Family: DM Sans
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Heading 1: 32px, bold (700)
  static TextStyle heading1({Color? color}) =>
      _baseStyle(fontSize: 32, fontWeight: FontWeight.w700, color: color);

  // Heading 2: 24px, bold (700)
  static TextStyle heading2({Color? color}) =>
      _baseStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color);

  // Body Large: 18px, medium (500)
  static TextStyle bodyLarge({Color? color}) =>
      _baseStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color);

  // Body: 16px, regular (400)
  static TextStyle body({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.w400, color: color);

  // Body Small: 14px, regular (400)
  static TextStyle bodySmall({Color? color}) =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  // Caption: 12px, medium (500)
  static TextStyle caption({Color? color}) =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color);

  // Additional styles
  static TextStyle semibold16({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle semibold18({Color? color}) =>
      _baseStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle semibold20({Color? color}) =>
      _baseStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle semibold24({Color? color}) =>
      _baseStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color);

  static TextStyle medium14({Color? color}) =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium16({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color);

  static TextStyle bold36({Color? color}) =>
      _baseStyle(fontSize: 36, fontWeight: FontWeight.w700, color: color);

  static TextStyle semibold14({Color? color}) =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyXSmall({Color? color}) =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color);
}
