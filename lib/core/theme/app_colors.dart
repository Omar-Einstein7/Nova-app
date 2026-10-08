import "package:flutter/material.dart";

/// NOVA Neumorphic design-token colours.
/// All values marked [PLACEHOLDER] must be reviewed with the designer.
abstract final class AppColors {
  // ── Neumorphic Base Canvas ───────────────────────────────────────────────
  /// Base canvas color for Neumorphic light-source depth
  static const Color background = Color(0xFFEEF2F6);
  static const Color surface = Color(0xFFEEF2F6);

  /// Slightly tinted card / recessed surface
  static const Color surfaceVariant = Color(0xFFE2E8F0);
  static const Color surfaceHighlight = Color(0xFFFFFFFF);

  // ── Neumorphic Shadows ───────────────────────────────────────────────────
  /// Top-left highlight shadow
  static const Color shadowLight = Color(0xFFFFFFFF);

  /// Bottom-right depth shadow
  static const Color shadowDark = Color(0xFFA6B4C9);

  // ── Brand ────────────────────────────────────────────────────────────────
  /// [PLACEHOLDER: Primary brand colour – calm indigo]
  static const Color primary = Color(0xFF5C6BC0);
  static const Color primaryLight = Color(0xFF7986CB);
  static const Color primaryDark = Color(0xFF3949AB);

  /// [PLACEHOLDER: Secondary accent – soft warm lavender / purple]
  static const Color secondary = Color(0xFF8E70D6);
  static const Color secondaryLight = Color(0xFFB39DDB);

  // ── Semantic ─────────────────────────────────────────────────────────────
  /// [PLACEHOLDER: Calm success green]
  static const Color success = Color(0xFF48BB78);
  static const Color successLight = Color(0xFFE8F5E9);

  /// [PLACEHOLDER: Gentle retry – soft warm amber, NOT red]
  static const Color gentleRetry = Color(0xFFF6AD55);
  static const Color gentleRetryLight = Color(0xFFFFF3E0);

  // ── Text (High contrast Slate palette for WCAG AA+) ──────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders / Dividers ───────────────────────────────────────────────────
  static const Color divider = Color(0xFFCBD5E1);
  static const Color border = Color(0xFFD5DEE7);

  // ── Stars ────────────────────────────────────────────────────────────────
  static const Color starFilled = Color(0xFFFFB703);
  static const Color starEmpty = Color(0xFFCBD5E1);
}
