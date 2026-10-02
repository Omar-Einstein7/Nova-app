import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// Domain entity representing an authenticated parent/user.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String role,
  }) = _User;
}
