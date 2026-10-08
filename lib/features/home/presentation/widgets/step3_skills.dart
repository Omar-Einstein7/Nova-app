import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova/core/theme/app_neumorphism.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';
import '../../../skills/domain/entities/skill.dart';
import '../../../skills/presentation/cubit/skills_cubit.dart';
import '../../../skills/presentation/cubit/skills_state.dart';

/// Step 3: multi-select skills from GET /skills in Neumorphic styling.
class Step3Skills extends StatelessWidget {
  const Step3Skills({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocBuilder<SkillsCubit, SkillsState>(
      builder: (context, skillsState) {
        return switch (skillsState) {
          SkillsStateLoading() || SkillsStateInitial() => const LoadingView(),
          SkillsStateError() => ErrorView(
              message: l.errorGeneric,
              onRetry: () =>
                  context.read<SkillsCubit>().load(forceRefresh: true),
            ),
          SkillsStateLoaded(:final skills) =>
            BlocBuilder<ChildFormCubit, ChildFormState>(
              builder: (context, formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.selectSkillsLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      l.selectSkillsHint,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ...skills.map(
                      (skill) => _SkillTile(
                        skill: skill,
                        isSelected:
                            formState.selectedSkillIds.contains(skill.id),
                        onToggle: () => context
                            .read<ChildFormCubit>()
                            .toggleSkill(skill.id),
                      ),
                    ),
                  ],
                );
              },
            ),
        };
      },
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({
    required this.skill,
    required this.isSelected,
    required this.onToggle,
  });
  final Skill skill;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicContainer(
        key: Key('skill_tile_${skill.id}'),
        onTap: onToggle,
        radius: 16,
        style: isSelected ? NeumorphicStyle.debossed : NeumorphicStyle.embossed,
        color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
        distance: isSelected ? 2 : 4,
        blur: isSelected ? 4 : 8,
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: Colors.white.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            NeumorphicContainer(
              shape: BoxShape.circle,
              width: 42,
              height: 42,
              distance: 2,
              blur: 4,
              color: isSelected ? AppColors.primary : AppColors.surface,
              child: Icon(
                Icons.auto_stories_outlined,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.nameAr,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (skill.description != null &&
                      skill.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      skill.description!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
