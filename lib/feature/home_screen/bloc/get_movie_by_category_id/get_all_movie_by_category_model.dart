// To parse this JSON data, do
//
//     final getAllMoviesModel = getAllMoviesModelFromJson(jsonString);

import 'dart:convert';

import '../../../../custom_model/movie_model.dart';


GetAllMoviesModel getAllMoviesModelFromJson(String str) => GetAllMoviesModel.fromJson(json.decode(str));

String getAllMoviesModelToJson(GetAllMoviesModel data) => json.encode(data.toJson());

class GetAllMoviesModel {
  bool? status;
  String? message;
  Data? data;

  GetAllMoviesModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllMoviesModel.fromJson(Map<String, dynamic> json) => GetAllMoviesModel(
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
  List<Movie>? movies;

  Data({
    this.total,
    this.page,
    this.totalPages,
    this.movies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        totalPages: json["totalPages"],
        movies: json["movies"] == null ? [] : List<Movie>.from(json["movies"]!.map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "totalPages": totalPages,
        "movies": movies == null ? [] : List<dynamic>.from(movies!.map((x) => x.toJson())),
      };
}
