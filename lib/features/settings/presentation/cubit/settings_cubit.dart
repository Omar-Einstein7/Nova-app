import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/prefs.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class SettingsState extends Equatable {
  const SettingsState({
    this.soundOn = true,
    this.ttsOn = true,
    this.reduceMotion = false,
    this.fontScale = 1.0,
  });

  final bool soundOn;
  final bool ttsOn;
  final bool reduceMotion;
  final double fontScale;

  SettingsState copyWith({
    bool? soundOn,
    bool? ttsOn,
    bool? reduceMotion,
    double? fontScale,
  }) =>
      SettingsState(
        soundOn: soundOn ?? this.soundOn,
        ttsOn: ttsOn ?? this.ttsOn,
        reduceMotion: reduceMotion ?? this.reduceMotion,
        fontScale: fontScale ?? this.fontScale,
      );

  @override
  List<Object?> get props => [soundOn, ttsOn, reduceMotion, fontScale];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// App-scoped cubit for user preferences persisted in [Prefs].
/// Changes here propagate immediately to the player and theme.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required Prefs prefs})
      : _prefs = prefs,
        super(SettingsState(
          soundOn: prefs.soundOn,
          ttsOn: prefs.ttsOn,
          reduceMotion: prefs.reduceMotion,
          fontScale: prefs.fontScale,
        ));

  final Prefs _prefs;

  Future<void> setSoundOn(bool value) async {
    await _prefs.setSoundOn(value);
    emit(state.copyWith(soundOn: value));
  }

  Future<void> setTtsOn(bool value) async {
    await _prefs.setTtsOn(value);
    emit(state.copyWith(ttsOn: value));
  }

  Future<void> setReduceMotion(bool value) async {
    await _prefs.setReduceMotion(value);
    emit(state.copyWith(reduceMotion: value));
  }

  /// Font scale levels: 0.9 (صغير), 1.0 (عادي), 1.2 (كبير)
  static const List<double> fontScaleLevels = [0.9, 1.0, 1.2];

  Future<void> setFontScale(double value) async {
    assert(fontScaleLevels.contains(value));
    await _prefs.setFontScale(value);
    emit(state.copyWith(fontScale: value));
  }
}
