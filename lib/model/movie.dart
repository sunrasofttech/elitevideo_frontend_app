import 'package:hive/hive.dart';
import 'package:elite/model/castcrew.dart';
import 'package:elite/model/movieads.dart';
import 'package:elite/model/rating.dart';
import 'genre.dart';
part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
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

  @HiveField(6)
  String? genreId;

  @HiveField(7)
  dynamic movieCategory;

  @HiveField(8)
  dynamic reportCount;

  @HiveField(9)
  dynamic videoLink;

  @HiveField(36)
  dynamic movieVideo;

  @HiveField(10)
  dynamic trailorVideoLink;

  @HiveField(11)
  dynamic trailorVideo;

  @HiveField(12)
  bool? quality;

  @HiveField(13)
  bool? subtitle;

  @HiveField(14)
  String? description;

  @HiveField(15)
  String? movieTime;

  @HiveField(16)
  String? movieRentPrice;

  @HiveField(17)
  bool? isMovieOnRent;

  @HiveField(18)
  bool? isHighlighted;

  @HiveField(19)
  bool? isWatchlist;

  @HiveField(20)
  String? releasedBy;

  @HiveField(21)
  String? releasedDate;

  @HiveField(22)
  DateTime? createdAt;

  @HiveField(23)
  DateTime? updatedAt;

  @HiveField(24)
  Genre? language;

  @HiveField(25)
  Genre? genre;

  @HiveField(26)
  Genre? category;

  @HiveField(27)
  int? continueWatchTime;

  @HiveField(28)
  String? localImagePath;

  @HiveField(29)
  String? localVideoPath;

  @HiveField(30)
  dynamic averageRating;

  @HiveField(31)
  dynamic totalRatings;

  @HiveField(32)
  List<Rating>? ratings;

  @HiveField(33)
  List<CastCrew>? castCrew;

  @HiveField(34)
  List<MovieAds>? movieAd;

  @HiveField(35)
  List<Movie>? recommendedMovies;

  @HiveField(37)
  String? userId;

  Movie({
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
    required this.movieName,
    required this.movieRentPrice,
    required this.movieTime,
    required this.movieVideo,
    required this.posterImg,
    required this.quality,
    required this.releasedBy,
    required this.releasedDate,
    required this.status,
    required this.subtitle,
    required this.trailorVideo,
    required this.trailorVideoLink,
    required this.updatedAt,
    required this.videoLink,
    required this.userId,
    this.continueWatchTime,
    this.localImagePath,
    this.localVideoPath,
    this.averageRating,
    this.castCrew,
    this.movieAd,
    this.ratings,
    this.recommendedMovies,
    this.reportCount,
    this.totalRatings,
  });
}
