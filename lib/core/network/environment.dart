/// App environment and flavor configuration for NOVA.
enum AppFlavor {
  development,
  production;

  /// Alias for backward compatibility
  static AppFlavor get dev => AppFlavor.development;
  static AppFlavor get prod => AppFlavor.production;
}

/// Centralized configuration supporting both entry-point initialization
/// and build-time `--dart-define` parameters.
final class AppConfig {
  AppConfig._();

  static AppFlavor _activeFlavor = _resolveFlavorFromEnvironment();

  static AppFlavor _resolveFlavorFromEnvironment() {
    const fromEnv = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'development',
    );
    final lower = fromEnv.toLowerCase();
    if (lower == 'prod' || lower == 'production') {
      return AppFlavor.production;
    }
    return AppFlavor.development;
  }

  /// Explicitly set the active flavor from entry points (e.g. main_development.dart).
  static void initializeFlavor(AppFlavor flavor) {
    _activeFlavor = flavor;
  }

  static AppFlavor get flavor => _activeFlavor;

  static bool get isDev => flavor == AppFlavor.development;
  static bool get isProd => flavor == AppFlavor.production;

  static const String _defaultDevBaseUrl = 'http://192.168.1.6:3000/api/v1';
  static const String _defaultProdBaseUrl = 'https://api.nova-learn.com/api/v1';

  /// Primary backend API base URL.
  /// Precedence: `--dart-define=BASE_URL` -> flavor default URL.
  static String get baseUrl {
    const envUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;

    const legacyUrl = String.fromEnvironment(
      'http://192.168.1.6:3000/api/v1',
      defaultValue: '',
    );
    if (legacyUrl.isNotEmpty) return legacyUrl;

    return isProd ? _defaultProdBaseUrl : _defaultDevBaseUrl;
  }

  /// Mock data source flag via `--dart-define=USE_MOCK=true`.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
  );

  /// Application identifier placeholder per flavor.
  static String get applicationId => switch (flavor) {
        AppFlavor.development => 'com.nova.app.dev',
        AppFlavor.production => 'com.nova.app',
      };

  /// Application display name per flavor.
  static String get appName => switch (flavor) {
        AppFlavor.development => 'Nova dev',
        AppFlavor.production => 'Nova',
      };
}
