import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_view.dart';
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
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => context.pop(),
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
                      const SizedBox(height: 20),

                      // ── Recommendation card ──────────────────────────────
                      _RecommendationCard(
                        state: state,
                        childId: childId,
                        child: child,
                      ),
                      const SizedBox(height: 20),

                      // ── Quick stats ──────────────────────────────────────
                      _QuickStatsRow(state: state),
                      const SizedBox(height: 20),

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            _AvatarCircle(avatar: child?.avatar, name: name),
            const SizedBox(height: 10),
            Text(name,
                style: AppTextStyles.titleLarge
                    .copyWith(color: Colors.white, fontSize: 22)),
            if (age != null)
              Text(l.childAgeLabel(age),
                  style:
                      AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
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

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 38))),
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

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        key: const Key('start_play_button'),
        onPressed: isLoading || recommendation == null
            ? null
            : () => _startActivity(context, recommendation, childId),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.play_circle_outline,
                color: Colors.white, size: 28),
        label: Text(
          l.startPlay,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
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
              const Icon(Icons.star_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(skillName,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColors.primary)),
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
                child: Text(l.chooseSkill,
                    style: const TextStyle(color: AppColors.secondary)),
              ),
            ],
          ),
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(reason,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ],
          if (suggestBreak) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.starFilled.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.coffee_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(l.suggestBreak,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
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
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            key: const Key('stat_streak'),
            icon: Icons.local_fire_department_outlined,
            value: '${progress['streakDays'] ?? 0}',
            label: l.statStreak,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            key: const Key('stat_success'),
            icon: Icons.emoji_events_outlined,
            value:
                '${((progress['avgSuccessRate'] as num? ?? 0) * 100).round()}%',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.primary, fontSize: 20)),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
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
    return TextButton.icon(
      key: const Key('full_progress_link'),
      onPressed: () => context.pushNamed(
        'progress',
        pathParameters: {'childId': childId},
      ),
      icon: const Icon(Icons.bar_chart_outlined, color: AppColors.primary),
      label: Text(l.viewFullProgress,
          style: const TextStyle(color: AppColors.primary)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
