// To parse this JSON data, do
//
//     final getCastCrewModel = getCastCrewModelFromJson(jsonString);

import 'dart:convert';

GetCastCrewModel getCastCrewModelFromJson(String str) => GetCastCrewModel.fromJson(json.decode(str));

String getCastCrewModelToJson(GetCastCrewModel data) => json.encode(data.toJson());

class GetCastCrewModel {
    bool? status;
    String? message;
    List<Datum>? data;

    GetCastCrewModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetCastCrewModel.fromJson(Map<String, dynamic> json) => GetCastCrewModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? profileImg;
    String? name;
    String? description;
    String? role;
    String? movieId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Movie? movie;

    Datum({
        this.id,
        this.profileImg,
        this.name,
        this.description,
        this.role,
        this.movieId,
        this.createdAt,
        this.updatedAt,
        this.movie,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        movieId: json["movie_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
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
        "movie": movie?.toJson(),
    };
}

class Movie {
    String? id;
    String? movieName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    dynamic genreId;
    dynamic movieCategory;
    int? reportCount;
    dynamic videoLink;
    String? movieVideo;
    dynamic trailorVideoLink;
    dynamic trailorVideo;
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
        this.releasedBy,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
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
