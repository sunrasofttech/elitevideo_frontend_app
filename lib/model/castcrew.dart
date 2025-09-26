import 'package:hive/hive.dart';
part 'castcrew.g.dart';

@HiveType(typeId: 1)
class CastCrew extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  dynamic profileImg;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? role;

  @HiveField(5)
  String? movieId;

  CastCrew({
    required this.id,
    required this.profileImg,
    required this.name,
    required this.description,
    required this.role,
    required this.movieId,
  });
}
