import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';

part 'register_state.freezed.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = RegisterStateInitial;
  const factory RegisterState.loading() = RegisterStateLoading;
  const factory RegisterState.success(User user) = RegisterStateSuccess;
  const factory RegisterState.failure(Failure failure) = RegisterStateFailure;
}
