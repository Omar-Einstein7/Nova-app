import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/nova_motion.dart';

/// Calm waiting screen shown while the AI backend generates an activity.
/// Respects NovaMotion.shouldReduceMotion (system & settings).
/// Pacing: 2.5 seconds per half-cycle (>= 5s full cycle, strictly >= 2000ms).
/// No flashing, no opacity blinking.
class GeneratingView extends StatefulWidget {
  const GeneratingView({super.key});

  @override
  State<GeneratingView> createState() => _GeneratingViewState();
}

class _GeneratingViewState extends State<GeneratingView>
    with SingleTickerProviderStateMixin {
  static const _messages = [
    'بنجهز لك نشاط جميل... 🎨',
    'جارٍ تخصيص النشاط لك... ✨',
    'نوفا تفكر في أفضل نشاط... 🧠',
    'تقريباً جاهز... 🌟',
  ];

  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late Timer _messageTimer;

  int _messageIndex = 0;
  bool _showPatience = false;
  Timer? _patienceTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: NovaMotion.minCycleDuration,
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _messageTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });

    _patienceTimer = Timer(const Duration(seconds: 12), () {
      if (mounted) setState(() => _showPatience = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageTimer.cancel();
    _patienceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = NovaMotion.shouldReduceMotion(context);
    final activeMessage = _messages[_messageIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Semantics(
          label: 'جارٍ تجهيز النشاط التعليمي: $activeMessage',
          liveRegion: true,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing star / brain emoji (calm, subtle)
                  reduceMotion
                      ? const Text('🌟', style: TextStyle(fontSize: 72))
                      : ScaleTransition(
                          scale: _scaleAnim,
                          child: const Text(
                            '🌟',
                            style: TextStyle(fontSize: 72),
                          ),
                        ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Animated message
                  AnimatedSwitcher(
                    duration: NovaMotion.duration(context,
                        normal: const Duration(milliseconds: 500)),
                    child: Text(
                      activeMessage,
                      key: ValueKey(_messageIndex),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  if (_showPatience) ...[
                    const SizedBox(height: AppSpacing.xl),
                    AnimatedOpacity(
                      opacity: _showPatience ? 1.0 : 0.0,
                      duration: NovaMotion.duration(context,
                          normal: const Duration(milliseconds: 600)),
                      child: Text(
                        'لسّه شوية... شكراً لصبرك 😊',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),
                  // Dots indicator (static when reduceMotion is true)
                  _DotsIndicator(
                    controller: _controller,
                    reduceMotion: reduceMotion,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.controller,
    required this.reduceMotion,
  });

  final AnimationController controller;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final offset = i / 3.0;
            final progress = ((controller.value + offset) % 1.0);
            final size = 8.0 + 3.0 * progress;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
