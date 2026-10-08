import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";
import "app_button.dart";
import "neumorphic_container.dart";

/// Shared error view with retry. Uses calm colours per NOVA UX rules.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

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
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: AppColors.gentleRetry,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: AppButton(
                label: "إعادة المحاولة",
                onPressed: onRetry,
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
