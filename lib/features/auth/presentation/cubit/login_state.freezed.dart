// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LoginState()';
  }
}

/// @nodoc
class $LoginStateCopyWith<$Res> {
  $LoginStateCopyWith(LoginState _, $Res Function(LoginState) __);
}

/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginStateInitial value)? initial,
    TResult Function(LoginStateLoading value)? loading,
    TResult Function(LoginStateSuccess value)? success,
    TResult Function(LoginStateFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial() when initial != null:
        return initial(_that);
      case LoginStateLoading() when loading != null:
        return loading(_that);
      case LoginStateSuccess() when success != null:
        return success(_that);
      case LoginStateFailure() when failure != null:
        return failure(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginStateInitial value) initial,
    required TResult Function(LoginStateLoading value) loading,
    required TResult Function(LoginStateSuccess value) success,
    required TResult Function(LoginStateFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial():
        return initial(_that);
      case LoginStateLoading():
        return loading(_that);
      case LoginStateSuccess():
        return success(_that);
      case LoginStateFailure():
        return failure(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginStateInitial value)? initial,
    TResult? Function(LoginStateLoading value)? loading,
    TResult? Function(LoginStateSuccess value)? success,
    TResult? Function(LoginStateFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial() when initial != null:
        return initial(_that);
      case LoginStateLoading() when loading != null:
        return loading(_that);
      case LoginStateSuccess() when success != null:
        return success(_that);
      case LoginStateFailure() when failure != null:
        return failure(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? success,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial() when initial != null:
        return initial();
      case LoginStateLoading() when loading != null:
        return loading();
      case LoginStateSuccess() when success != null:
        return success(_that.user);
      case LoginStateFailure() when failure != null:
        return failure(_that.failure);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) success,
    required TResult Function(Failure failure) failure,
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial():
        return initial();
      case LoginStateLoading():
        return loading();
      case LoginStateSuccess():
        return success(_that.user);
      case LoginStateFailure():
        return failure(_that.failure);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? success,
    TResult? Function(Failure failure)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case LoginStateInitial() when initial != null:
        return initial();
      case LoginStateLoading() when loading != null:
        return loading();
      case LoginStateSuccess() when success != null:
        return success(_that.user);
      case LoginStateFailure() when failure != null:
        return failure(_that.failure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LoginStateInitial implements LoginState {
  const LoginStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LoginState.initial()';
  }
}

/// @nodoc

class LoginStateLoading implements LoginState {
  const LoginStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LoginState.loading()';
  }
}

/// @nodoc

class LoginStateSuccess implements LoginState {
  const LoginStateSuccess(this.user);

  final User user;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginStateSuccessCopyWith<LoginStateSuccess> get copyWith =>
      _$LoginStateSuccessCopyWithImpl<LoginStateSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginStateSuccess &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, user);
  }

  @override
  String toString() {
    return 'LoginState.success(user: $user)';
  }
}

/// @nodoc
abstract mixin class $LoginStateSuccessCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory $LoginStateSuccessCopyWith(
          LoginStateSuccess value, $Res Function(LoginStateSuccess) _then) =
      _$LoginStateSuccessCopyWithImpl;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginStateSuccessCopyWithImpl<$Res>
    implements $LoginStateSuccessCopyWith<$Res> {
  _$LoginStateSuccessCopyWithImpl(this._self, this._then);

  final LoginStateSuccess _self;
  final $Res Function(LoginStateSuccess) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(LoginStateSuccess(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class LoginStateFailure implements LoginState {
  const LoginStateFailure(this.failure);

  final Failure failure;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginStateFailureCopyWith<LoginStateFailure> get copyWith =>
      _$LoginStateFailureCopyWithImpl<LoginStateFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginStateFailure &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, failure);
  }

  @override
  String toString() {
    return 'LoginState.failure(failure: $failure)';
  }
}

/// @nodoc
abstract mixin class $LoginStateFailureCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory $LoginStateFailureCopyWith(
          LoginStateFailure value, $Res Function(LoginStateFailure) _then) =
      _$LoginStateFailureCopyWithImpl;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$LoginStateFailureCopyWithImpl<$Res>
    implements $LoginStateFailureCopyWith<$Res> {
  _$LoginStateFailureCopyWithImpl(this._self, this._then);

  final LoginStateFailure _self;
  final $Res Function(LoginStateFailure) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? failure = null,
  }) {
    return _then(LoginStateFailure(
      null == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_self.failure, (value) {
      return _then(_self.copyWith(failure: value));
    });
  }
}

// dart format on
