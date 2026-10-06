// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DashboardState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DashboardState()';
  }
}

/// @nodoc
class $DashboardStateCopyWith<$Res> {
  $DashboardStateCopyWith(DashboardState _, $Res Function(DashboardState) __);
}

/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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
    TResult Function(DashboardStateLoading value)? loading,
    TResult Function(DashboardStateLoaded value)? loaded,
    TResult Function(DashboardStateError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading() when loading != null:
        return loading(_that);
      case DashboardStateLoaded() when loaded != null:
        return loaded(_that);
      case DashboardStateError() when error != null:
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
    required TResult Function(DashboardStateLoading value) loading,
    required TResult Function(DashboardStateLoaded value) loaded,
    required TResult Function(DashboardStateError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading():
        return loading(_that);
      case DashboardStateLoaded():
        return loaded(_that);
      case DashboardStateError():
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
    TResult? Function(DashboardStateLoading value)? loading,
    TResult? Function(DashboardStateLoaded value)? loaded,
    TResult? Function(DashboardStateError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading() when loading != null:
        return loading(_that);
      case DashboardStateLoaded() when loaded != null:
        return loaded(_that);
      case DashboardStateError() when error != null:
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
    TResult Function()? loading,
    TResult Function(Map<String, dynamic> recommendation,
            Map<String, dynamic>? progress)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading() when loading != null:
        return loading();
      case DashboardStateLoaded() when loaded != null:
        return loaded(_that.recommendation, _that.progress);
      case DashboardStateError() when error != null:
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
    required TResult Function() loading,
    required TResult Function(
            Map<String, dynamic> recommendation, Map<String, dynamic>? progress)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading():
        return loading();
      case DashboardStateLoaded():
        return loaded(_that.recommendation, _that.progress);
      case DashboardStateError():
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
    TResult? Function()? loading,
    TResult? Function(Map<String, dynamic> recommendation,
            Map<String, dynamic>? progress)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    final _that = this;
    switch (_that) {
      case DashboardStateLoading() when loading != null:
        return loading();
      case DashboardStateLoaded() when loaded != null:
        return loaded(_that.recommendation, _that.progress);
      case DashboardStateError() when error != null:
        return error(_that.failure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class DashboardStateLoading implements DashboardState {
  const DashboardStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DashboardStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DashboardState.loading()';
  }
}

/// @nodoc

class DashboardStateLoaded implements DashboardState {
  const DashboardStateLoaded(
      {required Map<String, dynamic> recommendation,
      Map<String, dynamic>? progress})
      : _recommendation = recommendation,
        _progress = progress;

  final Map<String, dynamic> _recommendation;
  Map<String, dynamic> get recommendation {
    if (_recommendation is EqualUnmodifiableMapView) return _recommendation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_recommendation);
  }

  final Map<String, dynamic>? _progress;
  Map<String, dynamic>? get progress {
    final value = _progress;
    if (value == null) return null;
    if (_progress is EqualUnmodifiableMapView) return _progress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardStateLoadedCopyWith<DashboardStateLoaded> get copyWith =>
      _$DashboardStateLoadedCopyWithImpl<DashboardStateLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardStateLoaded &&
            const DeepCollectionEquality()
                .equals(other.recommendation, _recommendation) &&
            const DeepCollectionEquality().equals(other.progress, _progress));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(_recommendation),
        const DeepCollectionEquality().hash(_progress));
  }

  @override
  String toString() {
    return 'DashboardState.loaded(recommendation: $recommendation, progress: $progress)';
  }
}

/// @nodoc
abstract mixin class $DashboardStateLoadedCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory $DashboardStateLoadedCopyWith(DashboardStateLoaded value,
          $Res Function(DashboardStateLoaded) _then) =
      _$DashboardStateLoadedCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, dynamic> recommendation, Map<String, dynamic>? progress});
}

/// @nodoc
class _$DashboardStateLoadedCopyWithImpl<$Res>
    implements $DashboardStateLoadedCopyWith<$Res> {
  _$DashboardStateLoadedCopyWithImpl(this._self, this._then);

  final DashboardStateLoaded _self;
  final $Res Function(DashboardStateLoaded) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recommendation = null,
    Object? progress = freezed,
  }) {
    return _then(DashboardStateLoaded(
      recommendation: null == recommendation
          ? _self._recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      progress: freezed == progress
          ? _self._progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class DashboardStateError implements DashboardState {
  const DashboardStateError(this.failure);

  final Failure failure;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardStateErrorCopyWith<DashboardStateError> get copyWith =>
      _$DashboardStateErrorCopyWithImpl<DashboardStateError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardStateError &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, failure);
  }

  @override
  String toString() {
    return 'DashboardState.error(failure: $failure)';
  }
}

/// @nodoc
abstract mixin class $DashboardStateErrorCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory $DashboardStateErrorCopyWith(
          DashboardStateError value, $Res Function(DashboardStateError) _then) =
      _$DashboardStateErrorCopyWithImpl;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$DashboardStateErrorCopyWithImpl<$Res>
    implements $DashboardStateErrorCopyWith<$Res> {
  _$DashboardStateErrorCopyWithImpl(this._self, this._then);

  final DashboardStateError _self;
  final $Res Function(DashboardStateError) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? failure = null,
  }) {
    return _then(DashboardStateError(
      null == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  /// Create a copy of DashboardState
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
