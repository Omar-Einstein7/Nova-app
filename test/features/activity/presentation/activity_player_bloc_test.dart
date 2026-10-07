import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/features/activity/domain/entities/activity.dart';
import 'package:nova/features/activity/domain/usecases/activity_use_cases.dart';
import 'package:nova/features/activity/presentation/bloc/activity_player_bloc.dart';
import 'package:nova/features/activity/presentation/bloc/activity_player_event.dart';
import 'package:nova/features/activity/presentation/bloc/activity_player_state.dart';

class _MockGenerateActivityUseCase extends Mock
    implements GenerateActivityUseCase {}

class _MockStartSessionUseCase extends Mock implements StartSessionUseCase {}

class _MockSubmitAnswerUseCase extends Mock implements SubmitAnswerUseCase {}

class _MockCompleteSessionUseCase extends Mock
    implements CompleteSessionUseCase {}

const _tQuestion1 = Question(
  index: 0,
  question: 'أي حيوان يقول مواء؟',
  emoji: '🐱',
  options: ['القطة', 'الكلب', 'البطة'],
);

const _tQuestion2 = Question(
  index: 1,
  question: 'أي حيوان يقول هو هو؟',
  emoji: '🐶',
  options: ['الكلب', 'القطة', 'البقرة'],
);

const _tFeedback = ActivityFeedback(
  onCorrect: 'أحسنت! إجابة رائعة 🌟',
  onIncorrect: 'محاولة حلوة، جرّب مرة ثانية 💙',
);

const _tActivity = Activity(
  id: 'act-1',
  skillId: 'communication',
  difficulty: 'BEGINNER',
  title: 'أصوات الحيوانات',
  description: 'تعرف على أصوات الحيوانات الأليفة',
  questions: [_tQuestion1, _tQuestion2],
  feedback: _tFeedback,
  source: 'AI',
);

final _tSession = ActivitySession(
  sessionId: 'sess-1',
  startedAt: DateTime(2026, 1, 1),
);

const _tAnswerResultCorrect = AnswerResult(
  isCorrect: true,
  feedback: 'أحسنت!',
  attemptNo: 1,
);

const _tSessionResult = SessionResult(
  score: 100,
  successRate: 1.0,
  stars: 3,
  recommendation: NextRecommendation(
    skillId: 'communication',
    difficulty: 'BEGINNER',
    reason: 'أداء ممتاز',
    suggestBreak: false,
  ),
);

