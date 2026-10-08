import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_neumorphism.dart";

/// A versatile Neumorphic container widget.
/// Supports raised (embossed), sunken (debossed), convex, and flat styles,
/// with optional interactive tap feedback (smooth compression/spring).
class NeumorphicContainer extends StatefulWidget {
  const NeumorphicContainer({
    super.key,
    required this.child,
    this.style = NeumorphicStyle.embossed,
    this.color = AppColors.surface,
    this.borderRadius,
    this.radius = AppNeumorphism.defaultRadius,
    this.shape = BoxShape.rectangle,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.border,
    this.distance = AppNeumorphism.defaultDistance,
    this.blur = AppNeumorphism.defaultBlur,
    this.duration = const Duration(milliseconds: 150),
  });

  final Widget child;
  final NeumorphicStyle style;
  final Color color;
  final BorderRadius? borderRadius;
  final double radius;
  final BoxShape shape;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Border? border;
  final double distance;
  final double blur;
  final Duration duration;

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        _isPressed ? NeumorphicStyle.debossed : widget.style;

    BoxDecoration decoration;
    switch (effectiveStyle) {
      case NeumorphicStyle.embossed:
        decoration = AppNeumorphism.embossedDecoration(
          color: widget.color,
          radius: widget.radius,
          customBorderRadius: widget.borderRadius,
          shape: widget.shape,
          distance: widget.distance,
          blur: widget.blur,
          border: widget.border,
        );
        break;

      case NeumorphicStyle.debossed:
        decoration = AppNeumorphism.debossedDecoration(
          color: widget.color == AppColors.surface
              ? AppColors.surfaceVariant
              : widget.color,
          radius: widget.radius,
          customBorderRadius: widget.borderRadius,
          shape: widget.shape,
          border: widget.border,
        );
        break;

      case NeumorphicStyle.convex:
        decoration = AppNeumorphism.convexDecoration(
          baseColor: widget.color,
          radius: widget.radius,
          customBorderRadius: widget.borderRadius,
          shape: widget.shape,
          distance: widget.distance,
          blur: widget.blur,
        );
        break;

      case NeumorphicStyle.concave:
      case NeumorphicStyle.flat:
        decoration = BoxDecoration(
          color: widget.color,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.circle
              ? null
              : (widget.borderRadius ??
                  BorderRadius.circular(widget.radius)),
          border: widget.border ??
              Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.0,
              ),
        );
        break;
    }

    Widget content = AnimatedContainer(
      duration: widget.duration,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: decoration,
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
