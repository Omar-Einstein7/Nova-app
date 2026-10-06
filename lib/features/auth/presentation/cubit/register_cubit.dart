import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register_use_case.dart';
import 'register_state.dart';

/// Cubit for the Register page.
/// Lives only while the RegisterPage is in the tree.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required RegisterUseCase registerUseCase})
      : _register = registerUseCase,
        super(const RegisterState.initial());

  final RegisterUseCase _register;

  /// Submit the registration form.
  /// Guards against double-submit: no-op if already loading.
  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is RegisterStateLoading) return;
    emit(const RegisterState.loading());

    final result =
        await _register(name: name, email: email, password: password);
    result.fold(
      (failure) => emit(RegisterState.failure(failure)),
      (user) => emit(RegisterState.success(user)),
    );
  }
}
