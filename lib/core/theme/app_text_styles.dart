import "package:flutter/material.dart";
import "app_colors.dart";

/// NOVA text styles.
/// [PLACEHOLDER: Replace fontFamily with Cairo or Tajawal once the font asset
/// or google_fonts dependency is configured.]
abstract final class AppTextStyles {
  // The font family name must match the family key in pubspec.yaml
  // [PLACEHOLDER: font family = "Cairo"]
  static const String _fontFamily = "Cairo";

  // ── Static getters for standard use ─────────────────────────────────────────

  static TextStyle get displayLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ── Scaled helpers ─────────────────────────────────────────────────────────

  static TextStyle scaledDisplayLarge(double scale) =>
      displayLarge.copyWith(fontSize: 32 * scale);

  static TextStyle scaledDisplayMedium(double scale) =>
      displayMedium.copyWith(fontSize: 26 * scale);

  static TextStyle scaledHeadlineLarge(double scale) =>
      headlineLarge.copyWith(fontSize: 22 * scale);

  static TextStyle scaledHeadlineMedium(double scale) =>
      headlineMedium.copyWith(fontSize: 18 * scale);

  static TextStyle scaledBodyLarge(double scale) =>
      bodyLarge.copyWith(fontSize: 16 * scale);

  static TextStyle scaledBodyMedium(double scale) =>
      bodyMedium.copyWith(fontSize: 14 * scale);

  static TextStyle scaledLabelLarge(double scale) =>
      labelLarge.copyWith(fontSize: 16 * scale);

  static TextStyle scaledLabelMedium(double scale) =>
      labelMedium.copyWith(fontSize: 14 * scale);

  static TextStyle scaledCaption(double scale) =>
      caption.copyWith(fontSize: 12 * scale);
}
