import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection.dart';
import '../storage/prefs.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

/// Centralized motion helper for NOVA.
/// Enforces sensory safety guidelines for children on the autism spectrum:
/// - Never faster than 1 cycle per 2 seconds (minCycleDuration >= 2000ms).
/// - No opacity blinking or strobing.
/// - Fully disables animations when [reduceMotion] is enabled (via system or app settings).
final class NovaMotion {
  NovaMotion._();

  /// Minimum allowed duration for looping animations (2.5 seconds = 0.4 Hz).
  /// Hard constraint: NEVER faster than 1 cycle per 2 seconds.
  static const Duration minCycleDuration = Duration(milliseconds: 2500);

  /// Safe transition duration for state changes.
  static const Duration standardTransition = Duration(milliseconds: 350);

  /// Determines whether motion should be reduced, checking both the OS
  /// accessibility setting and NOVA in-app settings.
  static bool shouldReduceMotion(BuildContext context) {
    final systemDisabled =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    bool userSetting = false;

    try {
      final settings = context.read<SettingsCubit?>()?.state;
      if (settings != null) {
        userSetting = settings.reduceMotion;
      } else if (getIt.isRegistered<Prefs>()) {
        userSetting = getIt<Prefs>().reduceMotion;
      }
    } catch (_) {
      if (getIt.isRegistered<Prefs>()) {
        userSetting = getIt<Prefs>().reduceMotion;
      }
    }

    return systemDisabled || userSetting;
  }

  /// Returns the appropriate duration given the motion preference.
  /// If reduceMotion is active, returns [Duration.zero] or a minimal transition.
  static Duration duration(
    BuildContext context, {
    Duration normal = standardTransition,
  }) {
    return shouldReduceMotion(context) ? Duration.zero : normal;
  }

  /// Safe curve that softens motion.
  static Curve curve(BuildContext context, {Curve normal = Curves.easeInOut}) {
    return shouldReduceMotion(context) ? Curves.linear : normal;
  }
}
