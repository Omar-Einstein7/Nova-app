// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'children_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildrenListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChildrenListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChildrenListState()';
  }
}

/// @nodoc
class $ChildrenListStateCopyWith<$Res> {
  $ChildrenListStateCopyWith(
      ChildrenListState _, $Res Function(ChildrenListState) __);
}

/// Adds pattern-matching-related methods to [ChildrenListState].
extension ChildrenListStatePatterns on ChildrenListState {
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
    TResult Function(ChildrenListStateInitial value)? initial,
    TResult Function(ChildrenListStateLoading value)? loading,
    TResult Function(ChildrenListStateLoaded value)? loaded,
    TResult Function(ChildrenListStateError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial() when initial != null:
        return initial(_that);
      case ChildrenListStateLoading() when loading != null:
        return loading(_that);
      case ChildrenListStateLoaded() when loaded != null:
        return loaded(_that);
      case ChildrenListStateError() when error != null:
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
    required TResult Function(ChildrenListStateInitial value) initial,
    required TResult Function(ChildrenListStateLoading value) loading,
    required TResult Function(ChildrenListStateLoaded value) loaded,
    required TResult Function(ChildrenListStateError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial():
        return initial(_that);
      case ChildrenListStateLoading():
        return loading(_that);
      case ChildrenListStateLoaded():
        return loaded(_that);
      case ChildrenListStateError():
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
    TResult? Function(ChildrenListStateInitial value)? initial,
    TResult? Function(ChildrenListStateLoading value)? loading,
    TResult? Function(ChildrenListStateLoaded value)? loaded,
    TResult? Function(ChildrenListStateError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial() when initial != null:
        return initial(_that);
      case ChildrenListStateLoading() when loading != null:
        return loading(_that);
      case ChildrenListStateLoaded() when loaded != null:
        return loaded(_that);
      case ChildrenListStateError() when error != null:
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
    TResult Function(List<Child> children)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial() when initial != null:
        return initial();
      case ChildrenListStateLoading() when loading != null:
        return loading();
      case ChildrenListStateLoaded() when loaded != null:
        return loaded(_that.children);
      case ChildrenListStateError() when error != null:
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
    required TResult Function(List<Child> children) loaded,
    required TResult Function(Failure failure) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial():
        return initial();
      case ChildrenListStateLoading():
        return loading();
      case ChildrenListStateLoaded():
        return loaded(_that.children);
      case ChildrenListStateError():
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
    TResult? Function(List<Child> children)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChildrenListStateInitial() when initial != null:
        return initial();
      case ChildrenListStateLoading() when loading != null:
        return loading();
      case ChildrenListStateLoaded() when loaded != null:
        return loaded(_that.children);
      case ChildrenListStateError() when error != null:
        return error(_that.failure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ChildrenListStateInitial implements ChildrenListState {
  const ChildrenListStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChildrenListStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChildrenListState.initial()';
  }
}

/// @nodoc

class ChildrenListStateLoading implements ChildrenListState {
  const ChildrenListStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChildrenListStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChildrenListState.loading()';
  }
}

/// @nodoc

class ChildrenListStateLoaded implements ChildrenListState {
  const ChildrenListStateLoaded(List<Child> children) : _children = children;

  final List<Child> _children;
  List<Child> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  /// Create a copy of ChildrenListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChildrenListStateLoadedCopyWith<ChildrenListStateLoaded> get copyWith =>
      _$ChildrenListStateLoadedCopyWithImpl<ChildrenListStateLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChildrenListStateLoaded &&
            const DeepCollectionEquality().equals(other.children, _children));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(_children));
  }

  @override
  String toString() {
    return 'ChildrenListState.loaded(children: $children)';
  }
}

/// @nodoc
abstract mixin class $ChildrenListStateLoadedCopyWith<$Res>
    implements $ChildrenListStateCopyWith<$Res> {
  factory $ChildrenListStateLoadedCopyWith(ChildrenListStateLoaded value,
          $Res Function(ChildrenListStateLoaded) _then) =
      _$ChildrenListStateLoadedCopyWithImpl;
  @useResult
  $Res call({List<Child> children});
}

/// @nodoc
class _$ChildrenListStateLoadedCopyWithImpl<$Res>
    implements $ChildrenListStateLoadedCopyWith<$Res> {
  _$ChildrenListStateLoadedCopyWithImpl(this._self, this._then);

  final ChildrenListStateLoaded _self;
  final $Res Function(ChildrenListStateLoaded) _then;

  /// Create a copy of ChildrenListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? children = null,
  }) {
    return _then(ChildrenListStateLoaded(
      null == children
          ? _self._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<Child>,
    ));
  }
}

/// @nodoc

class ChildrenListStateError implements ChildrenListState {
  const ChildrenListStateError(this.failure);

  final Failure failure;

  /// Create a copy of ChildrenListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChildrenListStateErrorCopyWith<ChildrenListStateError> get copyWith =>
      _$ChildrenListStateErrorCopyWithImpl<ChildrenListStateError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChildrenListStateError &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, failure);
  }

  @override
  String toString() {
    return 'ChildrenListState.error(failure: $failure)';
  }
}

/// @nodoc
abstract mixin class $ChildrenListStateErrorCopyWith<$Res>
    implements $ChildrenListStateCopyWith<$Res> {
  factory $ChildrenListStateErrorCopyWith(ChildrenListStateError value,
          $Res Function(ChildrenListStateError) _then) =
      _$ChildrenListStateErrorCopyWithImpl;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$ChildrenListStateErrorCopyWithImpl<$Res>
    implements $ChildrenListStateErrorCopyWith<$Res> {
  _$ChildrenListStateErrorCopyWithImpl(this._self, this._then);

  final ChildrenListStateError _self;
  final $Res Function(ChildrenListStateError) _then;

  /// Create a copy of ChildrenListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? failure = null,
  }) {
    return _then(ChildrenListStateError(
      null == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  /// Create a copy of ChildrenListState
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
