import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/nova_motion.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/usecases/progress_use_cases.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import '../cubit/sessions_history_cubit.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<ProgressCubitFactory>().create(childId)..load(range: '7d'),
        ),
        BlocProvider(
          create: (_) => SessionsHistoryCubit(
            childId: childId,
            getSessions: getIt<GetSessionsUseCase>(),
          )..load(),
        ),
      ],
      child: _ProgressView(childId: childId),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProgressView extends StatefulWidget {
  const _ProgressView({required this.childId});
  final String childId;

  @override
  State<_ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<_ProgressView> {
  String _range = '7d';
  String? _selectedSkillId;
  List<SkillChartPoint> _chartPoints = [];
  bool _chartLoading = false;

  static const _ranges = ['7d', '30d', '90d'];
  static const _rangeLabels = ['٧ أيام', '٣٠ يوماً', '٩٠ يوماً'];

  Future<void> _loadChart(String skillId) async {
    setState(() {
      _selectedSkillId = skillId;
      _chartLoading = true;
    });
    final result = await getIt<GetSkillChartUseCase>()(
      widget.childId,
      skillId,
      range: _range,
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _chartLoading = false),
      (pts) => setState(() {
        _chartPoints = pts;
        _chartLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التقدم'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'معلومات',
            onPressed: () => _showDisclaimer(context),
          ),
        ],
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return const LoadingView();
          }
          if (state is ProgressError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<ProgressCubit>().load(range: _range),
            );
          }
          if (state is ProgressEmpty) {
            return _EmptyProgressView(
              onRetry: () => context.read<ProgressCubit>().load(range: _range),
            );
          }
          if (state is ProgressLoaded) {
            return _buildContent(context, state.overview);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProgressOverview overview) {
    final reduceMotion = NovaMotion.shouldReduceMotion(context);
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<ProgressCubit>().load(range: _range),
      child: ListView(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        children: [
          // ── Range selector ─────────────────────────────────────────────────
          _RangeSelector(
            selected: _range,
            ranges: _ranges,
            labels: _rangeLabels,
            onChanged: (r) {
              setState(() => _range = r);
              context.read<ProgressCubit>().changeRange(r);
              if (_selectedSkillId != null) _loadChart(_selectedSkillId!);
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Stat cards ─────────────────────────────────────────────────────
          Semantics(
            label:
                'إحصائيات: ${overview.sessionsCount} جلسة، نسبة نجاح ${(overview.avgSuccessRate * 100).toInt()}٪، ${overview.totalMinutes} دقيقة، ${overview.streakDays} يوم متتالي',
            child: _StatCardsRow(overview: overview),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Chart ─────────────────────────────────────────────────────────
          if (overview.bySkill.isNotEmpty) ...[
            _SectionHeader(title: 'المهارات — نسبة النجاح'),
            const SizedBox(height: AppSpacing.sm),
            _SkillDropdown(
              skills: overview.bySkill,
              selectedSkillId: _selectedSkillId,
              onChanged: (id) => _loadChart(id),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_selectedSkillId != null)
              _ChartCard(
                points: _chartPoints,
                isLoading: _chartLoading,
                reduceMotion: reduceMotion,
              ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Skills list ────────────────────────────────────────────────────
          if (overview.bySkill.isNotEmpty) ...[
            _SectionHeader(title: 'تفاصيل المهارات'),
            const SizedBox(height: AppSpacing.sm),
            ...overview.bySkill.map((s) => _SkillProgressTile(skill: s)),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Session history ────────────────────────────────────────────────
          _SectionHeader(title: 'آخر الجلسات'),
          const SizedBox(height: AppSpacing.sm),
          _SessionHistorySection(childId: widget.childId),
          const SizedBox(height: AppSpacing.xl),

          // ── Disclaimer footer ──────────────────────────────────────────────
          const _DisclaimerFooter(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ملاحظة مهمة'),
        content: const Text(
          'NOVA منصة تعليمية داعمة وليست أداة تشخيص.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Range selector
// ─────────────────────────────────────────────────────────────────────────────

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.selected,
    required this.ranges,
    required this.labels,
    required this.onChanged,
  });

  final String selected;
  final List<String> ranges;
  final List<String> labels;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(ranges.length, (i) {
          final isSelected = ranges[i] == selected;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onChanged(ranges[i]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.textOnPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat cards
// ─────────────────────────────────────────────────────────────────────────────

class _StatCardsRow extends StatelessWidget {
  const _StatCardsRow({required this.overview});
  final ProgressOverview overview;

  @override
  Widget build(BuildContext context) {
    final rate = overview.avgSuccessRate;
    final rateStr = '${(rate * 100).toInt()}٪';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.6,
      children: [
        _StatCard(
          icon: Icons.play_circle_outline_rounded,
          value: '${overview.sessionsCount}',
          label: 'الجلسات',
          color: AppColors.primary,
        ),
        _StatCard(
          icon: Icons.check_circle_outline_rounded,
          value: rateStr,
          label: 'نسبة النجاح',
          color: AppColors.success,
        ),
        _StatCard(
          icon: Icons.timer_outlined,
          value: '${overview.totalMinutes}',
          label: 'دقيقة',
          color: AppColors.secondary,
        ),
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          value: '${overview.streakDays}',
          label: 'أيام متتالية',
          color: AppColors.gentleRetry,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skill dropdown
// ─────────────────────────────────────────────────────────────────────────────

class _SkillDropdown extends StatelessWidget {
  const _SkillDropdown({
    required this.skills,
    required this.selectedSkillId,
    required this.onChanged,
  });

  final List<SkillProgress> skills;
  final String? selectedSkillId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text('اختر مهارة لعرض الرسم البياني'),
          value: selectedSkillId,
          items: skills
              .map((s) => DropdownMenuItem(
                    value: s.skillId,
                    child: Text(s.nameAr),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart card
// ─────────────────────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.points,
    required this.isLoading,
    required this.reduceMotion,
  });

  final List<SkillChartPoint> points;
  final bool isLoading;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (points.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('لا توجد بيانات كافية للرسم البياني.')),
      );
    }
    return Semantics(
      label: 'رسم بياني لنسبة النجاح',
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: LineChart(
          _buildLineChartData(),
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 400),
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    final spots = points.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.avgSuccessRate * 100);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (v) =>
            FlLine(color: AppColors.divider, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 25,
            reservedSize: 36,
            getTitlesWidget: (v, meta) => Text(
              '${v.toInt()}٪',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 2.5,
          dotData: FlDotData(
            show: spots.length <= 10,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 4,
              color: AppColors.primary,
              strokeColor: AppColors.surface,
              strokeWidth: 2,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skill progress tile
// ─────────────────────────────────────────────────────────────────────────────

class _SkillProgressTile extends StatelessWidget {
  const _SkillProgressTile({required this.skill});
  final SkillProgress skill;

  String _levelLabel(String level) => switch (level) {
        'BEGINNER' => 'مبتدئ',
        'INTERMEDIATE' => 'متوسط',
        'ADVANCED' => 'متقدم',
        _ => level,
      };

  Color _levelColor(String level) => switch (level) {
        'BEGINNER' => AppColors.secondary,
        'INTERMEDIATE' => AppColors.primary,
        'ADVANCED' => AppColors.success,
        _ => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final pct = skill.avgSuccessRate.clamp(0.0, 1.0);
    final levelLabel = _levelLabel(skill.level);
    final levelColor = _levelColor(skill.level);

    return Semantics(
      label:
          '${skill.nameAr}: مستوى $levelLabel، نسبة نجاح ${(pct * 100).toInt()}٪',
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    skill.nameAr,
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    levelLabel,
                    style: AppTextStyles.caption.copyWith(color: levelColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${(pct * 100).toInt()}٪',
                  style: AppTextStyles.caption.copyWith(
                    color: levelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Session history section
// ─────────────────────────────────────────────────────────────────────────────

class _SessionHistorySection extends StatelessWidget {
  const _SessionHistorySection({required this.childId});
  final String childId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsHistoryCubit, SessionsHistoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.hasError) {
          return ErrorView(
            message: state.errorMessage,
            onRetry: () => context.read<SessionsHistoryCubit>().load(),
          );
        }
        if (state.items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(
              child: Text(
                'لسه ما فيش جلسات',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }
        return Column(
          children: [
            ...state.items.map((s) => _SessionTile(session: s)),
            if (state.hasMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: state.isLoadingMore
                    ? const CircularProgressIndicator()
                    : OutlinedButton(
                        onPressed: () =>
                            context.read<SessionsHistoryCubit>().loadMore(),
                        child: const Text('تحميل المزيد'),
                      ),
              ),
          ],
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});
  final SessionSummary session;

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatDuration(int ms) {
    final mins = (ms / 60000).round();
    return '$mins د';
  }

  @override
  Widget build(BuildContext context) {
    final stars = session.stars.clamp(0, 3);
    final successPct = (session.successRate * 100).toInt();

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Stars
          Column(
            children: List.generate(
              3,
              (i) => Icon(
                Icons.star_rounded,
                size: 14,
                color: i < stars ? AppColors.starFilled : AppColors.starEmpty,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.activityTitle,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(session.startedAt)} · ${_formatDuration(session.durationMs)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          // Success %
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$successPct٪',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty progress view
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyProgressView extends StatelessWidget {
  const _EmptyProgressView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              size: 72,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'لسه ما فيش جلسات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'ابدأ نشاطاً مع طفلك وستظهر هنا إحصائيات التقدم.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            const _DisclaimerFooter(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Disclaimer footer
// ─────────────────────────────────────────────────────────────────────────────

class _DisclaimerFooter extends StatelessWidget {
  const _DisclaimerFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Text(
              'NOVA منصة تعليمية داعمة وليست أداة تشخيص.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header helper
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.headlineMedium);
  }
}
