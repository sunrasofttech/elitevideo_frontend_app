// To parse this JSON data, do
//
//     final getWebseriesByModelModel = getWebseriesByModelModelFromJson(jsonString);

import 'dart:convert';

GetWebseriesByModelModel getWebseriesByModelModelFromJson(String str) => GetWebseriesByModelModel.fromJson(json.decode(str));

String getWebseriesByModelModelToJson(GetWebseriesByModelModel data) => json.encode(data.toJson());

class GetWebseriesByModelModel {
    bool? status;
    String? message;
    Data? data;

    GetWebseriesByModelModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetWebseriesByModelModel.fromJson(Map<String, dynamic> json) => GetWebseriesByModelModel(
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
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? language;
    Category? genre;
    Category? category;
    List<Season>? season;
    List<CastCrew>? castCrew;

    Data({
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
        this.createdAt,
        this.updatedAt,
        this.language,
        this.genre,
        this.category,
        this.season,
        this.castCrew,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        season: json["season"] == null ? [] : List<Season>.from(json["season"]!.map((x) => Season.fromJson(x))),
        castCrew: json["cast_crew"] == null ? [] : List<CastCrew>.from(json["cast_crew"]!.map((x) => CastCrew.fromJson(x))),
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "season": season == null ? [] : List<dynamic>.from(season!.map((x) => x.toJson())),
        "cast_crew": castCrew == null ? [] : List<dynamic>.from(castCrew!.map((x) => x.toJson())),
    };
}

class CastCrew {
    String? id;
    String? profileImg;
    String? name;
    String? description;
    String? role;
    String? seriesId;
    DateTime? createdAt;
    DateTime? updatedAt;

    CastCrew({
        this.id,
        this.profileImg,
        this.name,
        this.description,
        this.role,
        this.seriesId,
        this.createdAt,
        this.updatedAt,
    });

    factory CastCrew.fromJson(Map<String, dynamic> json) => CastCrew(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        seriesId: json["series_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "series_id": seriesId,
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

class Season {
    String? id;
    String? seasonName;
    bool? status;
    String? seriesId;
    DateTime? releasedDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    Season({
        this.id,
        this.seasonName,
        this.status,
        this.seriesId,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
    });

    factory Season.fromJson(Map<String, dynamic> json) => Season(
        id: json["id"],
        seasonName: json["season_name"],
        status: json["status"],
        seriesId: json["series_id"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "season_name": seasonName,
        "status": status,
        "series_id": seriesId,
        "released_date": releasedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
