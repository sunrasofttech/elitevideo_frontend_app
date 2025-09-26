// To parse this JSON data, do
//
//     final getWatchListModel = getWatchListModelFromJson(jsonString);

import 'dart:convert';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_model.dart';

import '../../../../custom_model/movie_model.dart';
import '../../../../custom_model/short_film_model.dart';

GetWatchListModel getWatchListModelFromJson(String str) => GetWatchListModel.fromJson(json.decode(str));

String getWatchListModelToJson(GetWatchListModel data) => json.encode(data.toJson());

class GetWatchListModel {
  bool? status;
  String? message;
  List<Watchlist>? watchlist;

  GetWatchListModel({
    this.status,
    this.message,
    this.watchlist,
  });

  factory GetWatchListModel.fromJson(Map<String, dynamic> json) => GetWatchListModel(
        status: json["status"],
        message: json["message"],
        watchlist:
            json["watchlist"] == null ? [] : List<Watchlist>.from(json["watchlist"]!.map((x) => Watchlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "watchlist": watchlist == null ? [] : List<dynamic>.from(watchlist!.map((x) => x.toJson())),
      };
}

class Watchlist {
  String? id;
  String? userId;
  String? movieId;
  String? shortfilmId;
  String? seasonEpisodeId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  Movie? movie;
  ShortFilm? shortfilm;
  Episode? seasonEpisode;

  Watchlist({
    this.id,
    this.userId,
    this.movieId,
    this.shortfilmId,
    this.seasonEpisodeId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.movie,
    this.shortfilm,
    this.seasonEpisode,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) => Watchlist(
        id: json["id"],
        userId: json["user_id"],
        movieId: json["movie_id"],
        shortfilmId: json["shortfilm_id"],
        seasonEpisodeId: json["season_episode_id"],
        type: json["type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
        shortfilm: json["shortfilm"] == null ? null : ShortFilm.fromJson(json["shortfilm"]),
        seasonEpisode: json["season_episode"] == null ? null : Episode.fromJson(json["season_episode"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "movie_id": movieId,
        "shortfilm_id": shortfilmId,
        "season_episode_id": seasonEpisodeId,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "movie": movie?.toJson(),
        "shortfilm": shortfilm?.toJson(),
        "season_episode": seasonEpisode?.toJson(),
      };
}
