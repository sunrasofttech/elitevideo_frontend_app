// To parse this JSON data, do
//
//     final getSeriesRatingByIdModel = getSeriesRatingByIdModelFromJson(jsonString);

import 'dart:convert';

GetSeriesRatingByIdModel getSeriesRatingByIdModelFromJson(String str) => GetSeriesRatingByIdModel.fromJson(json.decode(str));

String getSeriesRatingByIdModelToJson(GetSeriesRatingByIdModel data) => json.encode(data.toJson());

class GetSeriesRatingByIdModel {
    bool? status;
    String? averageRating;
    int? totalRatings;
    List<Rating>? ratings;

    GetSeriesRatingByIdModel({
        this.status,
        this.averageRating,
        this.totalRatings,
        this.ratings,
    });

    factory GetSeriesRatingByIdModel.fromJson(Map<String, dynamic> json) => GetSeriesRatingByIdModel(
        status: json["status"],
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
    };
}

class Rating {
    String? id;
    String? seriesId;
    String? userId;
    int? rating;
    DateTime? createdAt;
    DateTime? updatedAt;

    Rating({
        this.id,
        this.seriesId,
        this.userId,
        this.rating,
        this.createdAt,
        this.updatedAt,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        seriesId: json["series_id"],
        userId: json["user_id"],
        rating: json["rating"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "series_id": seriesId,
        "user_id": userId,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
