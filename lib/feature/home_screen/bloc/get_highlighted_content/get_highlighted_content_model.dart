// To parse this JSON data, do
//
//     final getHighlightedContentModel = getHighlightedContentModelFromJson(jsonString);

import 'dart:convert';

GetHighlightedContentModel getHighlightedContentModelFromJson(String str) => GetHighlightedContentModel.fromJson(json.decode(str));

String getHighlightedContentModelToJson(GetHighlightedContentModel data) => json.encode(data.toJson());

class GetHighlightedContentModel {
    bool? status;
    String? message;
    Data? data;

    GetHighlightedContentModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetHighlightedContentModel.fromJson(Map<String, dynamic> json) => GetHighlightedContentModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    List<Movie>? movies;
    List<ShortFilm>? shortFilms;
    List<Series>? series;

    Data({
        this.movies,
        this.shortFilms,
        this.series,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        movies: json["movies"] == null ? [] : List<Movie>.from(json["movies"]!.map((x) => Movie.fromJson(x))),
        shortFilms: json["shortFilms"] == null ? [] : List<ShortFilm>.from(json["shortFilms"]!.map((x) => ShortFilm.fromJson(x))),
        series: json["series"] == null ? [] : List<Series>.from(json["series"]!.map((x) => Series.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "movies": movies == null ? [] : List<dynamic>.from(movies!.map((x) => x.toJson())),
        "shortFilms": shortFilms == null ? [] : List<dynamic>.from(shortFilms!.map((x) => x.toJson())),
        "series": series == null ? [] : List<dynamic>.from(series!.map((x) => x.toJson())),
    };
}

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
    dynamic trailorVideo;
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
    DateTime? releasedDate;
    dynamic position;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? language;
    Category? genre;
    Category? category;
    List<Rating>? ratings;
    List<dynamic>? castCrew;
    List<Ad>? ads;
    String? averageRating;
    int? totalRatings;
    List<ShortFilm>? recommendedMovies;

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
        this.rentedTimeDays,
        this.showSubscription,
        this.isHighlighted,
        this.isWatchlist,
        this.viewCount,
        this.releasedBy,
        this.releasedDate,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.language,
        this.genre,
        this.category,
        this.ratings,
        this.castCrew,
        this.ads,
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
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        rentedTimeDays: json["rented_time_days"],
        showSubscription: json["show_subscription"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        position: json["position"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
        castCrew: json["cast_crew"] == null ? [] : List<dynamic>.from(json["cast_crew"]!.map((x) => x)),
        ads: json["ads"] == null ? [] : List<Ad>.from(json["ads"]!.map((x) => Ad.fromJson(x))),
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        recommendedMovies: json["recommended_movies"] == null ? [] : List<ShortFilm>.from(json["recommended_movies"]!.map((x) => ShortFilm.fromJson(x))),
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
        "rented_time_days": rentedTimeDays,
        "show_subscription": showSubscription,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "position": position,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "cast_crew": castCrew == null ? [] : List<dynamic>.from(castCrew!.map((x) => x)),
        "ads": ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "recommended_movies": recommendedMovies == null ? [] : List<dynamic>.from(recommendedMovies!.map((x) => x.toJson())),
    };
}

class Ad {
    String? id;
    String? movieId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    VideoAd? videoAd;

    Ad({
        this.id,
        this.movieId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.videoAd,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
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
        "video_ad": videoAd?.toJson(),
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

class Category {
    String? id;
    String? name;
    bool? status;
    String? img;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? coverImg;

    Category({
        this.id,
        this.name,
        this.status,
        this.img,
        this.createdAt,
        this.updatedAt,
        this.coverImg,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        img: json["img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        coverImg: json["cover_img"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "img": img,
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

class ShortFilm {
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
    dynamic trailorVideo;
    bool? quality;
    bool? subtitle;
    String? description;
    String? movieTime;
    String? movieRentPrice;
    bool? isMovieOnRent;
    int? rentedTimeDays;
    bool? showSubscription;
    bool? isHighlighted;
    bool? isWatchlist;
    int? viewCount;
    String? releasedBy;
    DateTime? releasedDate;
    int? position;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? language;
    Category? genre;
    Category? category;
    String? shortFilmTitle;
    String? shortVideo;

    ShortFilm({
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
        this.rentedTimeDays,
        this.showSubscription,
        this.isHighlighted,
        this.isWatchlist,
        this.viewCount,
        this.releasedBy,
        this.releasedDate,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.language,
        this.genre,
        this.category,
        this.shortFilmTitle,
        this.shortVideo,
    });

    factory ShortFilm.fromJson(Map<String, dynamic> json) => ShortFilm(
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
        rentedTimeDays: json["rented_time_days"],
        showSubscription: json["show_subscription"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        position: json["position"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        shortFilmTitle: json["short_film_title"],
        shortVideo: json["short_video"],
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
        "rented_time_days": rentedTimeDays,
        "show_subscription": showSubscription,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "position": position,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "short_film_title": shortFilmTitle,
        "short_video": shortVideo,
    };
}

class Series {
    String? id;
    String? seriesName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    String? genreId;
    String? movieCategory;
    String? description;
    bool? showSubscription;
    String? seriesRentPrice;
    bool? isSeriesOnRent;
    dynamic rentedTimeDays;
    String? releasedBy;
    DateTime? releasedDate;
    int? reportCount;
    bool? isHighlighted;
    String? showType;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? language;
    Category? genre;
    Category? category;

    Series({
        this.id,
        this.seriesName,
        this.status,
        this.coverImg,
        this.posterImg,
        this.movieLanguage,
        this.genreId,
        this.movieCategory,
        this.description,
        this.showSubscription,
        this.seriesRentPrice,
        this.isSeriesOnRent,
        this.rentedTimeDays,
        this.releasedBy,
        this.releasedDate,
        this.reportCount,
        this.isHighlighted,
        this.showType,
        this.createdAt,
        this.updatedAt,
        this.language,
        this.genre,
        this.category,
    });

    factory Series.fromJson(Map<String, dynamic> json) => Series(
        id: json["id"],
        seriesName: json["series_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        description: json["description"],
        showSubscription: json["show_subscription"],
        seriesRentPrice: json["series_rent_price"],
        isSeriesOnRent: json["is_series_on_rent"],
        rentedTimeDays: json["rented_time_days"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        reportCount: json["report_count"],
        isHighlighted: json["is_highlighted"],
        showType: json["show_type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "series_name": seriesName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "description": description,
        "show_subscription": showSubscription,
        "series_rent_price": seriesRentPrice,
        "is_series_on_rent": isSeriesOnRent,
        "rented_time_days": rentedTimeDays,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "report_count": reportCount,
        "is_highlighted": isHighlighted,
        "show_type": showType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
    };
}
