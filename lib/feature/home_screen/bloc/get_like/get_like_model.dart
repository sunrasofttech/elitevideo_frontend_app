// To parse this JSON data, do
//
//     final getLikedModel = getLikedModelFromJson(jsonString);

import 'dart:convert';

GetLikedModel getLikedModelFromJson(String str) => GetLikedModel.fromJson(json.decode(str));

String getLikedModelToJson(GetLikedModel data) => json.encode(data.toJson());

class GetLikedModel {
    bool? status;
    String? message;
    Data? data;

    GetLikedModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetLikedModel.fromJson(Map<String, dynamic> json) => GetLikedModel(
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
    String? userId;
    String? movieId;
    dynamic shortfilmId;
    dynamic seasonEpisodeId;
    String? type;
    bool? liked;
    bool? disliked;
    DateTime? createdAt;
    DateTime? updatedAt;

    Data({
        this.id,
        this.userId,
        this.movieId,
        this.shortfilmId,
        this.seasonEpisodeId,
        this.type,
        this.liked,
        this.disliked,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        movieId: json["movie_id"],
        shortfilmId: json["shortfilm_id"],
        seasonEpisodeId: json["season_episode_id"],
        type: json["type"],
        liked: json["liked"],
        disliked: json["disliked"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "movie_id": movieId,
        "shortfilm_id": shortfilmId,
        "season_episode_id": seasonEpisodeId,
        "type": type,
        "liked": liked,
        "disliked": disliked,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
