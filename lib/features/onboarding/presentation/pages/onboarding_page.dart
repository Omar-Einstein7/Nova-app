import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/storage/prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/onboarding_cubit.dart';

/// Onboarding: 3 slides with Skip, Next/Start buttons.
/// Marks [Prefs.onboardingSeen] before navigating to login.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(prefs: getIt<Prefs>()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _skip(BuildContext context) async {
    await context.read<OnboardingCubit>().complete();
    if (context.mounted) context.goNamed(RouteNames.login);
  }

  Future<void> _next(BuildContext context, int currentPage, int total) async {
    if (currentPage < total - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await context.read<OnboardingCubit>().complete();
      if (context.mounted) context.goNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final slides = [
      _OnboardingSlide(
        // [PLACEHOLDER: slide 1 illustration asset]
        illustrationIcon: Icons.lightbulb_outline_rounded,
        illustrationColor: const Color(0xFFFFF9C4),
        iconColor: const Color(0xFFF9A825),
        title: l10n.onboardingSlide1Title,
        body: l10n.onboardingSlide1Body,
      ),
      _OnboardingSlide(
        // [PLACEHOLDER: slide 2 illustration asset]
        illustrationIcon: Icons.favorite_border_rounded,
        illustrationColor: const Color(0xFFFCE4EC),
        iconColor: const Color(0xFFEC407A),
        title: l10n.onboardingSlide2Title,
        body: l10n.onboardingSlide2Body,
      ),
      _OnboardingSlide(
        // [PLACEHOLDER: slide 3 illustration asset]
        illustrationIcon: Icons.bar_chart_rounded,
        illustrationColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF43A047),
        title: l10n.onboardingSlide3Title,
        body: l10n.onboardingSlide3Body,
      ),
    ];

    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        final isLast = currentPage == slides.length - 1;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Skip button ───────────────────────────────────────────
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: AnimatedOpacity(
                      opacity: isLast ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        key: const Key('onboarding_skip_button'),
                        onPressed: isLast ? null : () => _skip(context),
                        child: Text(l10n.onboardingSkip),
                      ),
                    ),
                  ),
                ),

                // ── Slides ────────────────────────────────────────────────
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: slides.length,
                    onPageChanged: (p) =>
                        context.read<OnboardingCubit>().goToPage(p),
                    itemBuilder: (_, i) => _SlideContent(slide: slides[i]),
                  ),
                ),

                // ── Dots indicator ────────────────────────────────────────
                _DotsIndicator(
                  count: slides.length,
                  current: currentPage,
                ),
                const SizedBox(height: 24),

                // ── Next / Start button ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: SizedBox(
                      key: ValueKey(isLast),
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        key: Key(isLast
                            ? 'onboarding_start_button'
                            : 'onboarding_next_button'),
                        onPressed: () =>
                            _next(context, currentPage, slides.length),
                        child: Text(
                          isLast ? l10n.onboardingStart : l10n.onboardingNext,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Slide data class ──────────────────────────────────────────────────────────

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.illustrationIcon,
    required this.illustrationColor,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData illustrationIcon;
  final Color illustrationColor;
  final Color iconColor;
  final String title;
  final String body;
}

// ── Slide content widget ──────────────────────────────────────────────────────

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // [PLACEHOLDER: replace container with Image.asset illustration]
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: slide.illustrationColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.illustrationIcon,
              size: 100,
              color: slide.iconColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Dots indicator ────────────────────────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == current ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == current
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
