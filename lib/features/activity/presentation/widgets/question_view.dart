import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../domain/entities/activity.dart';

/// Renders one question with its 3 selectable options in Neumorphic styling.
/// Options are full-width cards with large touch targets (≥ 64dp).
/// Supports text scale up to 1.5 without overflow.
/// Includes Semantics labels, TTS button, and gentle Help button.
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
    this.onSpeakTts,
    this.onHelp,
  });

  final Question question;
  final int totalQuestions;
  final ValueChanged<String> onOptionSelected;
  final String? selectedAnswer;
  final bool? isCorrect;
  final bool isSubmitting;
  final int attemptNo;
  final VoidCallback? onSpeakTts;
  final VoidCallback? onHelp;

  bool get _hasResult => isCorrect != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress: question N of total
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Text(
                'سؤال ${question.index + 1} من $totalQuestions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              // Attempt indicator
              if (attemptNo > 0)
                Semantics(
                  label: 'المحاولة رقم $attemptNo من 3',
                  child: Row(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 6),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < attemptNo
                                ? AppColors.gentleRetry
                                : AppColors.divider,
                            boxShadow: i < attemptNo
                                ? [
                                    BoxShadow(
                                      color: AppColors.gentleRetry.withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Progress bar inside Neumorphic sunken groove
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            height: 10,
            decoration: AppNeumorphism.debossedDecoration(
              color: AppColors.surfaceVariant,
              radius: 6,
            ),
            padding: const EdgeInsets.all(2),
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: (question.index + 1) / totalQuestions,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                  ),
                  boxShadow: AppNeumorphism.primaryGlowShadows(distance: 1, blur: 4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Assistive controls bar (TTS & Help)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onSpeakTts != null)
                Semantics(
                  button: true,
                  label: 'استمع إلى نص السؤال صوتياً',
                  child: NeumorphicContainer(
                    shape: BoxShape.circle,
                    width: 44,
                    height: 44,
                    distance: 3,
                    blur: 6,
                    color: AppColors.surface,
                    child: IconButton(
                      onPressed: onSpeakTts,
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                      tooltip: 'استمع للسؤال',
                    ),
                  ),
                ),
              if (onHelp != null) ...[
                const SizedBox(width: AppSpacing.md),
                Semantics(
                  button: true,
                  label: 'طلب مساعدة وتلميح',
                  child: NeumorphicContainer(
                    shape: BoxShape.circle,
                    width: 44,
                    height: 44,
                    distance: 3,
                    blur: 6,
                    color: AppColors.surface,
                    child: IconButton(
                      onPressed: onHelp,
                      icon: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.secondary),
                      tooltip: 'مساعدة',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

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
                  fontWeight: FontWeight.w800,
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
    if (!isSelected) return Colors.white.withValues(alpha: 0.6);
    if (isCorrect == null) return AppColors.primary;
    if (isCorrect!) return AppColors.success;
    return AppColors.gentleRetry;
  }

  @override
  Widget build(BuildContext context) {
    final semanticHint = isSelected
        ? (isCorrect == true ? 'إجابة صحيحة' : 'محاولة أخرى')
        : 'اضغط لاختيار هذا الجواب';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      child: Semantics(
        button: true,
        enabled: !isDisabled,
        selected: isSelected,
        label: 'الخيار: $label',
        hint: semanticHint,
        child: NeumorphicContainer(
          radius: 20,
          style: isSelected ? NeumorphicStyle.debossed : NeumorphicStyle.embossed,
          color: _cardColor(),
          border: Border.all(color: _borderColor(), width: isSelected ? 2 : 1),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onTap,
              borderRadius: BorderRadius.circular(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 68),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    fontSize: 17,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isSelected && isCorrect != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: AppSpacing.sm),
                          child: Text(
                            isCorrect! ? '✅' : '💙',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
