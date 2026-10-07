import 'dart:async';
import 'package:flutter/foundation.dart';

/// Abstract interface for app crash and error reporting.
/// In production, this can be backed by Sentry, Firebase Crashlytics, or Datadog.
/// [PLACEHOLDER: Implement SentryCrashReporter or FirebaseCrashlyticsReporter]
abstract interface class CrashReporter {
  Future<void> initialize();
  void log(String message);
  void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  });
  void setUserIdentifier(String? userId);
}

/// Default no-op crash reporter used when no third-party SDK is configured.
final class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  Future<void> initialize() async {}

  @override
  void log(String message) {}

  @override
  void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) {}

  @override
  void setUserIdentifier(String? userId) {}
}

/// Debug crash reporter that outputs to console during development.
final class ConsoleCrashReporter implements CrashReporter {
  const ConsoleCrashReporter();

  @override
  Future<void> initialize() async {
    debugPrint('[CrashReporter] Initialized ConsoleCrashReporter');
  }

  @override
  void log(String message) {
    debugPrint('[CrashReporter LOG] $message');
  }

  @override
  void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) {
    debugPrint(
      '[CrashReporter ERROR] fatal=$fatal, reason=$reason, exception=$exception',
    );
    if (stackTrace != null) {
      debugPrint('[CrashReporter STACK] $stackTrace');
    }
  }

  @override
  void setUserIdentifier(String? userId) {
    debugPrint('[CrashReporter USER] $userId');
  }
}
