import "package:flutter/material.dart";
import "app_colors.dart";
import "app_neumorphism.dart";

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

      // ── Neumorphic Cards (radius 20) ────────────────────────────────────
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppNeumorphism.defaultRadius),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.shadowDark.withValues(alpha: 0.35),
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18 * fontScale,
          fontWeight: FontWeight.w700,
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
            borderRadius: BorderRadius.circular(AppNeumorphism.defaultRadius),
          ),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
          ),
          elevation: 3,
          shadowColor: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),

      // ── OutlinedButton (secondary action) ───────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppNeumorphism.defaultRadius),
          ),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.6), width: 1.5),
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

      // ── Floating Action Button ──────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      // ── Input decoration (Neumorphic recessed look) ──────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant.withValues(alpha: 0.6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.shadowDark.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.shadowDark.withValues(alpha: 0.2),
          ),
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
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.surface,
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
            fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w700),
        titleLarge: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600),
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
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
        ),
        backgroundColor: AppColors.surface,
        elevation: 6,
      ),

      // ── Snack bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
