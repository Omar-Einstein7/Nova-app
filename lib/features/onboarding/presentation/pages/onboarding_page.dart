import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/storage/prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../cubit/onboarding_cubit.dart';

/// Onboarding: 3 slides with Skip, Next/Start buttons in Neumorphic styling.
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
                    padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
                    child: AnimatedOpacity(
                      opacity: isLast ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        key: const Key('onboarding_skip_button'),
                        onPressed: isLast ? null : () => _skip(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          textStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
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
                const SizedBox(height: 28),

                // ── Next / Start button ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: AppButton(
                      key: Key(isLast
                          ? 'onboarding_start_button'
                          : 'onboarding_next_button'),
                      label: isLast ? l10n.onboardingStart : l10n.onboardingNext,
                      onPressed: () =>
                          _next(context, currentPage, slides.length),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
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
          // Neumorphic illustration disc
          NeumorphicContainer(
            shape: BoxShape.circle,
            width: 200,
            height: 200,
            color: AppColors.surface,
            distance: 8,
            blur: 16,
            child: Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: slide.illustrationColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  slide.illustrationIcon,
                  size: 72,
                  color: slide.iconColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 44),
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                  fontSize: 16,
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
        (i) {
          final isSelected = i == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: isSelected ? 28 : 10,
            height: 10,
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: AppNeumorphism.primaryGlowShadows(
                      distance: 2,
                      blur: 6,
                    ),
                  )
                : AppNeumorphism.debossedDecoration(
                    color: AppColors.surfaceVariant,
                    radius: 5,
                    border: Border.all(
                      color: AppColors.shadowDark.withValues(alpha: 0.2),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
