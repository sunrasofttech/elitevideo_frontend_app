// To parse this JSON data, do
//
//     final getRatingInfoModel = getRatingInfoModelFromJson(jsonString);

import 'dart:convert';

GetRatingInfoModel getRatingInfoModelFromJson(String str) => GetRatingInfoModel.fromJson(json.decode(str));

String getRatingInfoModelToJson(GetRatingInfoModel data) => json.encode(data.toJson());

class GetRatingInfoModel {
  bool? status;
  String? averageRating;
  int? totalRatings;
  List<Rating>? ratings;

  GetRatingInfoModel({
    this.status,
    this.averageRating,
    this.totalRatings,
    this.ratings,
  });

  factory GetRatingInfoModel.fromJson(Map<String, dynamic> json) => GetRatingInfoModel(
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
  String? movieId;
  String? userId;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;

  Rating({
    this.id,
    this.movieId,
    this.userId,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        movieId: json["movie_id"],
        userId: json["user_id"],
        rating: json["rating"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_id": movieId,
        "user_id": userId,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
