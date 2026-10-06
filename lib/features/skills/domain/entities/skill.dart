import 'package:equatable/equatable.dart';

/// A learning skill (e.g. colours, numbers, shapes).
/// Fetched from GET /skills and cached in-session by [SkillsCubit].
class Skill extends Equatable {
  const Skill({
    required this.id,
    required this.key,
    required this.nameAr,
    required this.nameEn,
    this.description,
  });

  final String id;
  final String key;
  final String nameAr;
  final String nameEn;
  final String? description;

  @override
  List<Object?> get props => [id, key, nameAr, nameEn, description];
}
