import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/activity.dart';

/// Renders one question with its 3 selectable options.
/// Options are full-width cards with large tap targets (≥ 64dp).
class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.question,
    required this.totalQuestions,
    required this.onOptionSelected,
    this.selectedAnswer,
    this.isCorrect,
    this.isSubmitting = false,
    this.attemptNo = 0,
  });

  final Question question;
  final int totalQuestions;
  final ValueChanged<String> onOptionSelected;
  final String? selectedAnswer;
  final bool? isCorrect;
  final bool isSubmitting;

  /// Current attempt count (0 = first attempt, 1 = second, 2 = third).
  final int attemptNo;

  bool get _hasResult => isCorrect != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress: question N of total (no numeric timer)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Text(
                'سؤال ${question.index + 1} من $totalQuestions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              // Attempt dots
              if (attemptNo > 0)
                Row(
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 4),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < attemptNo
                              ? AppColors.gentleRetry
                              : AppColors.divider,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Thin progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (question.index + 1) / totalQuestions,
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Emoji
        Text(
          question.emoji,
          style: const TextStyle(fontSize: 64),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Question text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            question.question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Options
        ...question.options.map(
          (option) => _OptionCard(
            label: option,
            isSelected: selectedAnswer == option,
            isCorrect: selectedAnswer == option ? isCorrect : null,
            isDisabled: isSubmitting || _hasResult,
            onTap: () => onOptionSelected(option),
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.isDisabled,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool? isCorrect;
  final bool isDisabled;
  final VoidCallback onTap;

  Color _cardColor() {
    if (!isSelected) return AppColors.surface;
    if (isCorrect == null) return AppColors.surfaceVariant;
    if (isCorrect!) return const Color(0xFFE8F5E9); // soft green
    return const Color(0xFFFFF3E0); // soft amber — NOT red
  }

  Color _borderColor() {
    if (!isSelected) return AppColors.border;
    if (isCorrect == null) return AppColors.primary;
    if (isCorrect!) return AppColors.success;
    return AppColors.gentleRetry;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _cardColor(),
          border: Border.all(color: _borderColor(), width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (isSelected && isCorrect != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
                    child: Text(
                      isCorrect! ? '✅' : '💙',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
