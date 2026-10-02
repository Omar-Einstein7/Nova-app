import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storage/prefs.dart';

/// Simple cubit for the onboarding page indicator and completion.
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit({required Prefs prefs})
      : _prefs = prefs,
        super(0);

  final Prefs _prefs;

  void goToPage(int page) => emit(page);

  /// Persists the onboarding-seen flag.  Called before navigating away.
  Future<void> complete() => _prefs.setOnboardingSeen(true);
}
