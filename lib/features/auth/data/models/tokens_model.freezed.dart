// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tokens_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokensModel {
  String get accessToken;
  String get refreshToken;

  /// Create a copy of TokensModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TokensModelCopyWith<TokensModel> get copyWith =>
      _$TokensModelCopyWithImpl<TokensModel>(this as TokensModel, _$identity);

  /// Serializes this TokensModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as TokensModel;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TokensModel &&
            (identical(other.accessToken, _this.accessToken) ||
                other.accessToken == _this.accessToken) &&
            (identical(other.refreshToken, _this.refreshToken) ||
                other.refreshToken == _this.refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as TokensModel;
    return Object.hash(runtimeType, _this.accessToken, _this.refreshToken);
  }

  @override
  String toString() {
    final _this = this as TokensModel;
    return 'TokensModel(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken})';
  }
}

/// @nodoc
abstract mixin class $TokensModelCopyWith<$Res> {
  factory $TokensModelCopyWith(
          TokensModel value, $Res Function(TokensModel) _then) =
      _$TokensModelCopyWithImpl;
  @useResult
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class _$TokensModelCopyWithImpl<$Res> implements $TokensModelCopyWith<$Res> {
  _$TokensModelCopyWithImpl(this._self, this._then);

  final TokensModel _self;
  final $Res Function(TokensModel) _then;

  /// Create a copy of TokensModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
  }) {
    return _then(TokensModel(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TokensModel].
extension TokensModelPatterns on TokensModel {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TokensModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokensModel() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_TokensModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokensModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TokensModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokensModel() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokensModel() when $default != null:
        return $default(_that.accessToken, _that.refreshToken);
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
  TResult when<TResult extends Object?>(
    TResult Function(String accessToken, String refreshToken) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokensModel():
        return $default(_that.accessToken, _that.refreshToken);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String accessToken, String refreshToken)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokensModel() when $default != null:
        return $default(_that.accessToken, _that.refreshToken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TokensModel implements TokensModel {
  const _TokensModel({required this.accessToken, required this.refreshToken});
  factory _TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;

  /// Create a copy of TokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TokensModelCopyWith<_TokensModel> get copyWith =>
      __$TokensModelCopyWithImpl<_TokensModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TokensModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TokensModel &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, accessToken, refreshToken);
  }

  @override
  String toString() {
    return 'TokensModel(accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

/// @nodoc
abstract mixin class _$TokensModelCopyWith<$Res>
    implements $TokensModelCopyWith<$Res> {
  factory _$TokensModelCopyWith(
          _TokensModel value, $Res Function(_TokensModel) _then) =
      __$TokensModelCopyWithImpl;
  @override
  @useResult
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class __$TokensModelCopyWithImpl<$Res> implements _$TokensModelCopyWith<$Res> {
  __$TokensModelCopyWithImpl(this._self, this._then);

  final _TokensModel _self;
  final $Res Function(_TokensModel) _then;

  /// Create a copy of TokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
  }) {
    return _then(_TokensModel(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
