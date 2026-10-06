import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/children/domain/entities/child.dart';
import '../../features/children/presentation/pages/children_page.dart';
import '../../features/home/presentation/pages/child_dashboard_page.dart';
import '../../features/home/presentation/pages/child_form_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/activity/presentation/pages/activity_page.dart';
import '../storage/prefs.dart';
import 'route_names.dart';

/// Builds the [GoRouter] for the NOVA app.
/// Auth state is driven by [AuthCubit.routerListenable].
GoRouter buildRouter({
  required AuthCubit authCubit,
  required Prefs prefs,
}) {
  return GoRouter(
    refreshListenable: authCubit.routerListenable,
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = authCubit.state;
      final onboardingSeen = prefs.onboardingSeen;

      final location = state.uri.toString();
      final isOnAuth = location.startsWith('/auth');
      final isOnOnboarding = location.startsWith('/onboarding');
      final isOnSplash = location.startsWith('/splash');

      // While auth state is unknown, stay on splash
      if (authState is AuthStateUnknown) {
        return isOnSplash ? null : '/splash';
      }

      final isAuthenticated = authState is AuthStateAuthenticated;

      if (isOnSplash) {
        if (!onboardingSeen) return '/onboarding';
        if (!isAuthenticated) return '/auth/login';
        return '/home';
      }

      if (!onboardingSeen) {
        return isOnOnboarding ? null : '/onboarding';
      }

      if (!isAuthenticated) {
        return isOnAuth ? null : '/auth/login';
      }

      if (isAuthenticated && (isOnAuth || isOnSplash || isOnOnboarding)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: 'children',
            name: RouteNames.children,
            builder: (_, __) => const ChildrenPage(),
          ),
          GoRoute(
            path: 'children/add',
            name: RouteNames.addChild,
            builder: (_, __) => const ChildFormPage(),
          ),
          GoRoute(
            path: 'children/:childId/edit',
            name: RouteNames.editChild,
            builder: (_, state) => ChildFormPage(
              existing: state.extra as Child?,
            ),
          ),
          GoRoute(
            path: 'children/:childId/dashboard',
            name: RouteNames.childDashboard,
            builder: (_, state) => ChildDashboardPage(
              childId: state.pathParameters['childId']!,
            ),
          ),
          GoRoute(
            path: 'activity',
            name: RouteNames.activity,
            builder: (_, state) => ActivityPage(
              extra: state.extra as Map<String, dynamic>? ?? {},
            ),
          ),
          GoRoute(
            path: 'progress',
            name: RouteNames.progress,
            builder: (_, state) => ProgressPage(
              childId: state.uri.queryParameters['childId'] ?? '',
            ),
          ),
          GoRoute(
            path: 'settings',
            name: RouteNames.settings,
            builder: (_, __) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => _ErrorPage(error: state.error),
  );
}

// ── Error page ───────────────────────────────────────────────────────────────

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});
  final Exception? error;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Text('Error: ${error?.toString()}')),
      );
}
