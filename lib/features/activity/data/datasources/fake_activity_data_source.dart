import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../models/activity_models.dart';

/// Fake data source for USE_MOCK=true builds.
/// Simulates realistic Arabic content and validates answers locally.
/// IMPORTANT: isCorrect is determined locally here ONLY in this fake source.
/// The real source never knows the correct answer.
class FakeActivityDataSource {
  static const _kDelay = Duration(seconds: 2);

  static const _fakeActivities = [
    {
      'id': 'fake-activity-1',
      'skillId': 'skill-1',
      'difficulty': 'BEGINNER',
      'title': 'نشاط: التعرف على الأشكال',
      'description': 'دعنا نتعرف على الأشكال الهندسية المختلفة!',
      'source': 'FALLBACK',
      'feedback': {
        'onCorrect': 'ممتاز! أنت ذكي جداً 🌟',
        'onIncorrect': 'حاول مرة أخرى، أنت تستطيع 💙',
      },
      'questions': [
        {
          'index': 0,
          'question': 'أي شكل هو الدائرة؟',
          'emoji': '🔵',
          'options': ['مربع', 'دائرة', 'مثلث'],
          '_correct': 'دائرة',
        },
        {
          'index': 1,
          'question': 'ما الشكل الذي له أربعة أضلاع متساوية؟',
          'emoji': '🟥',
          'options': ['مثلث', 'دائرة', 'مربع'],
          '_correct': 'مربع',
        },
        {
          'index': 2,
          'question': 'كم عدد أضلاع المثلث؟',
          'emoji': '📐',
          'options': ['٢', '٣', '٤'],
          '_correct': '٣',
        },
      ],
    },
    {
      'id': 'fake-activity-2',
      'skillId': 'skill-2',
      'difficulty': 'BEGINNER',
      'title': 'نشاط: عالم الألوان',
      'description': 'هيا نتعلم الألوان الجميلة معاً!',
      'source': 'AI',
      'feedback': {
        'onCorrect': 'رائع! أنت تعرف الألوان جيداً 🎨',
        'onIncorrect': 'لا بأس، الألوان كثيرة! حاول مرة أخرى 🌈',
      },
      'questions': [
        {
          'index': 0,
          'question': 'ما لون السماء في النهار؟',
          'emoji': '☀️',
          'options': ['أحمر', 'أزرق', 'أخضر'],
          '_correct': 'أزرق',
        },
        {
          'index': 1,
          'question': 'ما لون العشب؟',
          'emoji': '🌿',
          'options': ['أصفر', 'بنفسجي', 'أخضر'],
          '_correct': 'أخضر',
        },
        {
          'index': 2,
          'question': 'ما لون الشمس؟',
          'emoji': '🌞',
          'options': ['أصفر', 'أزرق', 'وردي'],
          '_correct': 'أصفر',
        },
      ],
    },
  ];

  static int _activityIndex = 0;
  static int _sessionCounter = 0;

  // Store correct answers for current activity
  static Map<int, String> _correctAnswers = {};

  Future<Either<Failure, ActivityModel>> generate(
    String childId, {
    String? skillId,
    String? difficulty,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    final raw = Map<String, dynamic>.from(
      _fakeActivities[_activityIndex % _fakeActivities.length]
          as Map<String, dynamic>,
    );
    _activityIndex++;

    // Extract and store correct answers, then strip from model
    _correctAnswers = {};
    final rawQuestions = raw['questions'] as List<dynamic>;
    final cleanQuestions = rawQuestions.map((q) {
      final qMap = Map<String, dynamic>.from(q as Map<String, dynamic>);
      final idx = (qMap['index'] as num).toInt();
      _correctAnswers[idx] = qMap.remove('_correct') as String;
      return qMap;
    }).toList();

    raw['questions'] = cleanQuestions;
    return Right(ActivityModel.fromJson(raw));
  }

  Future<Either<Failure, ActivitySessionModel>> startSession(
      String activityId) async {
    await Future<void>.delayed(_kDelay);
    _sessionCounter++;
    return Right(
      ActivitySessionModel(
        sessionId: 'fake-session-$_sessionCounter',
        startedAt: DateTime.now(),
      ),
    );
  }

  Future<Either<Failure, AnswerResultModel>> submitAnswer(
    String sessionId, {
    required int questionIndex,
    required String selectedAnswer,
    required int timeMs,
    required bool usedHelp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final correct = _correctAnswers[questionIndex] ?? '';
    final isCorrect = selectedAnswer == correct;
    return Right(
      AnswerResultModel(
        isCorrect: isCorrect,
        feedback: isCorrect ? 'أحسنت! إجابة صحيحة 🌟' : 'حاول مرة أخرى 💙',
        attemptNo: 1,
      ),
    );
  }

  Future<Either<Failure, SessionResultModel>> completeSession(
    String sessionId, {
    required int durationMs,
  }) async {
    await Future<void>.delayed(_kDelay);
    return Right(
      SessionResultModel(
        score: 80,
        successRate: 0.8,
        stars: 3,
        recommendation: const NextRecommendationModel(
          skillId: 'skill-1',
          difficulty: 'INTERMEDIATE',
          reason: 'أداء ممتاز! جاهز للمستوى التالي.',
          suggestBreak: false,
        ),
      ),
    );
  }
}
