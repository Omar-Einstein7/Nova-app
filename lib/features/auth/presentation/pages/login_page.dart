import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_terms_footer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(loginUseCase: getIt()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().submit(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginStateSuccess) {
          context.read<AuthCubit>().onLoggedIn(state.user);
        }
        if (state is LoginStateFailure) {
          final msg = _failureToArabic(state.failure, l10n);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(msg, textDirection: TextDirection.rtl),
                backgroundColor: AppColors.gentleRetry,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginStateLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const AuthHeader(),
                    const SizedBox(height: 36),
                    // ── Title ─────────────────────────────────────────────
                    Text(
                      l10n.loginTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // ── Email ─────────────────────────────────────────────
                    AppTextField(
                      key: const Key('login_email_field'),
                      label: l10n.emailLabel,
                      hint: l10n.loginEmailHint,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) => _validateEmail(v, l10n),
                    ),
                    const SizedBox(height: 16),
                    // ── Password ──────────────────────────────────────────
                    AppTextField(
                      key: const Key('login_password_field'),
                      label: l10n.passwordLabel,
                      hint: l10n.loginPasswordHint,
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.password],
                      validator: (v) => _validatePassword(v, l10n),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        tooltip: _obscurePassword
                            ? l10n.showPassword
                            : l10n.hidePassword,
                        onPressed: isLoading
                            ? null
                            : () => setState(
                                () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // ── Submit ────────────────────────────────────────────
                    AppButton(
                      key: const Key('login_submit_button'),
                      label: l10n.loginButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _submit(context),
                    ),
                    const SizedBox(height: 24),
                    // ── Navigate to Register ───────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.loginNoAccount,
                            style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                          key: const Key('login_go_register_button'),
                          onPressed: isLoading
                              ? null
                              : () => context.goNamed(RouteNames.register),
                          child: Text(l10n.loginCreateAccount),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AuthTermsFooter(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Validators ──────────────────────────────────────────────────────────────

  static String? _validateEmail(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return l10n.validationEmailRequired;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(v.trim())) return l10n.validationEmailInvalid;
    return null;
  }

  static String? _validatePassword(String? v, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.validationPasswordRequired;
    if (!_isPasswordStrong(v)) return l10n.validationPasswordWeak;
    return null;
  }

  static bool _isPasswordStrong(String v) =>
      v.length >= 8 &&
      v.contains(RegExp(r'[a-zA-Z]')) &&
      v.contains(RegExp(r'[0-9]'));

  // ── Error mapping ────────────────────────────────────────────────────────────

  static String _failureToArabic(Failure failure, AppLocalizations l10n) {
    return failure.when(
      network: (_) => l10n.errorNetwork,
      timeout: () => l10n.errorTimeout,
      server: (code, message, _) {
        if (code == 'UNAUTHORIZED') return l10n.loginWrongCredentials;
        return l10n.errorServer(message);
      },
      unauthorized: () => l10n.loginWrongCredentials,
      validation: (_) => l10n.errorValidation,
      unknown: (msg) => msg ?? l10n.errorGeneric,
    );
  }
}
