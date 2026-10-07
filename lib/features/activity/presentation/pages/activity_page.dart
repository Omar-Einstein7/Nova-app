import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/parent_gate_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activity_player_bloc.dart';
import '../bloc/activity_player_event.dart';
import '../bloc/activity_player_state.dart';
import '../widgets/activity_intro_view.dart';
import '../widgets/answer_feedback_view.dart';
import '../widgets/generating_view.dart';
import '../widgets/question_view.dart';
import '../widgets/result_view.dart';

/// Entry-point page for the activity feature.
/// Accepts [extra] map with:
///   - 'childId'    (required)
///   - 'skillId'    (optional)
///   - 'difficulty' (optional)
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.extra});
  final Map<String, dynamic> extra;

  @override
  Widget build(BuildContext context) {
    final childId = extra['childId'] as String?;
    if (childId == null || childId.isEmpty) {
      // Graceful restoration fallback if activity state was killed mid-flow
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎈', style: TextStyle(fontSize: 56)),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'لم نتمكن من استعادة النشاط السابق',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'يمكنك دائماً بدء نشاط جديد من لوحة الطفل.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('العودة للرئيسية'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) {
        final bloc = getIt<ActivityPlayerBloc>();
        bloc.add(ActivityStartRequested(
          childId: childId,
          skillId: extra['skillId'] as String?,
          difficulty: extra['difficulty'] as String?,
        ));
        return bloc;
      },
      child: const _ActivityPlayerView(),
    );
  }
}

class _ActivityPlayerView extends StatelessWidget {
  const _ActivityPlayerView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityPlayerBloc, ActivityPlayerState>(
      listenWhen: (_, current) => current is ActivityPlayerIdle,
      listener: (context, state) {
        if (state is ActivityPlayerIdle) {
          if (context.canPop()) context.pop();
        }
      },
      builder: (context, state) {
        Widget body;

        if (state is ActivityPlayerGenerating || state is ActivityPlayerIdle) {
          body = const GeneratingView();
        } else if (state is ActivityPlayerIntro) {
          body = ActivityIntroView(
            activity: state.activity,
            onStart: () => context
                .read<ActivityPlayerBloc>()
                .add(const ActivityIntroConfirmed()),
          );
        } else if (state is ActivityPlayerStartingSession) {
          body = const _LoadingView(message: 'جارٍ تجهيز الجلسة...');
        } else if (state is ActivityPlayerQuestionActive ||
            state is ActivityPlayerSubmitting ||
            state is ActivityPlayerAnswerFeedback) {
          body = _QuestionScreen(state: state);
        } else if (state is ActivityPlayerCompleting) {
          body = const _LoadingView(message: 'جارٍ حساب نتيجتك...');
        } else if (state is ActivityPlayerResult) {
          body = ResultView(
            result: state.result,
            onPlayAgain: () {
              context
                  .read<ActivityPlayerBloc>()
                  .add(const ActivityRetryRequested());
            },
            onGoHome: () {
              while (context.canPop()) {
                context.pop();
              }
            },
          );
        } else if (state is ActivityPlayerError) {
          body = _ErrorView(
            message: failureToArabicMessage(state.failure),
            onRetry: () => context
                .read<ActivityPlayerBloc>()
                .add(const ActivityRetryRequested()),
            onExit: () {
              if (context.canPop()) context.pop();
            },
          );
        } else {
          body = const GeneratingView();
        }

        // Child Mode Navigation Safety:
        // Back gesture on Android must pass Parent Gate so children cannot accidentally exit.
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (state is ActivityPlayerResult) {
              if (context.canPop()) context.pop();
            } else {
              _handleBack(context);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: body,
          ),
        );
      },
    );
  }

  void _handleBack(BuildContext context) async {
    final passed = await showParentGate(context);
    if (!passed) return;
    if (!context.mounted) return;

    final exit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خروج من النشاط', textAlign: TextAlign.center),
        content: const Text('تحب تكمل ولا تخرج؟', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('أكمل'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('اخرج'),
          ),
        ],
      ),
    );

    if (exit == true && context.mounted) {
      context.read<ActivityPlayerBloc>().add(const ActivityExitRequested());
    }
  }
}

