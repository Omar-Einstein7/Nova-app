import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/nova_motion.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../domain/entities/activity.dart';

/// Full-screen result page shown after session is completed in Neumorphic styling.
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
    final reduceMotion = NovaMotion.shouldReduceMotion(context);
    final stars = widget.result.stars.clamp(1, 3);
    final pctStr = NovaFormatters.formatPercentage(widget.result.successRate);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Stars with Neumorphic circular badges
              Semantics(
                label: 'النتيجة: حصلت على $stars نجوم من أصل 3',
                child: ScaleTransition(
                  scale: reduceMotion
                      ? const AlwaysStoppedAnimation(1.0)
                      : _scaleAnim,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: NeumorphicContainer(
                          shape: BoxShape.circle,
                          width: 64,
                          height: 64,
                          distance: 4,
                          blur: 8,
                          color: AppColors.surface,
                          child: Center(
                            child: Text(
                              i < stars ? '⭐' : '☆',
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Headline
              Text(
                _headline,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stats card
              NeumorphicCard(
                radius: 20,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    _StatRow(label: 'نسبة الإجابات الصحيحة', value: pctStr),
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
                _LevelChangeBadge(levelChange: widget.result.levelChange!),
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
              Semantics(
                button: true,
                label: 'بدء نشاط تعليمي آخر',
                child: AppButton(
                  variant: AppButtonVariant.child,
                  label: 'نشاط آخر 🎮',
                  onPressed: widget.onPlayAgain,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Go home
              Semantics(
                button: true,
                label: 'العودة إلى الصفحة الرئيسية',
                child: AppButton(
                  variant: AppButtonVariant.secondary,
                  label: 'العودة للرئيسية',
                  onPressed: widget.onGoHome,
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
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
        ),
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
    return NeumorphicContainer(
      radius: 18,
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: const Color(0xFFE8F5E9),
      border: Border.all(color: AppColors.success.withValues(alpha: 0.6)),
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
    return NeumorphicCard(
      radius: 18,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          NeumorphicContainer(
            shape: BoxShape.circle,
            width: 36,
            height: 36,
            distance: 2,
            blur: 4,
            color: AppColors.surface,
            child: const Center(child: Text('💡', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              rec.reason.isNotEmpty ? rec.reason : 'استمر في التعلم!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
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
    return NeumorphicContainer(
      radius: 18,
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: const Color(0xFFFFF8E1),
      border: Border.all(color: AppColors.gentleRetry.withValues(alpha: 0.6)),
      child: Row(
        children: [
          const Text('☕', style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'يُفضل أخذ استراحة قصيرة قبل النشاط القادم',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
