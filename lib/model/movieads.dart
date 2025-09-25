import 'package:hive/hive.dart';
part 'movieads.g.dart';

@HiveType(typeId: 4)
class MovieAds extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? movieName;

  @HiveField(2)
  bool? status;

  @HiveField(3)
  dynamic coverImg;

  @HiveField(4)
  dynamic posterImg;

  @HiveField(5)
  String? movieLanguage;

 

  MovieAds({
    required this.coverImg,
    required this.movieLanguage,
    required this.movieName,
    required this.posterImg,
    required this.status,
  });
}