import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../children/domain/entities/child.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';

/// Step 2: interests chips + learning style cards.
class Step2Style extends StatefulWidget {
  const Step2Style({super.key});

  @override
  State<Step2Style> createState() => _Step2StyleState();
}

class _Step2StyleState extends State<Step2Style> {
  final _customCtrl = TextEditingController();

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<ChildFormCubit>();

    return BlocBuilder<ChildFormCubit, ChildFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Interests ──────────────────────────────────────────────────
            Text(l.interestsLabel, style: AppTextStyles.labelMedium),
            const SizedBox(height: 4),
            Text(l.interestsHint,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            _InterestChips(
              selected: state.interests,
              onToggle: cubit.toggleInterest,
            ),
            const SizedBox(height: 12),
            // Custom interest input
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    key: const Key('custom_interest_field'),
                    controller: _customCtrl,
                    hint: l.addCustomInterestHint,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('add_interest_btn'),
                  onPressed: () {
                    cubit.addCustomInterest(_customCtrl.text);
                    _customCtrl.clear();
                  },
                  icon: const Icon(Icons.add_circle,
                      color: AppColors.primary, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Learning style ─────────────────────────────────────────────
            Text(l.learningStyleLabel, style: AppTextStyles.labelMedium),
            const SizedBox(height: 12),
            _LearningStyleCards(
              selected: state.learningStyle,
              onSelect: cubit.setLearningStyle,
            ),
          ],
        );
      },
    );
  }
}

// ── Interests chips ───────────────────────────────────────────────────────────

class _InterestChips extends StatelessWidget {
  const _InterestChips({
    required this.selected,
    required this.onToggle,
  });
  final List<String> selected;
  final void Function(String) onToggle;

  // Pre-defined interests [PLACEHOLDER: move to l10n if multilingual support added]
  static const _defaults = [
    'حيوانات',
    'سيارات',
    'فضاء',
    'ألوان',
    'كرة القدم',
    'ديناصورات',
    'موسيقى',
    'رسم',
    'قطارات',
    'بحر',
  ];

  @override
  Widget build(BuildContext context) {
    // Combine defaults with any custom interests that were added
    final allInterests = {
      ..._defaults,
      ...selected.where((s) => !_defaults.contains(s)),
    }.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allInterests.map((interest) {
        final isSelected = selected.contains(interest);
        return FilterChip(
          key: Key('interest_$interest'),
          label: Text(interest),
          selected: isSelected,
          onSelected: (_) => onToggle(interest),
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primary,
          labelStyle: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          backgroundColor: AppColors.surface,
        );
      }).toList(),
    );
  }
}

// ── Learning style cards ──────────────────────────────────────────────────────

class _LearningStyleCards extends StatelessWidget {
  const _LearningStyleCards({
    required this.selected,
    required this.onSelect,
  });
  final LearningStyle? selected;
  final void Function(LearningStyle) onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final styles = [
      (
        LearningStyle.visual,
        Icons.remove_red_eye_outlined,
        l.learningStyleVisual,
        l.learningStyleVisualDesc,
        'learning_style_visual',
      ),
      (
        LearningStyle.auditory,
        Icons.hearing_outlined,
        l.learningStyleAuditory,
        l.learningStyleAuditoryDesc,
        'learning_style_auditory',
      ),
      (
        LearningStyle.mixed,
        Icons.auto_awesome_outlined,
        l.learningStyleMixed,
        l.learningStyleMixedDesc,
        'learning_style_mixed',
      ),
    ];

    return Column(
      children: styles.map((record) {
        final (style, icon, title, desc, key) = record;
        final isSelected = selected == style;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _StyleCard(
            key: Key(key),
            icon: icon,
            title: title,
            description: desc,
            isSelected: isSelected,
            onTap: () => onSelect(style),
          ),
        );
      }).toList(),
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surface,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? AppColors.primary : AppColors.surfaceVariant,
                ),
                child: Icon(icon,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        )),
                    const SizedBox(height: 2),
                    Text(description,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: AppColors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
