import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_neumorphism.dart";
import "neumorphic_container.dart";

/// Standard Neumorphic elevated Card for dashboards, lists, and sections.
class NeumorphicCard extends StatelessWidget {
  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius = AppNeumorphism.defaultRadius,
    this.color = AppColors.surface,
    this.onTap,
    this.style = NeumorphicStyle.embossed,
    this.distance = AppNeumorphism.defaultDistance,
    this.blur = AppNeumorphism.defaultBlur,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color color;
  final VoidCallback? onTap;
  final NeumorphicStyle style;
  final double distance;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      margin: margin,
      padding: padding,
      radius: radius,
      color: color,
      style: style,
      onTap: onTap,
      distance: distance,
      blur: blur,
      child: child,
    );
  }
}
