import "package:flutter/material.dart";
import "app_colors.dart";

/// NOVA text styles.
/// [PLACEHOLDER: Replace fontFamily with Cairo or Tajawal once the font asset
/// or google_fonts dependency is configured.]
abstract final class AppTextStyles {
  // The font family name must match the family key in pubspec.yaml
  // [PLACEHOLDER: font family = "Cairo"]
  static const String _fontFamily = "Cairo";

  static TextStyle displayLarge(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32 * scale,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle displayMedium(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 26 * scale,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headlineLarge(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle headlineMedium(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle bodyLarge(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle bodyMedium(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle labelLarge(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );

  static TextStyle labelMedium(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle caption(double scale) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );
}
