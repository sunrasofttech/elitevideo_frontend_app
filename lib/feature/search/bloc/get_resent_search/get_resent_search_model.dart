// To parse this JSON data, do
//
//     final resentSearchModel = resentSearchModelFromJson(jsonString);

import 'dart:convert';

ResentSearchModel resentSearchModelFromJson(String str) => ResentSearchModel.fromJson(json.decode(str));

String resentSearchModelToJson(ResentSearchModel data) => json.encode(data.toJson());

class ResentSearchModel {
    bool? status;
    String? message;
    List<Datum>? data;

    ResentSearchModel({
        this.status,
        this.message,
        this.data,
    });

    factory ResentSearchModel.fromJson(Map<String, dynamic> json) => ResentSearchModel(
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
    String? userId;
    String? type;
    String? typeId;
    DateTime? updatedAt;
    DateTime? createdAt;
    User? user;
    Details? details;

    Datum({
        this.id,
        this.userId,
        this.type,
        this.typeId,
        this.updatedAt,
        this.createdAt,
        this.user,
        this.details,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        typeId: json["type_id"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "type_id": typeId,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "user": user?.toJson(),
        "details": details?.toJson(),
    };
}

class Details {
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
    int? rentedTimeDays;
    String? releasedBy;
    DateTime? releasedDate;
    int? reportCount;
    bool? isHighlighted;
    String? showType;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? shortFilmTitle;
    String? videoLink;
    String? shortVideo;
    bool? quality;
    bool? subtitle;
    String? movieTime;
    String? movieRentPrice;
    bool? isMovieOnRent;
    bool? isWatchlist;
    int? viewCount;
    String? movieName;
    String? movieVideo;
    String? trailorVideoLink;
    dynamic trailorVideo;
    dynamic position;

    Details({
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
        this.shortFilmTitle,
        this.videoLink,
        this.shortVideo,
        this.quality,
        this.subtitle,
        this.movieTime,
        this.movieRentPrice,
        this.isMovieOnRent,
        this.isWatchlist,
        this.viewCount,
        this.movieName,
        this.movieVideo,
        this.trailorVideoLink,
        this.trailorVideo,
        this.position,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
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
        shortFilmTitle: json["short_film_title"],
        videoLink: json["video_link"],
        shortVideo: json["short_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        movieName: json["movie_name"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        position: json["position"],
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
        "short_film_title": shortFilmTitle,
        "video_link": videoLink,
        "short_video": shortVideo,
        "quality": quality,
        "subtitle": subtitle,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "movie_name": movieName,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "position": position,
    };
}

class User {
    String? id;
    String? name;
    String? email;

    User({
        this.id,
        this.name,
        this.email,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
    };
}
