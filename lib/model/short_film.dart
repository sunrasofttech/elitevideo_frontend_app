import 'package:hive/hive.dart';
import 'package:elite/model/rating.dart';
import 'genre.dart';
part 'short_film.g.dart';

@HiveType(typeId: 6)
class ShortFilm extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? shortFilmTitle;

  @HiveField(2)
  bool? status;

  @HiveField(3)
  dynamic coverImg;

  @HiveField(4)
  dynamic posterImg;

  @HiveField(5)
  String? movieLanguage;

  @HiveField(6)
  String? genreId;

  @HiveField(7)
  dynamic movieCategory;

  @HiveField(8)
  dynamic videoLink;

  @HiveField(9)
  dynamic shortVideo;

  @HiveField(10)
  dynamic showSubscription;

  @HiveField(11)
  dynamic quality;

  @HiveField(12)
  dynamic subtitle;

  @HiveField(13)
  String? description;

  @HiveField(14)
  String? movieTime;

  @HiveField(15)
  String? movieRentPrice;

  @HiveField(16)
  String? rentedTimeDays;

  @HiveField(17)
  bool? isMovieOnRent;

  @HiveField(18)
  bool? isHighlighted;

  @HiveField(19)
  bool? isWatchlist;

  @HiveField(20)
  dynamic viewCount;

  @HiveField(21)
  String? releasedBy;

  @HiveField(22)
  String? releasedDate;

  @HiveField(23)
  DateTime? createdAt;

  @HiveField(24)
  DateTime? updatedAt;

  @HiveField(25)
  Genre? language;

  @HiveField(26)
  Genre? genre;

  @HiveField(27)
  Genre? category;

  @HiveField(28)
  int? continueWatchTime;

  @HiveField(29)
  String? localImagePath;

  @HiveField(30)
  String? localVideoPath;

  @HiveField(31)
  dynamic averageRating;

  @HiveField(32)
  dynamic totalRatings;

  @HiveField(33)
  List<Rating>? ratings;

  ShortFilm({
    required this.category,
    required this.coverImg,
    required this.createdAt,
    required this.description,
    required this.genre,
    required this.genreId,
    required this.id,
    required this.isHighlighted,
    required this.isMovieOnRent,
    required this.isWatchlist,
    required this.language,
    required this.movieCategory,
    required this.movieLanguage,
    required this.movieRentPrice,
    required this.movieTime,
    required this.posterImg,
    required this.quality,
    required this.releasedBy,
    required this.releasedDate,
    required this.status,
    required this.subtitle,
    required this.updatedAt,
    required this.videoLink,
    this.continueWatchTime,
    this.localImagePath,
    this.localVideoPath,
    this.averageRating,
    this.ratings,
    this.totalRatings,
    this.rentedTimeDays,
    this.shortFilmTitle,
    this.shortVideo,
    this.showSubscription,
    this.viewCount,
  });
}
