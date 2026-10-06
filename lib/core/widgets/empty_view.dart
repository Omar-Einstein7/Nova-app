import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";

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
            Icon(
              icon ?? Icons.inbox_rounded,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message ?? "لا توجد بيانات لعرضها.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            // if (actionLabel != null && onAction != null) ...[
            //   const SizedBox(height: AppSpacing.lg),
            //   ElevatedButton(
            //     onPressed: onAction,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primary,
            //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: Text(
            //       actionLabel!,
            //       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
