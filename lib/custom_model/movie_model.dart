class Movie {
  String? id;
  String? movieName;
  bool? status;
  String? coverImg;
  String? posterImg;
  String? movieLanguage;
  String? genreId;
  String? movieCategory;
  int? reportCount;
  String? videoLink;
  String? movieVideo;
  String? trailorVideoLink;
  String? trailorVideo;
  bool? quality;
  bool? subtitle;
  String? description;
  String? movieTime;
  String? movieRentPrice;
  bool? isMovieOnRent;
  dynamic rentedTimeDays;
  bool? showSubscription;
  bool? isHighlighted;
  bool? isWatchlist;
  int? viewCount;
  String? releasedBy;
  dynamic releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Genre? language;
  Genre? genre;
  Genre? category;
  List<Rating>? ratings;
  List<CastCrew>? castCrew;
  List<MovieAd>? movieAd;
  String? averageRating;
  int? totalRatings;
  List<Movie>? recommendedMovies;

  Movie({
    this.id,
    this.movieName,
    this.status,
    this.coverImg,
    this.posterImg,
    this.movieLanguage,
    this.genreId,
    this.movieCategory,
    this.reportCount,
    this.videoLink,
    this.movieVideo,
    this.trailorVideoLink,
    this.trailorVideo,
    this.quality,
    this.subtitle,
    this.description,
    this.movieTime,
    this.movieRentPrice,
    this.isMovieOnRent,
    this.isHighlighted,
    this.isWatchlist,
    this.viewCount,
    this.showSubscription,
    this.releasedBy,
    this.releasedDate,
    this.rentedTimeDays,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.genre,
    this.category,
    this.ratings,
    this.castCrew,
    this.movieAd,
    this.averageRating,
    this.totalRatings,
    this.recommendedMovies,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        reportCount: json["report_count"],
        videoLink: json["video_link"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        showSubscription: json["show_subscription"],
        movieTime: json["movie_time"],
        rentedTimeDays: json["rented_time_days"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Genre.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Genre.fromJson(json["genre"]),
        category: json["category"] == null ? null : Genre.fromJson(json["category"]),
        ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
        castCrew:
            json["cast_crew"] == null ? [] : List<CastCrew>.from(json["cast_crew"]!.map((x) => CastCrew.fromJson(x))),
        movieAd: json["ads"] == null ? [] : List<MovieAd>.from(json["ads"]!.map((x) => MovieAd.fromJson(x))),
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        recommendedMovies: json["recommended_movies"] == null
            ? []
            : List<Movie>.from(json["recommended_movies"]!.map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "report_count": reportCount,
        "video_link": videoLink,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "rented_time_days": rentedTimeDays,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "show_subscription": showSubscription,
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "cast_crew": castCrew == null ? [] : List<dynamic>.from(castCrew!.map((x) => x.toJson())),
        "movie_ad": movieAd == null ? [] : List<dynamic>.from(movieAd!.map((x) => x.toJson())),
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "recommended_movies":
            recommendedMovies == null ? [] : List<dynamic>.from(recommendedMovies!.map((x) => x.toJson())),
      };
}

class CastCrew {
  String? id;
  String? profileImg;
  String? name;
  String? description;
  String? role;
  String? movieId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CastCrew({
    this.id,
    this.profileImg,
    this.name,
    this.description,
    this.role,
    this.movieId,
    this.createdAt,
    this.updatedAt,
  });

  factory CastCrew.fromJson(Map<String, dynamic> json) => CastCrew(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        movieId: json["movie_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "movie_id": movieId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Genre {
  String? id;
  String? name;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coverImg;

  Genre({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.coverImg,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
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

class MovieAd {
  String? id;
  String? movieId;
  String? videoAdId;
  DateTime? createdAt;
  DateTime? updatedAt;
  MovieAdMovie? movie;
  VideoAd? videoAd;

  MovieAd({
    this.id,
    this.movieId,
    this.videoAdId,
    this.createdAt,
    this.updatedAt,
    this.movie,
    this.videoAd,
  });

  factory MovieAd.fromJson(Map<String, dynamic> json) => MovieAd(
        id: json["id"],
        movieId: json["movie_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_id": movieId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "movie": movie?.toJson(),
        "video_ad": videoAd?.toJson(),
      };
}

class MovieAdMovie {
  String? id;
  String? movieName;
  bool? status;
  String? coverImg;
  String? posterImg;
  String? movieLanguage;
  String? genreId;
  String? movieCategory;
  int? reportCount;
  String? videoLink;
  String? movieVideo;
  String? trailorVideoLink;
  String? trailorVideo;
  bool? quality;
  bool? subtitle;
  String? description;
  String? movieTime;
  String? movieRentPrice;
  bool? isMovieOnRent;
  bool? isHighlighted;
  bool? isWatchlist;
  int? viewCount;
  String? releasedBy;
  DateTime? releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  MovieAdMovie({
    this.id,
    this.movieName,
    this.status,
    this.coverImg,
    this.posterImg,
    this.movieLanguage,
    this.genreId,
    this.movieCategory,
    this.reportCount,
    this.videoLink,
    this.movieVideo,
    this.trailorVideoLink,
    this.trailorVideo,
    this.quality,
    this.subtitle,
    this.description,
    this.movieTime,
    this.movieRentPrice,
    this.isMovieOnRent,
    this.isHighlighted,
    this.isWatchlist,
    this.viewCount,
    this.releasedBy,
    this.releasedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory MovieAdMovie.fromJson(Map<String, dynamic> json) => MovieAdMovie(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        reportCount: json["report_count"],
        videoLink: json["video_link"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "report_count": reportCount,
        "video_link": videoLink,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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

class Rating {
  dynamic rating;
  String? userId;

  Rating({
    this.rating,
    this.userId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "user_id": userId,
      };
}
