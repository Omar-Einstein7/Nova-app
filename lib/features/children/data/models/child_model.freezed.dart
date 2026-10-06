// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildSkillModel {
  String get skillId;
  String get key;
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
  SkillLevel get level;

  /// Create a copy of ChildSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChildSkillModelCopyWith<ChildSkillModel> get copyWith =>
      _$ChildSkillModelCopyWithImpl<ChildSkillModel>(
          this as ChildSkillModel, _$identity);

  /// Serializes this ChildSkillModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as ChildSkillModel;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChildSkillModel &&
            (identical(other.skillId, _this.skillId) ||
                other.skillId == _this.skillId) &&
            (identical(other.key, _this.key) || other.key == _this.key) &&
            (identical(other.level, _this.level) ||
                other.level == _this.level));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as ChildSkillModel;
    return Object.hash(runtimeType, _this.skillId, _this.key, _this.level);
  }

  @override
  String toString() {
    final _this = this as ChildSkillModel;
    return 'ChildSkillModel(skillId: ${_this.skillId}, key: ${_this.key}, level: ${_this.level})';
  }
}

/// @nodoc
abstract mixin class $ChildSkillModelCopyWith<$Res> {
  factory $ChildSkillModelCopyWith(
          ChildSkillModel value, $Res Function(ChildSkillModel) _then) =
      _$ChildSkillModelCopyWithImpl;
  @useResult
  $Res call(
      {String skillId,
      String key,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
      SkillLevel level});
}

/// @nodoc
class _$ChildSkillModelCopyWithImpl<$Res>
    implements $ChildSkillModelCopyWith<$Res> {
  _$ChildSkillModelCopyWithImpl(this._self, this._then);

  final ChildSkillModel _self;
  final $Res Function(ChildSkillModel) _then;

  /// Create a copy of ChildSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillId = null,
    Object? key = null,
    Object? level = null,
  }) {
    return _then(ChildSkillModel(
      skillId: null == skillId
          ? _self.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChildSkillModel].
extension ChildSkillModelPatterns on ChildSkillModel {
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
    TResult Function(_ChildSkillModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel() when $default != null:
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
    TResult Function(_ChildSkillModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel():
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
    TResult? Function(_ChildSkillModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel() when $default != null:
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
    TResult Function(
            String skillId,
            String key,
            @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
            SkillLevel level)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel() when $default != null:
        return $default(_that.skillId, _that.key, _that.level);
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
    TResult Function(
            String skillId,
            String key,
            @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
            SkillLevel level)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel():
        return $default(_that.skillId, _that.key, _that.level);
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
    TResult? Function(
            String skillId,
            String key,
            @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
            SkillLevel level)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildSkillModel() when $default != null:
        return $default(_that.skillId, _that.key, _that.level);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChildSkillModel implements ChildSkillModel {
  const _ChildSkillModel(
      {required this.skillId,
      required this.key,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
      required this.level});
  factory _ChildSkillModel.fromJson(Map<String, dynamic> json) =>
      _$ChildSkillModelFromJson(json);

  @override
  final String skillId;
  @override
  final String key;
  @override
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
  final SkillLevel level;

  /// Create a copy of ChildSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChildSkillModelCopyWith<_ChildSkillModel> get copyWith =>
      __$ChildSkillModelCopyWithImpl<_ChildSkillModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChildSkillModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChildSkillModel &&
            (identical(other.skillId, skillId) || other.skillId == skillId) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, skillId, key, level);
  }

  @override
  String toString() {
    return 'ChildSkillModel(skillId: $skillId, key: $key, level: $level)';
  }
}

/// @nodoc
abstract mixin class _$ChildSkillModelCopyWith<$Res>
    implements $ChildSkillModelCopyWith<$Res> {
  factory _$ChildSkillModelCopyWith(
          _ChildSkillModel value, $Res Function(_ChildSkillModel) _then) =
      __$ChildSkillModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String skillId,
      String key,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToString)
      SkillLevel level});
}

/// @nodoc
class __$ChildSkillModelCopyWithImpl<$Res>
    implements _$ChildSkillModelCopyWith<$Res> {
  __$ChildSkillModelCopyWithImpl(this._self, this._then);

  final _ChildSkillModel _self;
  final $Res Function(_ChildSkillModel) _then;

  /// Create a copy of ChildSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? skillId = null,
    Object? key = null,
    Object? level = null,
  }) {
    return _then(_ChildSkillModel(
      skillId: null == skillId
          ? _self.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
    ));
  }
}

