import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../children/domain/entities/child.dart';
import '../../../skills/presentation/cubit/skills_cubit.dart';
import '../../../skills/presentation/cubit/skills_state.dart';

/// Page shown before generating an activity.
/// Shows the child's assigned skills with level badges.
/// Tapping a skill navigates to ActivityPage with skillId + childId.
///
/// Also accepts [preselectedSkillId] to immediately trigger generation
/// (used from the dashboard "ابدأ اللعب" button with recommended skill).
class StartActivityPage extends StatefulWidget {
  const StartActivityPage({
    super.key,
    required this.child,
    this.preselectedSkillId,
  });

  final Child child;
  final String? preselectedSkillId;

  @override
  State<StartActivityPage> createState() => _StartActivityPageState();
}

class _StartActivityPageState extends State<StartActivityPage> {
  @override
  void initState() {
    super.initState();
    // If a preselected skill is provided, navigate immediately after first frame
    if (widget.preselectedSkillId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigate(widget.preselectedSkillId);
      });
    }
  }

  void _navigate(String? skillId) {
    context.pushNamed(
      RouteNames.activity,
      extra: {
        'childId': widget.child.id,
        if (skillId != null) 'skillId': skillId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SkillsCubit>.value(
      value: getIt<SkillsCubit>()..load(),
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'اختر مهارة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Child greeting
              _ChildHeader(child: widget.child),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                'مهارات ${widget.child.name}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Skills list
              Expanded(
                child: widget.child.skills.isEmpty
                    ? const _NoSkillsView()
                    : BlocBuilder<SkillsCubit, SkillsState>(
                        builder: (context, skillsState) {
                          final allSkills = skillsState
                              .maybeWhen(
                                loaded: (s) => s,
                                orElse: () => <dynamic>[],
                              )
                              .cast<dynamic>();

                          return ListView.separated(
                            itemCount: widget.child.skills.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final childSkill =
                                  widget.child.skills[index];
                              final skillName = _findSkillName(
                                allSkills,
                                childSkill.skillId,
                                childSkill.key,
                              );
                              return _SkillCard(
                                skillId: childSkill.skillId,
                                name: skillName,
                                level: childSkill.level,
                                onTap: () =>
                                    _navigate(childSkill.skillId),
                              );
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Generate without specific skill
              OutlinedButton(
                onPressed: () => _navigate(null),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'نشاط عشوائي 🎲',
                  style: TextStyle(color: AppColors.primary, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  String _findSkillName(List<dynamic> skills, String id, String fallbackKey) {
    try {
      // ignore: avoid_dynamic_calls
      final match = skills.firstWhere((s) => s.id == id);
      // ignore: avoid_dynamic_calls
      return match.nameAr as String;
    } catch (_) {
      return fallbackKey;
    }
  }
}

// ── Child header ──────────────────────────────────────────────────────────────

class _ChildHeader extends StatelessWidget {
  const _ChildHeader({required this.child});
  final Child child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              child.avatar ??
                  (child.name.isNotEmpty ? child.name[0] : '👤'),
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يلا ${child.name}!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                Text(
                  'اختر مهارة وابدأ النشاط',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skill card ────────────────────────────────────────────────────────────────

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.skillId,
    required this.name,
    required this.level,
    required this.onTap,
  });

  final String skillId;
  final String name;
  final SkillLevel level;
  final VoidCallback onTap;

  String get _levelLabel => switch (level) {
        SkillLevel.beginner => 'مبتدئ',
        SkillLevel.intermediate => 'متوسط',
        SkillLevel.advanced => 'متقدم',
      };

  Color get _levelColor => switch (level) {
        SkillLevel.beginner => const Color(0xFF66BB6A),
        SkillLevel.intermediate => const Color(0xFF42A5F5),
        SkillLevel.advanced => const Color(0xFFAB47BC),
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_outline,
                    color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: _levelColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _levelColor, width: 1),
                ),
                child: Text(
                  _levelLabel,
                  style: TextStyle(
                    color: _levelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoSkillsView extends StatelessWidget {
  const _NoSkillsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📚', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'لم تُحدَّد مهارات بعد.\nيمكنك توليد نشاط عشوائي!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
