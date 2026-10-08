import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_neumorphism.dart";
import "../theme/app_spacing.dart";

enum AppButtonVariant { primary, secondary, child }

/// NOVA reusable Neumorphic button.
/// [AppButtonVariant.child]: extra-large touch target (72dp height) for
/// child-facing activities with tactile soft-3D feel.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  void _onTapDown(TapDownDetails _) {
    if (_isEnabled) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (_isEnabled) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (_isEnabled) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChild = widget.variant == AppButtonVariant.child;
    final isPrimary = widget.variant == AppButtonVariant.primary || isChild;
    final isSecondary = widget.variant == AppButtonVariant.secondary;

    final double height = isChild ? 72 : 56;
    final double radius = isChild ? 24 : 18;

    final Color textColor = isSecondary
        ? (_isEnabled ? AppColors.primary : AppColors.textDisabled)
        : (_isEnabled ? Colors.white : Colors.white.withValues(alpha: 0.6));

    final childWidget = widget.isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: textColor,
            ),
          )
        : widget.icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon!,
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: isChild ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : Text(
                widget.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: isChild ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );

    BoxDecoration decoration;

    if (!_isEnabled) {
      decoration = BoxDecoration(
        color: isSecondary
            ? AppColors.surfaceVariant
            : AppColors.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(radius),
      );
    } else if (_isPressed) {
      if (isPrimary) {
        decoration = BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.5),
              offset: const Offset(1, 2),
              blurRadius: 4,
            ),
          ],
        );
      } else {
        decoration = AppNeumorphism.debossedDecoration(
          color: AppColors.surfaceVariant,
          radius: radius,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        );
      }
    } else {
      if (isPrimary) {
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryLight,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1.0,
          ),
          boxShadow: AppNeumorphism.primaryGlowShadows(
            distance: isChild ? 6 : 4,
            blur: isChild ? 16 : 12,
          ),
        );
      } else {
        decoration = BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: AppNeumorphism.embossedShadows(
            distance: 4,
            blur: 8,
            darkOpacity: 0.35,
          ),
        );
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: double.infinity,
      height: height,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapDown: _isEnabled ? _onTapDown : null,
          onTapUp: _isEnabled ? _onTapUp : null,
          onTapCancel: _isEnabled ? _onTapCancel : null,
          onTap: _isEnabled ? widget.onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: childWidget,
            ),
          ),
        ),
      ),
    );
  }
}
