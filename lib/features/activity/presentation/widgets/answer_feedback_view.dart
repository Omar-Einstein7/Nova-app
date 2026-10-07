import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Shown after an answer is submitted.
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

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      margin: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            feedbackText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (_canProceed)
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isLastQuestion ? 'اعرض النتيجة 🎉' : 'التالي ➡️',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'حاول مرة أخرى 💪',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
