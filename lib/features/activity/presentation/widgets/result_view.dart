import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/activity.dart';

/// Full-screen result page shown after session is completed.
class ResultView extends StatefulWidget {
  const ResultView({
    super.key,
    required this.result,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  final SessionResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _headline {
    if (widget.result.stars >= 3) return 'ممتاز! 🏆';
    if (widget.result.stars == 2) return 'أحسنت! 🌟';
    return 'جيد! استمر 💙';
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final stars = widget.result.stars.clamp(1, 3);
    final pct =
        (widget.result.successRate * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Stars
              ScaleTransition(
                scale: reduceMotion
                    ? AlwaysStoppedAnimation(1.0)
                    : _scaleAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        i < stars ? '⭐' : '☆',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Headline
              Text(
                _headline,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stats card
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _StatRow(
                        label: 'نسبة الإجابات الصحيحة', value: '$pct%'),
                    const Divider(height: AppSpacing.xl),
                    _StatRow(
                        label: 'النجوم المكتسبة',
                        value: '${widget.result.stars} / 3'),
                  ],
                ),
              ),

              // Level change
              if (widget.result.levelChange != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _LevelChangeBadge(
                    levelChange: widget.result.levelChange!),
              ],

              // Recommendation
              if (widget.result.recommendation != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _RecommendationCard(rec: widget.result.recommendation!),
              ],

              const SizedBox(height: AppSpacing.xxl),

              // Suggest break
              if (widget.result.recommendation?.suggestBreak == true) ...[
                _BreakSuggestion(),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Play again
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: widget.onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'نشاط آخر 🎮',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Go home
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: widget.onGoHome,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary)),
        Text(value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                )),
      ],
    );
  }
}

class _LevelChangeBadge extends StatelessWidget {
  const _LevelChangeBadge({required this.levelChange});
  final LevelChange levelChange;

  String _levelLabel(String raw) => switch (raw.toUpperCase()) {
        'BEGINNER' => 'مبتدئ',
        'INTERMEDIATE' => 'متوسط',
        'ADVANCED' => 'متقدم',
        _ => raw,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'ارتقيت من ${_levelLabel(levelChange.from)} إلى ${_levelLabel(levelChange.to)}!',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.rec});
  final NextRecommendation rec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              rec.reason.isNotEmpty ? rec.reason : 'استمر في التعلم!',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gentleRetry),
      ),
      child: Row(
        children: [
          const Text('☕', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'يُفضل أخذ استراحة قصيرة قبل النشاط القادم',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