// ── Question screen ───────────────────────────────────────────────────────────

class _QuestionScreen extends StatelessWidget {
  const _QuestionScreen({required this.state});
  final ActivityPlayerState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActivityPlayerBloc>();

    if (state is ActivityPlayerQuestionActive) {
      final s = state as ActivityPlayerQuestionActive;
      return _buildScaffold(
        context,
        bloc: bloc,
        activity: s.activity,
        questionIndex: s.questionIndex,
        selectedAnswer: null,
        isCorrect: null,
        isSubmitting: false,
        showFeedback: false,
        isMaxAttempts: false,
        isLastQuestion: s.isLastQuestion,
        feedbackText: '',
        attemptNo: s.attemptNo,
        sessionId: s.sessionId,
      );
    }

    if (state is ActivityPlayerSubmitting) {
      final s = state as ActivityPlayerSubmitting;
      return _buildScaffold(
        context,
        bloc: bloc,
        activity: s.activity,
        questionIndex: s.questionIndex,
        selectedAnswer: s.selectedAnswer,
        isCorrect: null,
        isSubmitting: true,
        showFeedback: false,
        isMaxAttempts: false,
        isLastQuestion: s.questionIndex >= s.activity.questions.length - 1,
        feedbackText: '',
        attemptNo: 0,
        sessionId: s.sessionId,
      );
    }

    if (state is ActivityPlayerAnswerFeedback) {
      final s = state as ActivityPlayerAnswerFeedback;
      return _buildScaffold(
        context,
        bloc: bloc,
        activity: s.activity,
        questionIndex: s.questionIndex,
        selectedAnswer: s.selectedAnswer,
        isCorrect: s.isCorrect,
        isSubmitting: false,
        showFeedback: true,
        isMaxAttempts: s.isMaxAttempts,
        isLastQuestion: s.isLastQuestion,
        feedbackText: s.feedbackText,
        attemptNo: s.attemptNo,
        sessionId: s.sessionId,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildScaffold(
    BuildContext context, {
    required ActivityPlayerBloc bloc,
    required Activity activity,
    required int questionIndex,
    required String? selectedAnswer,
    required bool? isCorrect,
    required bool isSubmitting,
    required bool showFeedback,
    required bool isMaxAttempts,
    required bool isLastQuestion,
    required String feedbackText,
    required int attemptNo,
    required String sessionId,
  }) {
    final question = activity.questions[questionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QuestionView(
                      question: question,
                      totalQuestions: activity.questions.length,
                      selectedAnswer: selectedAnswer,
                      isCorrect: isCorrect,
                      isSubmitting: isSubmitting,
                      attemptNo: attemptNo,
                      onSpeakTts: () {
                        getIt<TtsService>().speak(question.question);
                      },
                      onHelp: () {
                        bloc.add(const ActivityHelpRequested());
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (ctx) => Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💡',
                                    style: TextStyle(fontSize: 48)),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'تلميح ومساعدة',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'خذ وقتك وفكر بهدوء في السؤال. جرب الخيار الذي يبدو لك أقرب للإجابة! 🌟',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('فهمت، شكراً!'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onOptionSelected: (answer) {
                        if (!isSubmitting && !showFeedback) {
                          bloc.add(ActivityAnswerSelected(answer));
                        }
                      },
                    ),
                    if (showFeedback) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AnswerFeedbackView(
                        isCorrect: isCorrect ?? false,
                        feedbackText: feedbackText,
                        attemptNo: attemptNo,
                        isMaxAttempts: isMaxAttempts,
                        isLastQuestion: isLastQuestion,
                        onNext: () => bloc.add(const ActivityNextQuestion()),
                        onRetry: bloc.retryCurrentQuestion,
                      ),
                    ],
                    if (isSubmitting)
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading view ──────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onExit,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('😔',
              style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text('حاول مرة أخرى'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onExit,
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }
}
