// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skills_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SkillsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SkillsState()';
  }
}

/// @nodoc
class $SkillsStateCopyWith<$Res> {
  $SkillsStateCopyWith(SkillsState _, $Res Function(SkillsState) __);
}

/// Adds pattern-matching-related methods to [SkillsState].
extension SkillsStatePatterns on SkillsState {
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
    TResult Function(SkillsStateInitial value)? initial,
    TResult Function(SkillsStateLoading value)? loading,
    TResult Function(SkillsStateLoaded value)? loaded,
    TResult Function(SkillsStateError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial() when initial != null:
        return initial(_that);
      case SkillsStateLoading() when loading != null:
        return loading(_that);
      case SkillsStateLoaded() when loaded != null:
        return loaded(_that);
      case SkillsStateError() when error != null:
        return error(_that);
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
    required TResult Function(SkillsStateInitial value) initial,
    required TResult Function(SkillsStateLoading value) loading,
    required TResult Function(SkillsStateLoaded value) loaded,
    required TResult Function(SkillsStateError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial():
        return initial(_that);
      case SkillsStateLoading():
        return loading(_that);
      case SkillsStateLoaded():
        return loaded(_that);
      case SkillsStateError():
        return error(_that);
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
    TResult? Function(SkillsStateInitial value)? initial,
    TResult? Function(SkillsStateLoading value)? loading,
    TResult? Function(SkillsStateLoaded value)? loaded,
    TResult? Function(SkillsStateError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial() when initial != null:
        return initial(_that);
      case SkillsStateLoading() when loading != null:
        return loading(_that);
      case SkillsStateLoaded() when loaded != null:
        return loaded(_that);
      case SkillsStateError() when error != null:
        return error(_that);
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
    TResult Function(List<Skill> skills)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial() when initial != null:
        return initial();
      case SkillsStateLoading() when loading != null:
        return loading();
      case SkillsStateLoaded() when loaded != null:
        return loaded(_that.skills);
      case SkillsStateError() when error != null:
        return error(_that.failure);
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
    required TResult Function(List<Skill> skills) loaded,
    required TResult Function(Failure failure) error,
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial():
        return initial();
      case SkillsStateLoading():
        return loading();
      case SkillsStateLoaded():
        return loaded(_that.skills);
      case SkillsStateError():
        return error(_that.failure);
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
    TResult? Function(List<Skill> skills)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SkillsStateInitial() when initial != null:
        return initial();
      case SkillsStateLoading() when loading != null:
        return loading();
      case SkillsStateLoaded() when loaded != null:
        return loaded(_that.skills);
      case SkillsStateError() when error != null:
        return error(_that.failure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SkillsStateInitial implements SkillsState {
  const SkillsStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SkillsStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SkillsState.initial()';
  }
}

/// @nodoc

class SkillsStateLoading implements SkillsState {
  const SkillsStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SkillsStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SkillsState.loading()';
  }
}

/// @nodoc

class SkillsStateLoaded implements SkillsState {
  const SkillsStateLoaded(List<Skill> skills) : _skills = skills;

  final List<Skill> _skills;
  List<Skill> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SkillsStateLoadedCopyWith<SkillsStateLoaded> get copyWith =>
      _$SkillsStateLoadedCopyWithImpl<SkillsStateLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkillsStateLoaded &&
            const DeepCollectionEquality().equals(other.skills, _skills));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(_skills));
  }

  @override
  String toString() {
    return 'SkillsState.loaded(skills: $skills)';
  }
}

/// @nodoc
abstract mixin class $SkillsStateLoadedCopyWith<$Res>
    implements $SkillsStateCopyWith<$Res> {
  factory $SkillsStateLoadedCopyWith(
          SkillsStateLoaded value, $Res Function(SkillsStateLoaded) _then) =
      _$SkillsStateLoadedCopyWithImpl;
  @useResult
  $Res call({List<Skill> skills});
}

/// @nodoc
class _$SkillsStateLoadedCopyWithImpl<$Res>
    implements $SkillsStateLoadedCopyWith<$Res> {
  _$SkillsStateLoadedCopyWithImpl(this._self, this._then);

  final SkillsStateLoaded _self;
  final $Res Function(SkillsStateLoaded) _then;

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? skills = null,
  }) {
    return _then(SkillsStateLoaded(
      null == skills
          ? _self._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<Skill>,
    ));
  }
}

/// @nodoc

class SkillsStateError implements SkillsState {
  const SkillsStateError(this.failure);

  final Failure failure;

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SkillsStateErrorCopyWith<SkillsStateError> get copyWith =>
      _$SkillsStateErrorCopyWithImpl<SkillsStateError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkillsStateError &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, failure);
  }

  @override
  String toString() {
    return 'SkillsState.error(failure: $failure)';
  }
}

/// @nodoc
abstract mixin class $SkillsStateErrorCopyWith<$Res>
    implements $SkillsStateCopyWith<$Res> {
  factory $SkillsStateErrorCopyWith(
          SkillsStateError value, $Res Function(SkillsStateError) _then) =
      _$SkillsStateErrorCopyWithImpl;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$SkillsStateErrorCopyWithImpl<$Res>
    implements $SkillsStateErrorCopyWith<$Res> {
  _$SkillsStateErrorCopyWithImpl(this._self, this._then);

  final SkillsStateError _self;
  final $Res Function(SkillsStateError) _then;

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? failure = null,
  }) {
    return _then(SkillsStateError(
      null == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  /// Create a copy of SkillsState
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
