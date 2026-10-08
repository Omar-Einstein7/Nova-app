import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../children/domain/entities/child.dart';
import '../../../children/presentation/cubit/children_list_cubit.dart';
import '../../../children/presentation/cubit/children_list_state.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class ChildDashboardPage extends StatelessWidget {
  const ChildDashboardPage({
    super.key,
    required this.childId,
    this.initialChild,
  });

  final String childId;
  final Child? initialChild;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => getIt<DashboardCubitFactory>().create(childId)..load(),
      child: _DashboardView(childId: childId, initialChild: initialChild),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.childId, this.initialChild});
  final String childId;
  final Child? initialChild;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        // Resolve child from initial parameter or list cubit if available
        final child = initialChild ?? _findChild(context, childId);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── App bar / header ─────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.surface,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  child: Center(
                    child: NeumorphicContainer(
                      shape: BoxShape.circle,
                      width: 40,
                      height: 40,
                      distance: 3,
                      blur: 6,
                      color: AppColors.surface,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary, size: 18),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _DashboardHeader(child: child),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Start play button ────────────────────────────────
                      _StartPlayButton(state: state, childId: childId),
                      const SizedBox(height: 24),

                      // ── Recommendation card ──────────────────────────────
                      _RecommendationCard(
                        state: state,
                        childId: childId,
                        child: child,
                      ),
                      const SizedBox(height: 24),

                      // ── Quick stats ──────────────────────────────────────
                      _QuickStatsRow(state: state),
                      const SizedBox(height: 24),

                      // ── Full progress link ───────────────────────────────
                      _ProgressLink(childId: childId),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Child? _findChild(BuildContext context, String id) {
    try {
      final listState = context.read<ChildrenListCubit>().state;
      if (listState is ChildrenListStateLoaded) {
        return listState.children.cast<Child?>().firstWhere(
              (c) => c?.id == id,
              orElse: () => null,
            );
      }
    } catch (_) {
      // ChildrenListCubit is not above this page in the provider tree
    }
    return null;
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({this.child});
  final Child? child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final name = child?.name ?? '...';
    final age = child?.age;

    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            _AvatarCircle(avatar: child?.avatar, name: name),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (age != null)
              Text(
                l.childAgeLabel(age),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({this.avatar, required this.name});
  final String? avatar;
  final String name;

  static const _emojis = [
    '🐱',
    '🐶',
    '🦊',
    '🐼',
    '🦁',
    '🐸',
    '🦋',
    '🐧',
    '🐨',
    '🦄',
    '🐰',
    '🐻',
  ];

  @override
  Widget build(BuildContext context) {
    final emoji = avatar != null && int.tryParse(avatar!) != null
        ? _emojis[int.parse(avatar!) % _emojis.length]
        : (name.isNotEmpty
            ? _emojis[name.codeUnitAt(0) % _emojis.length]
            : '🌟');

    return NeumorphicContainer(
      shape: BoxShape.circle,
      width: 84,
      height: 84,
      distance: 5,
      blur: 12,
      color: AppColors.surface,
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceVariant,
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 38))),
        ),
      ),
    );
  }
}

// ── Start play button ─────────────────────────────────────────────────────────

class _StartPlayButton extends StatelessWidget {
  const _StartPlayButton({required this.state, required this.childId});
  final DashboardState state;
  final String childId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isLoading = state is DashboardStateLoading;
    final recommendation = state is DashboardStateLoaded
        ? (state as DashboardStateLoaded).recommendation
        : null;

    return AppButton(
      key: const Key('start_play_button'),
      variant: AppButtonVariant.child,
      isLoading: isLoading,
      icon: const Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
      label: l.startPlay,
      onPressed: isLoading || recommendation == null
          ? null
          : () => _startActivity(context, recommendation, childId),
    );
  }

  void _startActivity(
      BuildContext context, Map<String, dynamic> rec, String childId) {
    context.pushNamed('activity', extra: {
      'childId': childId,
      'skillId': rec['skillId'] as String?,
      'difficulty': rec['difficulty'] as String?,
    });
  }
}

// ── Recommendation card ───────────────────────────────────────────────────────

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.state,
    required this.childId,
    this.child,
  });
  final DashboardState state;
  final String childId;
  final Child? child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (state is DashboardStateLoading) {
      return _CardShell(
        title: l.todaySuggestion,
        child: const SizedBox(height: 60, child: LoadingView()),
      );
    }

    if (state is! DashboardStateLoaded) {
      return const SizedBox.shrink();
    }

    final rec = (state as DashboardStateLoaded).recommendation;
    final skillName = rec['skillName'] as String? ?? l.generalSkill;
    final reason = rec['reason'] as String? ?? '';
    final suggestBreak = rec['suggestBreak'] as bool? ?? false;

    return _CardShell(
      title: l.todaySuggestion,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NeumorphicContainer(
                shape: BoxShape.circle,
                width: 38,
                height: 38,
                distance: 2,
                blur: 5,
                color: AppColors.surface,
                child: const Icon(Icons.star_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  skillName,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                key: const Key('choose_skill_btn'),
                onPressed: () {
                  if (child != null) {
                    context.pushNamed(
                      'startActivity',
                      pathParameters: {'childId': childId},
                      extra: {'child': child},
                    );
                  } else {
                    context.pushNamed('activity', extra: {
                      'childId': childId,
                    });
                  }
                },
                child: Text(
                  l.chooseSkill,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              reason,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          if (suggestBreak) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.starFilled.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.starFilled.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.coffee_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    l.suggestBreak,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Quick stats row ───────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (state is! DashboardStateLoaded) return const SizedBox.shrink();
    final progress = (state as DashboardStateLoaded).progress;

    if (progress == null) {
      // Graceful fallback when progress call failed
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(l.progressUnavailable,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textSecondary)),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            key: const Key('stat_sessions'),
            icon: Icons.book_outlined,
            value: '${progress['sessionsCount'] ?? 0}',
            label: l.statSessions,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            key: const Key('stat_streak'),
            icon: Icons.local_fire_department_outlined,
            value: '${progress['streakDays'] ?? 0}',
            label: l.statStreak,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            key: const Key('stat_success'),
            icon: Icons.emoji_events_outlined,
            value: NovaFormatters.formatPercentage(
              progress['avgSuccessRate'] as num?,
            ),
            label: l.statSuccess,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      radius: 18,
      distance: 3,
      blur: 7,
      color: AppColors.surface,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Progress link ─────────────────────────────────────────────────────────────

class _ProgressLink extends StatelessWidget {
  const _ProgressLink({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: TextButton.icon(
        key: const Key('full_progress_link'),
        onPressed: () => context.pushNamed(
          'progress',
          pathParameters: {'childId': childId},
        ),
        icon: const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
        label: Text(
          l.viewFullProgress,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ── Card shell ────────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  const _CardShell({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      radius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