/// @nodoc
mixin _$ChildModel {
  String get id;
  String get name;
  int get age;
  List<String> get interests;
  @JsonKey(fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
  LearningStyle get learningStyle;
  List<ChildSkillModel> get skills;
  String? get avatar;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChildModelCopyWith<ChildModel> get copyWith =>
      _$ChildModelCopyWithImpl<ChildModel>(this as ChildModel, _$identity);

  /// Serializes this ChildModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as ChildModel;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChildModel &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.age, _this.age) || other.age == _this.age) &&
            const DeepCollectionEquality()
                .equals(other.interests, _this.interests) &&
            (identical(other.learningStyle, _this.learningStyle) ||
                other.learningStyle == _this.learningStyle) &&
            const DeepCollectionEquality().equals(other.skills, _this.skills) &&
            (identical(other.avatar, _this.avatar) ||
                other.avatar == _this.avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as ChildModel;
    return Object.hash(
        runtimeType,
        _this.id,
        _this.name,
        _this.age,
        const DeepCollectionEquality().hash(_this.interests),
        _this.learningStyle,
        const DeepCollectionEquality().hash(_this.skills),
        _this.avatar);
  }

  @override
  String toString() {
    final _this = this as ChildModel;
    return 'ChildModel(id: ${_this.id}, name: ${_this.name}, age: ${_this.age}, interests: ${_this.interests}, learningStyle: ${_this.learningStyle}, skills: ${_this.skills}, avatar: ${_this.avatar})';
  }
}

/// @nodoc
abstract mixin class $ChildModelCopyWith<$Res> {
  factory $ChildModelCopyWith(
          ChildModel value, $Res Function(ChildModel) _then) =
      _$ChildModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      int age,
      List<String> interests,
      @JsonKey(fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
      LearningStyle learningStyle,
      List<ChildSkillModel> skills,
      String? avatar});
}

/// @nodoc
class _$ChildModelCopyWithImpl<$Res> implements $ChildModelCopyWith<$Res> {
  _$ChildModelCopyWithImpl(this._self, this._then);

  final ChildModel _self;
  final $Res Function(ChildModel) _then;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? interests = null,
    Object? learningStyle = null,
    Object? skills = null,
    Object? avatar = freezed,
  }) {
    return _then(ChildModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      interests: null == interests
          ? _self.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      learningStyle: null == learningStyle
          ? _self.learningStyle
          : learningStyle // ignore: cast_nullable_to_non_nullable
              as LearningStyle,
      skills: null == skills
          ? _self.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<ChildSkillModel>,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChildModel].
extension ChildModelPatterns on ChildModel {
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
    TResult Function(_ChildModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChildModel() when $default != null:
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
    TResult Function(_ChildModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildModel():
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
    TResult? Function(_ChildModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildModel() when $default != null:
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
    TResult Function(
            String id,
            String name,
            int age,
            List<String> interests,
            @JsonKey(
                fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
            LearningStyle learningStyle,
            List<ChildSkillModel> skills,
            String? avatar)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChildModel() when $default != null:
        return $default(_that.id, _that.name, _that.age, _that.interests,
            _that.learningStyle, _that.skills, _that.avatar);
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
    TResult Function(
            String id,
            String name,
            int age,
            List<String> interests,
            @JsonKey(
                fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
            LearningStyle learningStyle,
            List<ChildSkillModel> skills,
            String? avatar)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildModel():
        return $default(_that.id, _that.name, _that.age, _that.interests,
            _that.learningStyle, _that.skills, _that.avatar);
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
    TResult? Function(
            String id,
            String name,
            int age,
            List<String> interests,
            @JsonKey(
                fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
            LearningStyle learningStyle,
            List<ChildSkillModel> skills,
            String? avatar)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChildModel() when $default != null:
        return $default(_that.id, _that.name, _that.age, _that.interests,
            _that.learningStyle, _that.skills, _that.avatar);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChildModel implements ChildModel {
  const _ChildModel(
      {required this.id,
      required this.name,
      required this.age,
      required List<String> interests,
      @JsonKey(fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
      required this.learningStyle,
      List<ChildSkillModel> skills = const [],
      this.avatar})
      : _interests = interests,
        _skills = skills;
  factory _ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int age;
  final List<String> _interests;
  @override
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  @JsonKey(fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
  final LearningStyle learningStyle;
  final List<ChildSkillModel> _skills;
  @override
  @JsonKey()
  List<ChildSkillModel> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final String? avatar;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChildModelCopyWith<_ChildModel> get copyWith =>
      __$ChildModelCopyWithImpl<_ChildModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChildModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChildModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            const DeepCollectionEquality()
                .equals(other.interests, _interests) &&
            (identical(other.learningStyle, learningStyle) ||
                other.learningStyle == learningStyle) &&
            const DeepCollectionEquality().equals(other.skills, _skills) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        id,
        name,
        age,
        const DeepCollectionEquality().hash(_interests),
        learningStyle,
        const DeepCollectionEquality().hash(_skills),
        avatar);
  }

  @override
  String toString() {
    return 'ChildModel(id: $id, name: $name, age: $age, interests: $interests, learningStyle: $learningStyle, skills: $skills, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$ChildModelCopyWith<$Res>
    implements $ChildModelCopyWith<$Res> {
  factory _$ChildModelCopyWith(
          _ChildModel value, $Res Function(_ChildModel) _then) =
      __$ChildModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int age,
      List<String> interests,
      @JsonKey(fromJson: _learningStyleFromJson, toJson: _learningStyleToJson)
      LearningStyle learningStyle,
      List<ChildSkillModel> skills,
      String? avatar});
}

/// @nodoc
class __$ChildModelCopyWithImpl<$Res> implements _$ChildModelCopyWith<$Res> {
  __$ChildModelCopyWithImpl(this._self, this._then);

  final _ChildModel _self;
  final $Res Function(_ChildModel) _then;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? interests = null,
    Object? learningStyle = null,
    Object? skills = null,
    Object? avatar = freezed,
  }) {
    return _then(_ChildModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      interests: null == interests
          ? _self._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      learningStyle: null == learningStyle
          ? _self.learningStyle
          : learningStyle // ignore: cast_nullable_to_non_nullable
              as LearningStyle,
      skills: null == skills
          ? _self._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<ChildSkillModel>,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
