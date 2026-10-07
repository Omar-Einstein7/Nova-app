/// App environment and flavor configuration for NOVA.
enum AppFlavor {
  dev,
  prod,
}

/// Centralized configuration parsed from `--dart-define` parameters.
final class AppConfig {
  AppConfig._();

  /// Build-time environment flavor: 'dev' or 'prod'.
  /// Defaults to 'dev'.
  static const String flavorName = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get flavor =>
      flavorName.toLowerCase() == 'prod' ? AppFlavor.prod : AppFlavor.dev;

  static bool get isDev => flavor == AppFlavor.dev;
  static bool get isProd => flavor == AppFlavor.prod;

  // ── [PLACEHOLDER: Flavor-specific Bundle IDs & Base URLs] ───────────────
  // Dev:  bundle id: "com.nova.app.dev", api: "http://10.0.2.2:3000/api/v1" or local IP
  // Prod: bundle id: "com.nova.app",     api: "https://api.nova-learn.com/api/v1"

  static const String _defaultDevBaseUrl = 'http://192.168.1.6:3000/api/v1';
  static const String _defaultProdBaseUrl = 'https://api.nova-learn.com/api/v1';

  /// Primary backend API base URL passed via `--dart-define=BASE_URL=...`.
  /// Falls back to flavor-specific defaults if not provided.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: String.fromEnvironment(
      // Legacy fallback support for previously hardcoded dart-define key
      'http://192.168.1.6:3000/api/v1',
      defaultValue:
          flavorName == 'prod' ? _defaultProdBaseUrl : _defaultDevBaseUrl,
    ),
  );

  /// Mock data source flag via `--dart-define=USE_MOCK=true`.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
  );

  /// Application identifier placeholder per flavor.
  static String get applicationId => switch (flavor) {
        AppFlavor.dev =>
          'com.nova.app.dev', // [PLACEHOLDER: Dev Android/iOS bundle id]
        AppFlavor.prod =>
          'com.nova.app', // [PLACEHOLDER: Prod Android/iOS bundle id]
      };

  /// Application display name per flavor.
  static String get appName => switch (flavor) {
        AppFlavor.dev => 'نوفا (تجريبي)',
        AppFlavor.prod => 'نوفا',
      };
}
