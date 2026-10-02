import "package:shared_preferences/shared_preferences.dart";

/// App-wide user preferences (non-sensitive).
class Prefs {
  Prefs(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingSeen = "nova.onboarding_seen";
  static const _kSoundOn = "nova.sound_on";
  static const _kTtsOn = "nova.tts_on";
  static const _kReduceMotion = "nova.reduce_motion";
  static const _kFontScale = "nova.font_scale";

  bool get onboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen(bool v) =>
      _prefs.setBool(_kOnboardingSeen, v);

  bool get soundOn => _prefs.getBool(_kSoundOn) ?? true;
  Future<void> setSoundOn(bool v) => _prefs.setBool(_kSoundOn, v);

  bool get ttsOn => _prefs.getBool(_kTtsOn) ?? true;
  Future<void> setTtsOn(bool v) => _prefs.setBool(_kTtsOn, v);

  bool get reduceMotion => _prefs.getBool(_kReduceMotion) ?? false;
  Future<void> setReduceMotion(bool v) => _prefs.setBool(_kReduceMotion, v);

  /// Font scale: 0.9 | 1.0 | 1.2
  double get fontScale => _prefs.getDouble(_kFontScale) ?? 1.0;
  Future<void> setFontScale(double v) => _prefs.setDouble(_kFontScale, v);
}

