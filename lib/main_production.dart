import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/environment.dart';
import 'core/services/crash_reporter.dart';
import 'core/services/logger.dart';

/// Entry point for the Production flavor (`--flavor production`).
Future<void> main() async {
  AppConfig.initializeFlavor(AppFlavor.production);

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await configureDependencies();

    final crashReporter = getIt<CrashReporter>();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      crashReporter.recordError(
        details.exception,
        details.stack,
        reason: details.context?.toString(),
        fatal: false,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      crashReporter.recordError(error, stack, fatal: true);
      AppLogger.error('Platform unhandled error', error, stack);
      return true;
    };

    runApp(const NovaApp());
  }, (error, stack) {
    AppLogger.error('Zoned unhandled error', error, stack);
  });
}
