// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillModel {
  String get id;
  String get key;
  String get nameAr;
  String get nameEn;
  String? get description;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SkillModelCopyWith<SkillModel> get copyWith =>
      _$SkillModelCopyWithImpl<SkillModel>(this as SkillModel, _$identity);

  /// Serializes this SkillModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as SkillModel;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkillModel &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.key, _this.key) || other.key == _this.key) &&
            (identical(other.nameAr, _this.nameAr) ||
                other.nameAr == _this.nameAr) &&
            (identical(other.nameEn, _this.nameEn) ||
                other.nameEn == _this.nameEn) &&
            (identical(other.description, _this.description) ||
                other.description == _this.description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as SkillModel;
    return Object.hash(runtimeType, _this.id, _this.key, _this.nameAr,
        _this.nameEn, _this.description);
  }

  @override
  String toString() {
    final _this = this as SkillModel;
    return 'SkillModel(id: ${_this.id}, key: ${_this.key}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, description: ${_this.description})';
  }
}

/// @nodoc
abstract mixin class $SkillModelCopyWith<$Res> {
  factory $SkillModelCopyWith(
          SkillModel value, $Res Function(SkillModel) _then) =
      _$SkillModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String key,
      String nameAr,
      String nameEn,
      String? description});
}

/// @nodoc
class _$SkillModelCopyWithImpl<$Res> implements $SkillModelCopyWith<$Res> {
  _$SkillModelCopyWithImpl(this._self, this._then);

  final SkillModel _self;
  final $Res Function(SkillModel) _then;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? description = freezed,
  }) {
    return _then(SkillModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _self.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _self.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SkillModel].
extension SkillModelPatterns on SkillModel {
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
    TResult Function(_SkillModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SkillModel() when $default != null:
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
    TResult Function(_SkillModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SkillModel():
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
    TResult? Function(_SkillModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SkillModel() when $default != null:
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
    TResult Function(String id, String key, String nameAr, String nameEn,
            String? description)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SkillModel() when $default != null:
        return $default(
            _that.id, _that.key, _that.nameAr, _that.nameEn, _that.description);
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
    TResult Function(String id, String key, String nameAr, String nameEn,
            String? description)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SkillModel():
        return $default(
            _that.id, _that.key, _that.nameAr, _that.nameEn, _that.description);
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
    TResult? Function(String id, String key, String nameAr, String nameEn,
            String? description)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SkillModel() when $default != null:
        return $default(
            _that.id, _that.key, _that.nameAr, _that.nameEn, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SkillModel implements SkillModel {
  const _SkillModel(
      {required this.id,
      required this.key,
      required this.nameAr,
      required this.nameEn,
      this.description});
  factory _SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String? description;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SkillModelCopyWith<_SkillModel> get copyWith =>
      __$SkillModelCopyWithImpl<_SkillModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SkillModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SkillModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, key, nameAr, nameEn, description);
  }

  @override
  String toString() {
    return 'SkillModel(id: $id, key: $key, nameAr: $nameAr, nameEn: $nameEn, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$SkillModelCopyWith<$Res>
    implements $SkillModelCopyWith<$Res> {
  factory _$SkillModelCopyWith(
          _SkillModel value, $Res Function(_SkillModel) _then) =
      __$SkillModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String key,
      String nameAr,
      String nameEn,
      String? description});
}

/// @nodoc
class __$SkillModelCopyWithImpl<$Res> implements _$SkillModelCopyWith<$Res> {
  __$SkillModelCopyWithImpl(this._self, this._then);

  final _SkillModel _self;
  final $Res Function(_SkillModel) _then;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? description = freezed,
  }) {
    return _then(_SkillModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _self.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _self.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
