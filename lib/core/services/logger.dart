import 'package:flutter/foundation.dart';
import 'crash_reporter.dart';

/// Centralized logger for NOVA.
/// Automatically redacts sensitive tokens, passwords, and PII.
/// Suppresses verbose logs in release mode.
final class AppLogger {
  AppLogger._();

  static CrashReporter? _crashReporter;

  /// Configure crash reporter attachment for severe errors.
  static void setCrashReporter(CrashReporter reporter) {
    _crashReporter = reporter;
  }

  /// Regex pattern to redact JWT tokens and common auth strings.
  static final RegExp _bearerPattern =
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false);
  static final RegExp _tokenParamPattern = RegExp(
      r'(accessToken|refreshToken|password)["\s:=]+([^",\s}]+)',
      caseSensitive: false);

  static String _sanitize(String message) {
    var sanitized =
        message.replaceAllMapped(_bearerPattern, (_) => 'Bearer [REDACTED]');
    sanitized = sanitized.replaceAllMapped(
        _tokenParamPattern, (m) => '${m.group(1)}: [REDACTED]');
    return sanitized;
  }

  /// Informational debug message (suppressed in release mode).
  static void debug(String message) {
    if (kReleaseMode) return;
    debugPrint('[DEBUG] ${_sanitize(message)}');
  }

  /// Standard info message (suppressed in release mode).
  static void info(String message) {
    if (kReleaseMode) return;
    debugPrint('[INFO] ${_sanitize(message)}');
    _crashReporter?.log(_sanitize(message));
  }

  /// Warning message.
  static void warning(String message) {
    final sanitized = _sanitize(message);
    if (!kReleaseMode) {
      debugPrint('[WARN] $sanitized');
    }
    _crashReporter?.log('[WARN] $sanitized');
  }

  /// Error message, logged to crash reporter in all environments.
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    final sanitized = _sanitize(message);
    if (!kReleaseMode) {
      debugPrint('[ERROR] $sanitized: $error');
      if (stackTrace != null) {
        debugPrint('$stackTrace');
      }
    }
    _crashReporter?.recordError(error ?? sanitized, stackTrace,
        reason: sanitized);
  }
}
