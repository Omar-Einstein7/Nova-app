import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_neumorphism.dart";
import "../theme/app_spacing.dart";
import "neumorphic_container.dart";

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeumorphicContainer(
              shape: BoxShape.circle,
              padding: const EdgeInsets.all(24),
              color: AppColors.surface,
              child: Icon(
                icon ?? Icons.inbox_rounded,
                size: 56,
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              message ?? "لا توجد بيانات لعرضها.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
