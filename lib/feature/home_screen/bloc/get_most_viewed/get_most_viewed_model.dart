// To parse this JSON data, do
//
//     final mostViewedModel = mostViewedModelFromJson(jsonString);

import 'dart:convert';

MostViewedModel mostViewedModelFromJson(String str) => MostViewedModel.fromJson(json.decode(str));

String mostViewedModelToJson(MostViewedModel data) => json.encode(data.toJson());

class MostViewedModel {
    bool? status;
    String? message;
    int? currentPage;
    int? totalPages;
    int? totalItems;
    List<Datum>? data;

    MostViewedModel({
        this.status,
        this.message,
        this.currentPage,
        this.totalPages,
        this.totalItems,
        this.data,
    });

    factory MostViewedModel.fromJson(Map<String, dynamic> json) => MostViewedModel(
        status: json["status"],
        message: json["message"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? rank;
    String? id;
    String? movieName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    String? genreId;
    String? movieCategory;
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
    Category? language;
    Category? genre;
    Category? category;

    Datum({
        this.rank,
        this.id,
        this.movieName,
        this.status,
        this.coverImg,
        this.posterImg,
        this.movieLanguage,
        this.genreId,
        this.movieCategory,
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
        this.language,
        this.genre,
        this.category,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rank: json["rank"],
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
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
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "rank": rank,
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
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
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
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
