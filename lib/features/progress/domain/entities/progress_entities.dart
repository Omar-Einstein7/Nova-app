import 'package:equatable/equatable.dart';

/// Overview stats for a child's progress over a date range.
class ProgressOverview extends Equatable {
  const ProgressOverview({
    required this.range,
    required this.sessionsCount,
    required this.avgSuccessRate,
    required this.totalMinutes,
    required this.streakDays,
    required this.bySkill,
  });

  final String range;
  final int sessionsCount;
  final double avgSuccessRate;
  final int totalMinutes;
  final int streakDays;
  final List<SkillProgress> bySkill;

  @override
  List<Object?> get props =>
      [range, sessionsCount, avgSuccessRate, totalMinutes, streakDays, bySkill];
}

/// Per-skill summary inside [ProgressOverview].
class SkillProgress extends Equatable {
  const SkillProgress({
    required this.skillId,
    required this.key,
    required this.nameAr,
    required this.avgSuccessRate,
    required this.sessions,
    required this.level,
  });

  final String skillId;
  final String key;
  final String nameAr;
  final double avgSuccessRate;
  final int sessions;
  final String level; // BEGINNER | INTERMEDIATE | ADVANCED

  @override
  List<Object?> get props =>
      [skillId, key, nameAr, avgSuccessRate, sessions, level];
}

/// A single time-series data point for a skill's line chart.
class SkillChartPoint extends Equatable {
  const SkillChartPoint({required this.date, required this.avgSuccessRate});

  final DateTime date;
  final double avgSuccessRate;

  @override
  List<Object?> get props => [date, avgSuccessRate];
}

/// A single session entry in the sessions history list.
class SessionSummary extends Equatable {
  const SessionSummary({
    required this.id,
    required this.activityTitle,
    required this.skillKey,
    required this.startedAt,
    required this.durationMs,
    required this.successRate,
    required this.stars,
    required this.status,
  });

  final String id;
  final String activityTitle;
  final String skillKey;
  final DateTime startedAt;
  final int durationMs;
  final double successRate;
  final int stars;
  final String status;

  @override
  List<Object?> get props => [
        id,
        activityTitle,
        skillKey,
        startedAt,
        durationMs,
        successRate,
        stars,
        status
      ];
}
