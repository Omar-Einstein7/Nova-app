import 'package:equatable/equatable.dart';

/// A single multiple-choice question inside an activity.
class Question extends Equatable {
  const Question({
    required this.index,
    required this.question,
    required this.emoji,
    required this.options,
  });

  final int index;
  final String question;
  final String emoji;
  final List<String> options;

  @override
  List<Object?> get props => [index, question, emoji, options];
}

/// Feedback strings returned by the backend per activity.
class ActivityFeedback extends Equatable {
  const ActivityFeedback({
    required this.onCorrect,
    required this.onIncorrect,
  });

  final String onCorrect;
  final String onIncorrect;

  @override
  List<Object?> get props => [onCorrect, onIncorrect];
}

/// Core activity entity returned by POST /children/:id/activities/generate.
class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.skillId,
    required this.difficulty,
    required this.title,
    required this.description,
    required this.questions,
    required this.feedback,
    required this.source,
  });

  final String id;
  final String skillId;
  final String difficulty;
  final String title;
  final String description;
  final List<Question> questions;
  final ActivityFeedback feedback;

  /// 'AI' or 'FALLBACK'
  final String source;

  @override
  List<Object?> get props => [
        id,
        skillId,
        difficulty,
        title,
        description,
        questions,
        feedback,
        source
      ];
}

/// A session started for an activity (POST /activities/:id/sessions).
class ActivitySession extends Equatable {
  const ActivitySession({
    required this.sessionId,
    required this.startedAt,
  });

  final String sessionId;
  final DateTime startedAt;

  @override
  List<Object?> get props => [sessionId, startedAt];
}

/// Result of submitting an answer (POST /sessions/:id/answers).
class AnswerResult extends Equatable {
  const AnswerResult({
    required this.isCorrect,
    required this.feedback,
    required this.attemptNo,
  });

  final bool isCorrect;
  final String feedback;
  final int attemptNo;

  @override
  List<Object?> get props => [isCorrect, feedback, attemptNo];
}

/// Optional next-activity recommendation included in session completion.
class NextRecommendation extends Equatable {
  const NextRecommendation({
    required this.skillId,
    required this.difficulty,
    required this.reason,
    required this.suggestBreak,
  });

  final String skillId;
  final String difficulty;
  final String reason;
  final bool suggestBreak;

  @override
  List<Object?> get props => [skillId, difficulty, reason, suggestBreak];
}

/// Level change info for a skill after session completion.
class LevelChange extends Equatable {
  const LevelChange({
    required this.skillId,
    required this.from,
    required this.to,
  });

  final String skillId;
  final String from;
  final String to;

  @override
  List<Object?> get props => [skillId, from, to];
}

/// Full result of POST /sessions/:id/complete.
class SessionResult extends Equatable {
  const SessionResult({
    required this.score,
    required this.successRate,
    required this.stars,
    this.levelChange,
    this.recommendation,
  });

  final int score;
  final double successRate;

  /// 1–3
  final int stars;
  final LevelChange? levelChange;
  final NextRecommendation? recommendation;

  @override
  List<Object?> get props =>
      [score, successRate, stars, levelChange, recommendation];
}
