import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_use_case.dart';
import 'login_state.dart';

/// Cubit for the Login page.
/// Lives only while the LoginPage is in the tree.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required LoginUseCase loginUseCase})
      : _login = loginUseCase,
        super(const LoginState.initial());

  final LoginUseCase _login;

  /// Submit the login form.
  /// Guards against double-submit: no-op if already loading.
  Future<void> submit({
    required String email,
    required String password,
  }) async {
    if (state is LoginStateLoading) return;
    emit(const LoginState.loading());

    final result = await _login(email: email, password: password);
    result.fold(
      (failure) => emit(LoginState.failure(failure)),
      (user) => emit(LoginState.success(user)),
    );
  }
}
