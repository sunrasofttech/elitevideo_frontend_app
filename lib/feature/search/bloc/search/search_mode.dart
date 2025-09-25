// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

import 'package:elite/custom_model/movie_model.dart';
import 'package:elite/custom_model/short_film_model.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_model.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_model.dart';

import '../../../home_screen/bloc/get_all_episode/get_all_episode_model.dart';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  bool? status;
  String? message;
  Data? data;

  SearchModel({
    this.status,
    this.message,
    this.data,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
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
  List<Movie>? movies;
  List<ShortFilm>? shortfilms;
  List<WebSeries>? series;
  List<WebSeries>? tvshows;
  List<Episode>? seasonepisode;
  List<Season>? season;
  List<Channel>? livechannel;

  Data({
    this.movies,
    this.shortfilms,
    this.series,
    this.tvshows,
    this.seasonepisode,
    this.season,
    this.livechannel,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        movies: json["movies"] == null ? [] : List<Movie>.from(json["movies"]!.map((x) => Movie.fromJson(x))),
        shortfilms: json["shortfilms"] == null
            ? []
            : List<ShortFilm>.from(json["shortfilms"]!.map((x) => ShortFilm.fromJson(x))),
        series: json["series"] == null ? [] : List<WebSeries>.from(json["series"]!.map((x) => WebSeries.fromJson(x))),
        tvshows:
            json["tvshows"] == null ? [] : List<WebSeries>.from(json["tvshows"]!.map((x) => WebSeries.fromJson(x))),
        seasonepisode: json["seasonepisode"] == null
            ? []
            : List<Episode>.from(json["seasonepisode"]!.map((x) => Episode.fromJson(x))),
        season: json["season"] == null ? [] : List<Season>.from(json["season"]!.map((x) => Season.fromJson(x))),
        livechannel:
            json["livechannel"] == null ? [] : List<Channel>.from(json["livechannel"]!.map((x) => Channel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "movies": movies == null ? [] : List<dynamic>.from(movies!.map((x) => x.toJson())),
        "shortfilms": shortfilms == null ? [] : List<dynamic>.from(shortfilms!.map((x) => x.toJson())),
        "series": series == null ? [] : List<dynamic>.from(series!.map((x) => x.toJson())),
        "tvshows": tvshows == null ? [] : List<dynamic>.from(tvshows!.map((x) => x.toJson())),
        "seasonepisode": seasonepisode == null ? [] : List<dynamic>.from(seasonepisode!.map((x) => x.toJson())),
        "season": season == null ? [] : List<dynamic>.from(season!.map((x) => x.toJson())),
        "livechannel": livechannel == null ? [] : List<dynamic>.from(livechannel!.map((x) => x.toJson())),
      };
}
