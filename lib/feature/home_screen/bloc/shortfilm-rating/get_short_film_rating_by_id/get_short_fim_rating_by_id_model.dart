// To parse this JSON data, do
//
//     final getShortFilmRatingByIdModel = getShortFilmRatingByIdModelFromJson(jsonString);

import 'dart:convert';

GetShortFilmRatingByIdModel getShortFilmRatingByIdModelFromJson(String str) => GetShortFilmRatingByIdModel.fromJson(json.decode(str));

String getShortFilmRatingByIdModelToJson(GetShortFilmRatingByIdModel data) => json.encode(data.toJson());

class GetShortFilmRatingByIdModel {
    bool? status;
    String? averageRating;
    int? totalRatings;
    List<Rating>? ratings;

    GetShortFilmRatingByIdModel({
        this.status,
        this.averageRating,
        this.totalRatings,
        this.ratings,
    });

    factory GetShortFilmRatingByIdModel.fromJson(Map<String, dynamic> json) => GetShortFilmRatingByIdModel(
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
    String? shortFilmId;
    String? userId;
    double? rating;
    DateTime? createdAt;
    DateTime? updatedAt;

    Rating({
        this.id,
        this.shortFilmId,
        this.userId,
        this.rating,
        this.createdAt,
        this.updatedAt,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        shortFilmId: json["short_film_id"],
        userId: json["user_id"],
        rating: json["rating"]?.toDouble(),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "short_film_id": shortFilmId,
        "user_id": userId,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
