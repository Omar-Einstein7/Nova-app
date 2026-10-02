// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RegisterState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RegisterState()';
  }
}

/// @nodoc
class $RegisterStateCopyWith<$Res> {
  $RegisterStateCopyWith(RegisterState _, $Res Function(RegisterState) __);
}

/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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
    TResult Function(RegisterStateInitial value)? initial,
    TResult Function(RegisterStateLoading value)? loading,
    TResult Function(RegisterStateSuccess value)? success,
    TResult Function(RegisterStateFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case RegisterStateInitial() when initial != null:
        return initial(_that);
      case RegisterStateLoading() when loading != null:
        return loading(_that);
      case RegisterStateSuccess() when success != null:
        return success(_that);
      case RegisterStateFailure() when failure != null:
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
    required TResult Function(RegisterStateInitial value) initial,
    required TResult Function(RegisterStateLoading value) loading,
    required TResult Function(RegisterStateSuccess value) success,
    required TResult Function(RegisterStateFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case RegisterStateInitial():
        return initial(_that);
      case RegisterStateLoading():
        return loading(_that);
      case RegisterStateSuccess():
        return success(_that);
      case RegisterStateFailure():
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
    TResult? Function(RegisterStateInitial value)? initial,
    TResult? Function(RegisterStateLoading value)? loading,
    TResult? Function(RegisterStateSuccess value)? success,
    TResult? Function(RegisterStateFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case RegisterStateInitial() when initial != null:
        return initial(_that);
      case RegisterStateLoading() when loading != null:
        return loading(_that);
      case RegisterStateSuccess() when success != null:
        return success(_that);
      case RegisterStateFailure() when failure != null:
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
      case RegisterStateInitial() when initial != null:
        return initial();
      case RegisterStateLoading() when loading != null:
        return loading();
      case RegisterStateSuccess() when success != null:
        return success(_that.user);
      case RegisterStateFailure() when failure != null:
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
      case RegisterStateInitial():
        return initial();
      case RegisterStateLoading():
        return loading();
      case RegisterStateSuccess():
        return success(_that.user);
      case RegisterStateFailure():
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
      case RegisterStateInitial() when initial != null:
        return initial();
      case RegisterStateLoading() when loading != null:
        return loading();
      case RegisterStateSuccess() when success != null:
        return success(_that.user);
      case RegisterStateFailure() when failure != null:
        return failure(_that.failure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class RegisterStateInitial implements RegisterState {
  const RegisterStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RegisterStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RegisterState.initial()';
  }
}

/// @nodoc

class RegisterStateLoading implements RegisterState {
  const RegisterStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RegisterStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RegisterState.loading()';
  }
}

/// @nodoc

class RegisterStateSuccess implements RegisterState {
  const RegisterStateSuccess(this.user);

  final User user;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterStateSuccessCopyWith<RegisterStateSuccess> get copyWith =>
      _$RegisterStateSuccessCopyWithImpl<RegisterStateSuccess>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterStateSuccess &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, user);
  }

  @override
  String toString() {
    return 'RegisterState.success(user: $user)';
  }
}

/// @nodoc
abstract mixin class $RegisterStateSuccessCopyWith<$Res>
    implements $RegisterStateCopyWith<$Res> {
  factory $RegisterStateSuccessCopyWith(RegisterStateSuccess value,
          $Res Function(RegisterStateSuccess) _then) =
      _$RegisterStateSuccessCopyWithImpl;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$RegisterStateSuccessCopyWithImpl<$Res>
    implements $RegisterStateSuccessCopyWith<$Res> {
  _$RegisterStateSuccessCopyWithImpl(this._self, this._then);

  final RegisterStateSuccess _self;
  final $Res Function(RegisterStateSuccess) _then;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(RegisterStateSuccess(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  /// Create a copy of RegisterState
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

class RegisterStateFailure implements RegisterState {
  const RegisterStateFailure(this.failure);

  final Failure failure;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterStateFailureCopyWith<RegisterStateFailure> get copyWith =>
      _$RegisterStateFailureCopyWithImpl<RegisterStateFailure>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterStateFailure &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, failure);
  }

  @override
  String toString() {
    return 'RegisterState.failure(failure: $failure)';
  }
}

/// @nodoc
abstract mixin class $RegisterStateFailureCopyWith<$Res>
    implements $RegisterStateCopyWith<$Res> {
  factory $RegisterStateFailureCopyWith(RegisterStateFailure value,
          $Res Function(RegisterStateFailure) _then) =
      _$RegisterStateFailureCopyWithImpl;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$RegisterStateFailureCopyWithImpl<$Res>
    implements $RegisterStateFailureCopyWith<$Res> {
  _$RegisterStateFailureCopyWithImpl(this._self, this._then);

  final RegisterStateFailure _self;
  final $Res Function(RegisterStateFailure) _then;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? failure = null,
  }) {
    return _then(RegisterStateFailure(
      null == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  /// Create a copy of RegisterState
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
