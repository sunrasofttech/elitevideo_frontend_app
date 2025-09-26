// To parse this JSON data, do
//
//     final getSeriesModel = getSeriesModelFromJson(jsonString);

import 'dart:convert';

GetSeriesModel getSeriesModelFromJson(String str) => GetSeriesModel.fromJson(json.decode(str));

String getSeriesModelToJson(GetSeriesModel data) => json.encode(data.toJson());

class GetSeriesModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetSeriesModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetSeriesModel.fromJson(Map<String, dynamic> json) => GetSeriesModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Datum {
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
    dynamic seriesRentPrice;
    bool? isSeriesOnRent;
    bool? isHighlighted;
    dynamic rentedTimeDays;
    String? releasedBy;
    DateTime? releasedDate;
    int? reportCount;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? language;
    Category? genre;
    Category? category;
    List<Season>? seasons;
    List<CastCrew>? castCrew;

    Datum({
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
        this.isHighlighted,
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
        this.seasons,
        this.castCrew,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        isHighlighted: json["is_highlighted"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        reportCount: json["report_count"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        seasons: json["seasons"] == null ? [] : List<Season>.from(json["seasons"]!.map((x) => Season.fromJson(x))),
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
        "is_highlighted":isHighlighted,
        "released_date": releasedDate?.toIso8601String(),
        "report_count": reportCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "seasons": seasons == null ? [] : List<dynamic>.from(seasons!.map((x) => x.toJson())),
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

class Pagination {
    int? totalItems;
    int? currentPage;
    int? totalPages;
    int? perPage;

    Pagination({
        this.totalItems,
        this.currentPage,
        this.totalPages,
        this.perPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        perPage: json["perPage"],
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "perPage": perPage,
    };
}