void main() {
  late _MockGenerateActivityUseCase mockGenerate;
  late _MockStartSessionUseCase mockStartSession;
  late _MockSubmitAnswerUseCase mockSubmitAnswer;
  late _MockCompleteSessionUseCase mockCompleteSession;

  setUp(() {
    mockGenerate = _MockGenerateActivityUseCase();
    mockStartSession = _MockStartSessionUseCase();
    mockSubmitAnswer = _MockSubmitAnswerUseCase();
    mockCompleteSession = _MockCompleteSessionUseCase();
  });

  ActivityPlayerBloc buildBloc() => ActivityPlayerBloc(
        generateActivity: mockGenerate,
        startSession: mockStartSession,
        submitAnswer: mockSubmitAnswer,
        completeSession: mockCompleteSession,
      );

  group('ActivityPlayerBloc', () {
    test('initial state is ActivityPlayerIdle', () {
      expect(buildBloc().state, const ActivityPlayerIdle());
    });

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityStartRequested emits [Generating, Intro] on success',
      setUp: () {
        when(() => mockGenerate(
              'child-1',
              skillId: any(named: 'skillId'),
              difficulty: any(named: 'difficulty'),
            )).thenAnswer((_) async => const Right(_tActivity));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ActivityStartRequested(childId: 'child-1')),
      expect: () => [
        const ActivityPlayerGenerating(),
        const ActivityPlayerIntro(_tActivity),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityStartRequested emits [Generating, Error] on failure',
      setUp: () {
        when(() => mockGenerate(
              'child-1',
              skillId: any(named: 'skillId'),
              difficulty: any(named: 'difficulty'),
            )).thenAnswer(
          (_) async => const Left(
              ServerFailure(code: 'INTERNAL', message: 'Error generating')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ActivityStartRequested(childId: 'child-1')),
      expect: () => [
        const ActivityPlayerGenerating(),
        isA<ActivityPlayerError>(),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityIntroConfirmed emits [StartingSession, QuestionActive] on success',
      setUp: () {
        when(() => mockStartSession('act-1'))
            .thenAnswer((_) async => Right(_tSession));
      },
      build: buildBloc,
      seed: () => const ActivityPlayerIntro(_tActivity),
      act: (bloc) => bloc.add(const ActivityIntroConfirmed()),
      expect: () => [
        const ActivityPlayerStartingSession(_tActivity),
        isA<ActivityPlayerQuestionActive>()
            .having((s) => s.questionIndex, 'questionIndex', 0)
            .having((s) => s.sessionId, 'sessionId', 'sess-1'),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityAnswerSelected emits [Submitting, AnswerFeedback] with isCorrect=true',
      setUp: () {
        when(() => mockSubmitAnswer(
              'sess-1',
              questionIndex: 0,
              selectedAnswer: 'القطة',
              timeMs: any(named: 'timeMs'),
              usedHelp: false,
            )).thenAnswer((_) async => const Right(_tAnswerResultCorrect));
      },
      build: buildBloc,
      seed: () => ActivityPlayerQuestionActive(
        activity: _tActivity,
        sessionId: 'sess-1',
        questionIndex: 0,
        sessionStartMs: 1000,
        questionStartMs: 2000,
      ),
      act: (bloc) => bloc.add(const ActivityAnswerSelected('القطة')),
      expect: () => [
        isA<ActivityPlayerSubmitting>(),
        isA<ActivityPlayerAnswerFeedback>()
            .having((s) => s.isCorrect, 'isCorrect', true)
            .having((s) => s.selectedAnswer, 'selectedAnswer', 'القطة'),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityNextQuestion advances to question index 1 when not at end',
      build: buildBloc,
      seed: () => const ActivityPlayerAnswerFeedback(
        activity: _tActivity,
        sessionId: 'sess-1',
        questionIndex: 0,
        sessionStartMs: 1000,
        isCorrect: true,
        feedbackText: 'أحسنت!',
        selectedAnswer: 'القطة',
        attemptNo: 1,
        isMaxAttempts: false,
      ),
      act: (bloc) => bloc.add(const ActivityNextQuestion()),
      expect: () => [
        isA<ActivityPlayerQuestionActive>()
            .having((s) => s.questionIndex, 'questionIndex', 1),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'ActivityNextQuestion completes session on the last question',
      setUp: () {
        when(() => mockCompleteSession(
              'sess-1',
              durationMs: any(named: 'durationMs'),
            )).thenAnswer((_) async => const Right(_tSessionResult));
      },
      build: buildBloc,
      seed: () => const ActivityPlayerAnswerFeedback(
        activity: _tActivity,
        sessionId: 'sess-1',
        questionIndex: 1, // last question of 2
        sessionStartMs: 1000,
        isCorrect: true,
        feedbackText: 'أحسنت!',
        selectedAnswer: 'الكلب',
        attemptNo: 1,
        isMaxAttempts: false,
      ),
      act: (bloc) => bloc.add(const ActivityNextQuestion()),
      expect: () => [
        isA<ActivityPlayerCompleting>(),
        isA<ActivityPlayerResult>().having((s) => s.result.stars, 'stars', 3),
      ],
    );

    blocTest<ActivityPlayerBloc, ActivityPlayerState>(
      'retryCurrentQuestion resets to question active state on incorrect answer',
      build: buildBloc,
      seed: () => const ActivityPlayerAnswerFeedback(
        activity: _tActivity,
        sessionId: 'sess-1',
        questionIndex: 0,
        sessionStartMs: 1000,
        isCorrect: false,
        feedbackText: 'محاولة حلوة',
        selectedAnswer: 'البطة',
        attemptNo: 1,
        isMaxAttempts: false,
      ),
      act: (bloc) => bloc.retryCurrentQuestion(),
      expect: () => [
        isA<ActivityPlayerQuestionActive>()
            .having((s) => s.attemptNo, 'attemptNo', 1),
      ],
    );
  });
}
