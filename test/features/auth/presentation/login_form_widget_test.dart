import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Left;
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/core/l10n/app_localizations.dart';
import 'package:nova/core/theme/app_theme.dart';
import 'package:nova/features/auth/domain/entities/user.dart';
import 'package:nova/features/auth/domain/usecases/login_use_case.dart';
import 'package:nova/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nova/features/auth/presentation/cubit/auth_state.dart';
import 'package:nova/features/auth/presentation/cubit/login_cubit.dart';
import 'package:nova/features/auth/presentation/cubit/login_state.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class _MockLoginUseCase extends Mock implements LoginUseCase {}

/// Minimal fake AuthCubit that only needs to expose `state` and
/// `onLoggedIn` for the widget test.
class _FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  _FakeAuthCubit() : super(const AuthState.unauthenticated());

  @override
  Listenable get routerListenable => _n;
  final _n = _Noop();

  @override
  Future<void> restoreSession() async {}

  @override
  void onLoggedIn(User user) {}

  @override
  Future<void> logout() async {}

  @override
  void onAccountDeleted() {}

  @override
  bool get isAuthenticated => false;

  @override
  User? get currentUser => null;
}

class _Noop extends ChangeNotifier {}

// ── Test widget helper ────────────────────────────────────────────────────────

Widget _harness({
  required LoginCubit loginCubit,
  required AuthCubit authCubit,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<LoginCubit>.value(value: loginCubit),
      BlocProvider<AuthCubit>.value(value: authCubit),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (ctx, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: _LoginFormHarness(),
    ),
  );
}

/// Inline form that mirrors LoginPage field keys and validation rules.
class _LoginFormHarness extends StatefulWidget {
  @override
  State<_LoginFormHarness> createState() => _LoginFormHarnessState();
}

class _LoginFormHarnessState extends State<_LoginFormHarness> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  static const _emailRegex =
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$';

  static bool _strongPassword(String v) =>
      v.length >= 8 &&
      v.contains(RegExp(r'[a-zA-Z]')) &&
      v.contains(RegExp(r'[0-9]'));

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key('login_email_field'),
              controller: _emailCtrl,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.validationEmailRequired;
                }
                if (!RegExp(_emailRegex).hasMatch(v.trim())) {
                  return l10n.validationEmailInvalid;
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('login_password_field'),
              controller: _passwordCtrl,
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.validationPasswordRequired;
                }
                if (!_strongPassword(v)) return l10n.validationPasswordWeak;
                return null;
              },
            ),
            ElevatedButton(
              key: const Key('login_submit_button'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<LoginCubit>().submit(
                        email: _emailCtrl.text.trim(),
                        password: _passwordCtrl.text,
                      );
                }
              },
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tests ──────────────────────────────────────────────────────────────────────

void main() {
  late _MockLoginUseCase loginUseCase;
  late _FakeAuthCubit authCubit;

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    authCubit = _FakeAuthCubit();
  });

  tearDown(() {
    authCubit.close();
  });

  LoginCubit buildLoginCubit() =>
      LoginCubit(loginUseCase: loginUseCase);

  group('Login form validation', () {
    testWidgets('shows email-required error on empty submit', (tester) async {
      await tester.pumpWidget(_harness(
        loginCubit: buildLoginCubit(),
        authCubit: authCubit,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('البريد الإلكتروني مطلوب.'), findsOneWidget);
    });

    testWidgets('shows invalid-email error for malformed email', (tester) async {
      await tester.pumpWidget(_harness(
        loginCubit: buildLoginCubit(),
        authCubit: authCubit,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'not-an-email');
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('يرجى إدخال بريد إلكتروني صحيح.'), findsOneWidget);
    });

    testWidgets('shows password-required error when password is empty',
        (tester) async {
      await tester.pumpWidget(_harness(
        loginCubit: buildLoginCubit(),
        authCubit: authCubit,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('كلمة المرور مطلوبة.'), findsOneWidget);
    });

    testWidgets('shows weak-password error for password without digit',
        (tester) async {
      await tester.pumpWidget(_harness(
        loginCubit: buildLoginCubit(),
        authCubit: authCubit,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'onlyletters');
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('8 أحرف'), findsOneWidget);
    });

    testWidgets('calls LoginCubit.submit when form is valid', (tester) async {
      when(
        () => loginUseCase(
          email: 'test@example.com',
          password: 'Password1',
        ),
      ).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return const Left(Failure.network());
      });

      final cubit = buildLoginCubit();
      await tester.pumpWidget(_harness(
        loginCubit: cubit,
        authCubit: authCubit,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'Password1');
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();

      expect(cubit.state, isA<LoginStateLoading>());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
