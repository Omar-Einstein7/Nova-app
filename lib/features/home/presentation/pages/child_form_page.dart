import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../children/domain/entities/child.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';
import '../../../children/presentation/cubit/children_list_cubit.dart';
import '../../../skills/presentation/cubit/skills_cubit.dart';
import '../widgets/step1_identity.dart';
import '../widgets/step2_style.dart';
import '../widgets/step3_skills.dart';

class ChildFormPage extends StatelessWidget {
  const ChildFormPage({super.key, this.existing});

  /// Non-null when editing an existing child.
  final Child? existing;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChildFormCubit>(
          create: (_) => getIt<ChildFormCubitFactory>().create(existing),
        ),
        // SkillsCubit is session-scoped; fetch if not yet loaded
        BlocProvider<SkillsCubit>(
          create: (_) => getIt<SkillsCubit>()..load(),
        ),
        BlocProvider<ChildrenListCubit>(
          create: (_) => getIt<ChildrenListCubit>(),
        ),
      ],
      child: _ChildFormView(isEdit: existing != null),
    );
  }
}

class _ChildFormView extends StatefulWidget {
  const _ChildFormView({required this.isEdit});
  final bool isEdit;

  @override
  State<_ChildFormView> createState() => _ChildFormViewState();
}

class _ChildFormViewState extends State<_ChildFormView> {
  // Form key for step 1 inline validation
  final _step1Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocConsumer<ChildFormCubit, ChildFormState>(
      listener: _onStateChange,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            title: Text(
              widget.isEdit ? l.editChildTitle : l.addChildTitle,
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          body: Column(
            children: [
              // Progress indicator
              _StepIndicator(currentStep: state.currentStep),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: _buildCurrentStep(context, state),
                ),
              ),
              // Navigation buttons
              _StepNavBar(
                step1Key: _step1Key,
                state: state,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(BuildContext context, ChildFormState state) {
    return switch (state.currentStep) {
      0 => Step1Identity(formKey: _step1Key),
      1 => const Step2Style(),
      _ => const Step3Skills(),
    };
  }

  void _onStateChange(BuildContext context, ChildFormState state) {
    final l = AppLocalizations.of(context);
    if (state.status == ChildFormStatus.success && state.savedChild != null) {
      // Notify list cubit
      final listCubit = context.read<ChildrenListCubit>();
      if (widget.isEdit) {
        listCubit.childUpdated(state.savedChild!);
      } else {
        listCubit.childCreated(state.savedChild!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.childSavedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }

    if (state.status == ChildFormStatus.failure && state.failure != null) {
      final msg = _failureMessage(context, state.failure!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.gentleRetry),
      );
    }
  }

  static String _failureMessage(BuildContext context, Failure failure) {
    final l = AppLocalizations.of(context);
    return switch (failure) {
      ServerFailure(:final code) when code == 'CONFLICT' =>
        l.maxChildrenReached,
      NetworkFailure() => l.errorNetwork,
      _ => l.errorGeneric,
    };
  }
}

// ── Progress indicator ────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final isActive = i <= currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 32 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white38,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

// ── Navigation bar ────────────────────────────────────────────────────────────

class _StepNavBar extends StatelessWidget {
  const _StepNavBar({required this.step1Key, required this.state});
  final GlobalKey<FormState> step1Key;
  final ChildFormState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<ChildFormCubit>();
    final isLoading = state.status == ChildFormStatus.loading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            if (state.currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : cubit.prevStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: Text(l.back,
                      style: const TextStyle(color: AppColors.primary)),
                ),
              ),
            if (state.currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                key: Key('form_step${state.currentStep}_next_btn'),
                label: state.currentStep == 2 ? l.save : l.continueLabel,
                isLoading: isLoading,
                onPressed: isLoading ? null : () => _onNext(context, cubit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext(BuildContext context, ChildFormCubit cubit) {
    if (cubit.state.currentStep == 0) {
      if (step1Key.currentState?.validate() != true) return;
      if (!cubit.validateStep1()) return;
      cubit.nextStep();
    } else if (cubit.state.currentStep == 1) {
      if (!cubit.validateStep2()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).selectLearningStyle),
          ),
        );
        return;
      }
      cubit.nextStep();
    } else {
      if (!cubit.validateStep3()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).selectAtLeastOneSkill),
          ),
        );
        return;
      }
      cubit.submit();
    }
  }
}
