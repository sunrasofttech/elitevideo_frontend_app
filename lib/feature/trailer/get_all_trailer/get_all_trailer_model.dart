// To parse this JSON data, do
//
//     final getAllTrailorsModel = getAllTrailorsModelFromJson(jsonString);

import 'dart:convert';

GetAllTrailorsModel getAllTrailorsModelFromJson(String str) => GetAllTrailorsModel.fromJson(json.decode(str));

String getAllTrailorsModelToJson(GetAllTrailorsModel data) => json.encode(data.toJson());

class GetAllTrailorsModel {
    bool? status;
    String? message;
    Data? data;

    GetAllTrailorsModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllTrailorsModel.fromJson(Map<String, dynamic> json) => GetAllTrailorsModel(
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
    int? total;
    int? page;
    int? totalPages;
    List<Trailor>? trailors;

    Data({
        this.total,
        this.page,
        this.totalPages,
        this.trailors,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        totalPages: json["totalPages"],
        trailors: json["trailors"] == null ? [] : List<Trailor>.from(json["trailors"]!.map((x) => Trailor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "totalPages": totalPages,
        "trailors": trailors == null ? [] : List<dynamic>.from(trailors!.map((x) => x.toJson())),
    };
}

class Trailor {
    String? id;
    String? movieName;
    bool? status;
    String? coverImg;
    String? posterImg;
    dynamic movieLanguage;
    dynamic movieCategory;
    int? reportCount;
    dynamic trailorVideoLink;
    dynamic trailorVideo;
    bool? quality;
    bool? subtitle;
    String? description;
    dynamic movieTime;
    dynamic movieRentPrice;
    bool? isMovieOnRent;
    dynamic rentedTimeDays;
    bool? showSubscription;
    int? viewCount;
    dynamic releasedBy;
    dynamic releasedDate;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic language;
    dynamic category;

    Trailor({
        this.id,
        this.movieName,
        this.status,
        this.coverImg,
        this.posterImg,
        this.movieLanguage,
        this.movieCategory,
        this.reportCount,
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
        this.viewCount,
        this.releasedBy,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
        this.language,
        this.category,
    });

    factory Trailor.fromJson(Map<String, dynamic> json) => Trailor(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        movieCategory: json["movie_category"],
        reportCount: json["report_count"],
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
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "movie_category": movieCategory,
        "report_count": reportCount,
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
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language,
        "category": category,
    };
}
