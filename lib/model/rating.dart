import 'package:hive/hive.dart';
part 'rating.g.dart';

@HiveType(typeId: 5) 
class Rating extends HiveObject {
  @HiveField(0)
  dynamic rating;

  @HiveField(1)
  dynamic userId;

  Rating({
    required this.rating,
    required this.userId,
  });
}
