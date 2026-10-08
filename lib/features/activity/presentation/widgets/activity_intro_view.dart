import 'package:flutter/material.dart';
import 'package:nova/core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../domain/entities/activity.dart';


/// Intro card shown before the first question with Neumorphic styling.
/// Child sees the activity title, emoji, and a big "ابدأ" button.
class ActivityIntroView extends StatelessWidget {
  const ActivityIntroView({
    super.key,
    required this.activity,
    required this.onStart,
  });

  final Activity activity;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Big emoji / illustration inside Neumorphic disc
              Center(
                child: NeumorphicContainer(
                  shape: BoxShape.circle,
                  width: 140,
                  height: 140,
                  distance: 6,
                  blur: 14,
                  color: AppColors.surface,
                  child: const Center(
                    child: Text(
                      '🎯',
                      style: TextStyle(fontSize: 72),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                activity.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Description
              if (activity.description.isNotEmpty) ...[
                Text(
                  activity.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Question count pill (sunken Neumorphic)
              Center(
                child: NeumorphicContainer(
                  style: NeumorphicStyle.debossed,
                  radius: 20,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                  color: AppColors.surfaceVariant,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('📝', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${activity.questions.length} أسئلة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SizedBox(height: AppSpacing.xxl),

              // Start button — large child-friendly tactile target
              AppButton(
                variant: AppButtonVariant.child,
                label: 'ابدأ اللعب 🚀',
                onPressed: onStart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
