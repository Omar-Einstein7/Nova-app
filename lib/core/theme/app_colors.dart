import "package:flutter/material.dart";

/// NOVA design-token colours.
/// All values marked [PLACEHOLDER] must be reviewed with the designer.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  /// [PLACEHOLDER: Primary brand colour – deep teal/blue-purple]
  static const Color primary = Color(0xFF5C6BC0);

  /// [PLACEHOLDER: Secondary accent – soft warm purple]
  static const Color secondary = Color(0xFF9575CD);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly tinted card surface
  static const Color surfaceVariant = Color(0xFFEFF1FB);

  // ── Semantic ─────────────────────────────────────────────────────────────
  /// [PLACEHOLDER: Calm success green]
  static const Color success = Color(0xFF66BB6A);

  /// [PLACEHOLDER: Gentle retry – soft orange/yellow, NOT red]
  static const Color gentleRetry = Color(0xFFFFB74D);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary =
      Color(0xFF595959); // Contrast > 5.8:1 on surface, > 4.8:1 on tinted cards
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders / Dividers ───────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFCFD8DC);

  // ── Stars ────────────────────────────────────────────────────────────────
  static const Color starFilled = Color(0xFFFFD54F);
  static const Color starEmpty = Color(0xFFEEEEEE);
}
