import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../../core/widgets/neumorphic_container.dart';

/// Shown after an answer is submitted with Neumorphic card styling.
/// If correct → show encouragement + "التالي".
/// If incorrect but attempts < 3 → show gentle retry button.
/// If isMaxAttempts → show "التالي" regardless.
class AnswerFeedbackView extends StatelessWidget {
  const AnswerFeedbackView({
    super.key,
    required this.isCorrect,
    required this.feedbackText,
    required this.attemptNo,
    required this.isMaxAttempts,
    required this.isLastQuestion,
    required this.onNext,
    required this.onRetry,
  });

  final bool isCorrect;
  final String feedbackText;
  final int attemptNo;
  final bool isMaxAttempts;
  final bool isLastQuestion;
  final VoidCallback onNext;
  final VoidCallback onRetry;

  bool get _canProceed => isCorrect || isMaxAttempts;

  @override
  Widget build(BuildContext context) {
    final emoji = isCorrect ? '🌟' : (isMaxAttempts ? '💙' : '💙');
    final bgColor =
        isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: NeumorphicCard(
        radius: 24,
        color: bgColor,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeumorphicContainer(
              shape: BoxShape.circle,
              width: 80,
              height: 80,
              distance: 4,
              blur: 8,
              color: Colors.white,
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 44)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              feedbackText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_canProceed)
              AppButton(
                variant: AppButtonVariant.child,
                label: isLastQuestion ? 'اعرض النتيجة 🎉' : 'التالي ➡️',
                onPressed: onNext,
              )
            else ...[
              AppButton(
                variant: AppButtonVariant.child,
                label: 'حاول مرة أخرى 💪',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
