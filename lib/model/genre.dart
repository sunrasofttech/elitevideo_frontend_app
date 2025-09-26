import 'package:hive/hive.dart';

part 'genre.g.dart';

@HiveType(typeId: 2) 
class Genre extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  dynamic coverImg;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? status;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  Genre({
    required this.coverImg,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.status,
  });
}
