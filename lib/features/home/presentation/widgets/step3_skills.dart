import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';
import '../../../skills/domain/entities/skill.dart';
import '../../../skills/presentation/cubit/skills_cubit.dart';
import '../../../skills/presentation/cubit/skills_state.dart';

/// Step 3: multi-select skills from GET /skills.
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
                    Text(l.selectSkillsLabel, style: AppTextStyles.labelMedium),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          key: Key('skill_tile_${skill.id}'),
          onTap: onToggle,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(skill.nameAr,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          )),
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
        ),
      ),
    );
  }
}
