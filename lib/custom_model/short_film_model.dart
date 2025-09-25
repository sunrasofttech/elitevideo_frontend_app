import 'package:elite/custom_model/movie_model.dart';

class ShortFilm {
  String? id;
  String? shortFilmTitle;
  bool? status;
  String? coverImg;
  String? posterImg;
  String? movieLanguage;
  String? genreId;
  String? movieCategory;
  String? videoLink;
  String? shortVideo;
  bool? quality;
  bool? subtitle;
  String? description;
  String? movieTime;
  String? movieRentPrice;
  int? rentedTimeDays;
  bool? showSubscription;
  bool? isMovieOnRent;
  bool? isHighlighted;
  bool? isWatchlist;
  int? viewCount;
  String? releasedBy;
  int? reportCount;
  String? releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? language;
  Category? genre;
  Category? category;
  List<Rating>? ratings;
  String? averageRating;
  int? totalRatings;
  List<MovieAd>? shortfilmAds;
  List<CastCrew>? castCrew;

  ShortFilm({
    this.id,
    this.shortFilmTitle,
    this.status,
    this.coverImg,
    this.posterImg,
    this.movieLanguage,
    this.genreId,
    this.movieCategory,
    this.videoLink,
    this.shortVideo,
    this.quality,
    this.subtitle,
    this.description,
    this.movieTime,
    this.movieRentPrice,
    this.rentedTimeDays,
    this.showSubscription,
    this.isMovieOnRent,
    this.isHighlighted,
    this.isWatchlist,
    this.viewCount,
    this.releasedBy,
    this.reportCount,
    this.releasedDate,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.genre,
    this.category,
    this.ratings,
    this.averageRating,
    this.totalRatings,
    this.shortfilmAds,
    this.castCrew,
  });

  factory ShortFilm.fromJson(Map<String, dynamic> json) => ShortFilm(
        id: json["id"],
        shortFilmTitle: json["short_film_title"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        videoLink: json["video_link"],
        shortVideo: json["short_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        rentedTimeDays: json["rented_time_days"],
        showSubscription: json["show_subscription"],
        isMovieOnRent: json["is_movie_on_rent"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        reportCount: json["report_count"],
        releasedDate: json["released_date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        shortfilmAds: json["ads"] == null ? [] : List<MovieAd>.from(json["ads"]!.map((x) => MovieAd.fromJson(x))),
        castCrew:
            json["cast_crew"] == null ? [] : List<CastCrew>.from(json["cast_crew"]!.map((x) => CastCrew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "short_film_title": shortFilmTitle,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "video_link": videoLink,
        "short_video": shortVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "rented_time_days": rentedTimeDays,
        "show_subscription": showSubscription,
        "is_movie_on_rent": isMovieOnRent,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "report_count": reportCount,
        "released_date": releasedDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "shortfilm_ads": shortfilmAds == null ? [] : List<dynamic>.from(shortfilmAds!.map((x) => x.toJson())),
        "cast_crew": castCrew == null ? [] : List<dynamic>.from(castCrew!.map((x) => x.toJson())),
      };
}

class VideoAd {
  String? id;
  String? adVideo;
  dynamic adUrl;
  String? videoTime;
  String? skipTime;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  VideoAd({
    this.id,
    this.adVideo,
    this.adUrl,
    this.videoTime,
    this.skipTime,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory VideoAd.fromJson(Map<String, dynamic> json) => VideoAd(
        id: json["id"],
        adVideo: json["ad_video"],
        adUrl: json["ad_url"],
        videoTime: json["video_time"],
        skipTime: json["skip_time"],
        title: json["title"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_video": adVideo,
        "ad_url": adUrl,
        "video_time": videoTime,
        "skip_time": skipTime,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class CastCrew {
  String? id;
  String? profileImg;
  String? name;
  String? description;
  String? role;
  String? shortfilmId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CastCrew({
    this.id,
    this.profileImg,
    this.name,
    this.description,
    this.role,
    this.shortfilmId,
    this.createdAt,
    this.updatedAt,
  });

  factory CastCrew.fromJson(Map<String, dynamic> json) => CastCrew(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        shortfilmId: json["shortfilm_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "shortfilm_id": shortfilmId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Category {
  String? id;
  String? name;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coverImg;

  Category({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.coverImg,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        coverImg: json["cover_img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "cover_img": coverImg,
      };
}

class Rating {
  double? rating;
  String? userId;

  Rating({
    this.rating,
    this.userId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"]?.toDouble(),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "user_id": userId,
      };
}
