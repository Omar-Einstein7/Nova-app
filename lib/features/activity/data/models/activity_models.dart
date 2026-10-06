import '../../domain/entities/activity.dart';

// ── Question model ──────────────────────────────────────────────────────────

class QuestionModel extends Question {
  const QuestionModel({
    required super.index,
    required super.question,
    required super.emoji,
    required super.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        index: (json['index'] as num).toInt(),
        question: json['question'] as String,
        emoji: json['emoji'] as String? ?? '❓',
        options: (json['options'] as List<dynamic>).cast<String>(),
      );
}

// ── ActivityFeedback model ──────────────────────────────────────────────────

class ActivityFeedbackModel extends ActivityFeedback {
  const ActivityFeedbackModel({
    required super.onCorrect,
    required super.onIncorrect,
  });

  factory ActivityFeedbackModel.fromJson(Map<String, dynamic> json) =>
      ActivityFeedbackModel(
        onCorrect: json['onCorrect'] as String? ?? 'أحسنت! 🌟',
        onIncorrect: json['onIncorrect'] as String? ?? 'حاول مرة أخرى 💙',
      );
}

// ── Activity model ──────────────────────────────────────────────────────────

class ActivityModel extends Activity {
  const ActivityModel({
    required super.id,
    required super.skillId,
    required super.difficulty,
    required super.title,
    required super.description,
    required super.questions,
    required super.feedback,
    required super.source,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json['id'] as String,
        skillId: json['skillId'] as String,
        difficulty: json['difficulty'] as String? ?? 'BEGINNER',
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        questions: (json['questions'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(QuestionModel.fromJson)
            .toList(),
        feedback: ActivityFeedbackModel.fromJson(
          json['feedback'] as Map<String, dynamic>? ?? {},
        ),
        source: json['source'] as String? ?? 'AI',
      );
}

// ── ActivitySession model ───────────────────────────────────────────────────

class ActivitySessionModel extends ActivitySession {
  const ActivitySessionModel({
    required super.sessionId,
    required super.startedAt,
  });

  factory ActivitySessionModel.fromJson(Map<String, dynamic> json) =>
      ActivitySessionModel(
        sessionId: json['sessionId'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
      );
}

// ── AnswerResult model ──────────────────────────────────────────────────────

class AnswerResultModel extends AnswerResult {
  const AnswerResultModel({
    required super.isCorrect,
    required super.feedback,
    required super.attemptNo,
  });

  factory AnswerResultModel.fromJson(Map<String, dynamic> json) =>
      AnswerResultModel(
        isCorrect: json['isCorrect'] as bool,
        feedback: json['feedback'] as String? ?? '',
        attemptNo: (json['attemptNo'] as num).toInt(),
      );
}

// ── LevelChange model ───────────────────────────────────────────────────────

class LevelChangeModel extends LevelChange {
  const LevelChangeModel({
    required super.skillId,
    required super.from,
    required super.to,
  });

  factory LevelChangeModel.fromJson(Map<String, dynamic> json) =>
      LevelChangeModel(
        skillId: json['skillId'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
      );
}

// ── NextRecommendation model ────────────────────────────────────────────────

class NextRecommendationModel extends NextRecommendation {
  const NextRecommendationModel({
    required super.skillId,
    required super.difficulty,
    required super.reason,
    required super.suggestBreak,
  });

  factory NextRecommendationModel.fromJson(Map<String, dynamic> json) =>
      NextRecommendationModel(
        skillId: json['skillId'] as String,
        difficulty: json['difficulty'] as String,
        reason: json['reason'] as String? ?? '',
        suggestBreak: json['suggestBreak'] as bool? ?? false,
      );
}

// ── SessionResult model ─────────────────────────────────────────────────────

class SessionResultModel extends SessionResult {
  const SessionResultModel({
    required super.score,
    required super.successRate,
    required super.stars,
    super.levelChange,
    super.recommendation,
  });

  factory SessionResultModel.fromJson(Map<String, dynamic> json) {
    final lcJson = json['levelChange'] as Map<String, dynamic>?;
    final recJson = json['recommendation'] as Map<String, dynamic>?;
    return SessionResultModel(
      score: (json['score'] as num).toInt(),
      successRate: (json['successRate'] as num).toDouble(),
      stars: (json['stars'] as num).toInt(),
      levelChange: lcJson != null ? LevelChangeModel.fromJson(lcJson) : null,
      recommendation:
          recJson != null ? NextRecommendationModel.fromJson(recJson) : null,
    );
  }
}
