import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Calm looping animation shown while the AI generates an activity.
/// Respects MediaQuery.disableAnimations / reduceMotion.
/// After 12 s, shows an extra patience message.
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
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
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
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing star / brain emoji
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
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _messages[_messageIndex],
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
                    duration: const Duration(milliseconds: 600),
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
                // Soft dots indicator
                reduceMotion
                    ? const SizedBox.shrink()
                    : _DotsIndicator(controller: _controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final offset = i / 3;
            final value = ((controller.value + offset) % 1.0);
            final size = 8.0 + 4.0 * value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.4 + 0.6 * value),
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
