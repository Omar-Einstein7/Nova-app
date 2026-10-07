import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

import 'logger.dart';

/// Abstract TTS interface for speech synthesis.
abstract interface class TtsService {
  Future<void> speak(String text);
  Future<void> stop();
  void dispose();
}

/// Production implementation of [TtsService] using [FlutterTts].
class FlutterTtsService implements TtsService {
  FlutterTtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _init();
  }

  final FlutterTts _tts;
  bool _isInitialized = false;

  Future<void> _init() async {
    try {
      await _tts.setLanguage('ar');
      // Calm, slower pacing for children with autism
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      _isInitialized = true;
    } catch (e) {
      AppLogger.warning('TTS initialization failed: $e');
    }
  }

  @override
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      if (!_isInitialized) {
        await _init();
      }
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      AppLogger.warning('TTS speak failed: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      AppLogger.warning('TTS stop failed: $e');
    }
  }

  @override
  void dispose() {
    _tts.stop();
  }
}

/// No-op implementation of [TtsService] for tests and unsupported platforms.
class NoOpTtsService implements TtsService {
  const NoOpTtsService();

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}

  @override
  void dispose() {}
}
