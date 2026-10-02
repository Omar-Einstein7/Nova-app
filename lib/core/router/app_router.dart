import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../features/auth/presentation/pages/login_page.dart";
import "../../features/auth/presentation/pages/register_page.dart";
import "../../features/home/presentation/pages/home_page.dart";
import "../../features/onboarding/presentation/pages/onboarding_page.dart";
import "../../features/children/presentation/pages/children_page.dart";
import "../../features/progress/presentation/pages/progress_page.dart";
import "../../features/settings/presentation/pages/settings_page.dart";
import "../../features/activity/presentation/pages/activity_page.dart";
import "../network/session_expired_event.dart";
import "../storage/prefs.dart";
import "../storage/secure_storage.dart";
import "route_names.dart";

/// Builds the [GoRouter] for the NOVA app.
/// Auth state is driven by whether a valid access token is present.
GoRouter buildRouter({
  required SecureStorage secureStorage,
  required Prefs prefs,
}) {
  final notifier = _AuthNotifier(secureStorage: secureStorage);

  // Listen for server-emitted "session expired" events and force a
  // re-evaluation of the redirect guard.
  SessionExpiredEvent.stream.listen((_) => notifier.notifyExpired());

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: "/splash",
    redirect: (context, state) async {
      final token = await secureStorage.getAccessToken();
      final isAuthenticated = token != null;
      final onboardingSeen = prefs.onboardingSeen;

      final location = state.uri.toString();
      final isOnAuth = location.startsWith("/auth");
      final isOnOnboarding = location.startsWith("/onboarding");
      final isOnSplash = location.startsWith("/splash");

      if (isOnSplash) {
        if (!onboardingSeen) return "/onboarding";
        if (!isAuthenticated) return "/auth/login";
        return "/home";
      }

      if (!onboardingSeen && !isOnOnboarding) return "/onboarding";
      if (!isAuthenticated && !isOnAuth) return "/auth/login";
      if (isAuthenticated && isOnAuth) return "/home";

      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        name: RouteNames.splash,
        builder: (_, __) => const _SplashPage(),
      ),
      GoRoute(
        path: "/onboarding",
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: "/auth/login",
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: "/auth/register",
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: "/home",
        name: RouteNames.home,
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: "children",
            name: RouteNames.children,
            builder: (_, __) => const ChildrenPage(),
          ),
          GoRoute(
            path: "activity",
            name: RouteNames.activity,
            builder: (_, state) => ActivityPage(
              extra: state.extra as Map<String, dynamic>? ?? {},
            ),
          ),
          GoRoute(
            path: "progress",
            name: RouteNames.progress,
            builder: (_, state) => ProgressPage(
              childId: state.uri.queryParameters["childId"] ?? "",
            ),
          ),
          GoRoute(
            path: "settings",
            name: RouteNames.settings,
            builder: (_, __) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => _ErrorPage(error: state.error),
  );
}

// ── Minimal pages only needed for routing ────────────────────────────────────

class _SplashPage extends StatelessWidget {
  const _SplashPage();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});
  final Exception? error;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Text("Error: ${error?.toString()}")),
      );
}

// ── Auth notifier (ChangeNotifier for GoRouter.refreshListenable) ────────────

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier({required this.secureStorage});
  final SecureStorage secureStorage;

  void notifyExpired() => notifyListeners();
}
