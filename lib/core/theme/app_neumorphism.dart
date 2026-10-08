import "package:flutter/material.dart";
import "app_colors.dart";

/// Neumorphic style shapes and depths
enum NeumorphicStyle {
  /// Raised / Extruded with dual light shadows
  embossed,

  /// Sunken / Recessed with inner depth
  debossed,

  /// Smooth outward curvature
  convex,

  /// Smooth inward curvature
  concave,

  /// Flat surface with subtle border and dual shadows
  flat,
}

/// Helper utility for creating consistent Neumorphic decorations and shadows.
abstract final class AppNeumorphism {
  static const double defaultRadius = 20.0;
  static const double defaultDistance = 5.0;
  static const double defaultBlur = 10.0;

  /// Generate dual shadows for raised / embossed Neumorphic elements.
  static List<BoxShadow> embossedShadows({
    Color shadowDark = AppColors.shadowDark,
    Color shadowLight = AppColors.shadowLight,
    double distance = defaultDistance,
    double blur = defaultBlur,
    double darkOpacity = 0.45,
    double lightOpacity = 0.9,
  }) {
    return [
      BoxShadow(
        color: shadowDark.withValues(alpha: darkOpacity),
        offset: Offset(distance, distance),
        blurRadius: blur,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: shadowLight.withValues(alpha: lightOpacity),
        offset: Offset(-distance, -distance),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }

  /// Primary colored soft glow shadows for main CTA buttons.
  static List<BoxShadow> primaryGlowShadows({
    Color color = AppColors.primary,
    double distance = 4.0,
    double blur = 12.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.35),
        offset: Offset(0, distance),
        blurRadius: blur,
      ),
      BoxShadow(
        color: AppColors.shadowLight.withValues(alpha: 0.8),
        offset: const Offset(-2, -2),
        blurRadius: 6,
      ),
    ];
  }

  /// Decoration for raised / embossed Neumorphic surfaces.
  static BoxDecoration embossedDecoration({
    Color color = AppColors.surface,
    double radius = defaultRadius,
    BorderRadius? customBorderRadius,
    BoxShape shape = BoxShape.rectangle,
    double distance = defaultDistance,
    double blur = defaultBlur,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : (customBorderRadius ?? BorderRadius.circular(radius)),
      border: border ??
          Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 1.0,
          ),
      boxShadow: embossedShadows(distance: distance, blur: blur),
    );
  }

  /// Decoration for sunken / debossed Neumorphic surfaces (e.g. text inputs, pressed buttons, selected chips).
  static BoxDecoration debossedDecoration({
    Color color = AppColors.surfaceVariant,
    double radius = defaultRadius,
    BorderRadius? customBorderRadius,
    BoxShape shape = BoxShape.rectangle,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : (customBorderRadius ?? BorderRadius.circular(radius)),
      border: border ??
          Border.all(
            color: AppColors.shadowDark.withValues(alpha: 0.25),
            width: 1.0,
          ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.shadowDark.withValues(alpha: 0.15),
          AppColors.surfaceVariant,
          Colors.white.withValues(alpha: 0.7),
        ],
        stops: const [0.0, 0.4, 1.0],
      ),
    );
  }

  /// Decoration for convex Neumorphic buttons (subtle rounded curve outwards).
  static BoxDecoration convexDecoration({
    Color baseColor = AppColors.surface,
    double radius = defaultRadius,
    BorderRadius? customBorderRadius,
    BoxShape shape = BoxShape.rectangle,
    double distance = defaultDistance,
    double blur = defaultBlur,
  }) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : (customBorderRadius ?? BorderRadius.circular(radius)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.7),
          baseColor,
          AppColors.shadowDark.withValues(alpha: 0.1),
        ],
      ),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.7),
        width: 1.0,
      ),
      boxShadow: embossedShadows(distance: distance, blur: blur),
    );
  }
}
