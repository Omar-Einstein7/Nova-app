import "package:flutter/material.dart";
import "app_colors.dart";

/// NOVA ThemeData factory.
/// fontScale: 0.9 (small) | 1.0 (normal) | 1.2 (large)
final class AppTheme {
  const AppTheme._();

  static ThemeData light({double fontScale = 1.0}) {
    // [PLACEHOLDER: Replace fontFamily with Cairo/Tajawal once configured]
    const String fontFamily = "Cairo";

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.surfaceVariant,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnPrimary,
      secondaryContainer: const Color(0xFFEDE7F6),
      onSecondaryContainer: AppColors.secondary,
      error: AppColors.gentleRetry, // calmer than standard red
      onError: AppColors.textOnPrimary,
      errorContainer: const Color(0xFFFFF3E0),
      onErrorContainer: AppColors.gentleRetry,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      scrim: Colors.black54,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.secondary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: fontFamily,

      // ── Shape (radius 20) ───────────────────────────────────────────────
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18 * fontScale,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // ── ElevatedButton (primary action, large) ──────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),

      // ── OutlinedButton (secondary action) ───────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input decoration ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.gentleRetry, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gentleRetry, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14 * fontScale,
          color: AppColors.textSecondary,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14 * fontScale,
          color: AppColors.textDisabled,
        ),
        errorStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12 * fontScale,
          color: AppColors.gentleRetry,
        ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ── Text theme (used by Material widgets) ────────────────────────────
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 32 * fontScale,
            fontWeight: FontWeight.w700),
        displayMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 26 * fontScale,
            fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 22 * fontScale,
            fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w400,
            height: 1.6),
        bodyMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w400,
            height: 1.6),
        labelLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600),
        labelMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w600),
        labelSmall: TextStyle(
            fontFamily: fontFamily,
            fontSize: 12 * fontScale,
            fontWeight: FontWeight.w400),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: AppColors.surface,
      ),

      // ── Snack bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14 * fontScale,
          color: AppColors.surface,
        ),
      ),
    );
  }
}
