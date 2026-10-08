import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../children/domain/entities/child.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';

/// Step 2: interests chips + learning style cards with Neumorphic styling.
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
            Text(l.interestsLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(l.interestsHint,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            _InterestChips(
              selected: state.interests,
              onToggle: cubit.toggleInterest,
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 10),
                NeumorphicContainer(
                  shape: BoxShape.circle,
                  width: 48,
                  height: 48,
                  distance: 3,
                  blur: 6,
                  color: AppColors.surface,
                  child: IconButton(
                    key: const Key('add_interest_btn'),
                    onPressed: () {
                      cubit.addCustomInterest(_customCtrl.text);
                      _customCtrl.clear();
                    },
                    icon: const Icon(Icons.add_rounded,
                        color: AppColors.primary, size: 28),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Learning style ─────────────────────────────────────────────
            Text(l.learningStyleLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
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
    final allInterests = {
      ..._defaults,
      ...selected.where((s) => !_defaults.contains(s)),
    }.toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: allInterests.map((interest) {
        final isSelected = selected.contains(interest);
        return GestureDetector(
          key: Key('interest_$interest'),
          onTap: () => onToggle(interest),
          child: NeumorphicContainer(
            radius: 20,
            style: isSelected ? NeumorphicStyle.debossed : NeumorphicStyle.embossed,
            color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
            distance: isSelected ? 2 : 3,
            blur: isSelected ? 4 : 6,
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1.5)
                : Border.all(color: Colors.white.withValues(alpha: 0.6)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                ],
                Text(
                  interest,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
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
    return NeumorphicContainer(
      onTap: onTap,
      radius: 18,
      style: isSelected ? NeumorphicStyle.debossed : NeumorphicStyle.embossed,
      color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
      distance: isSelected ? 2 : 4,
      blur: isSelected ? 4 : 8,
      border: isSelected
          ? Border.all(color: AppColors.primary, width: 2)
          : Border.all(color: Colors.white.withValues(alpha: 0.6)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          NeumorphicContainer(
            shape: BoxShape.circle,
            width: 48,
            height: 48,
            distance: 2,
            blur: 4,
            color: isSelected ? AppColors.primary : AppColors.surface,
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle,
                color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}
