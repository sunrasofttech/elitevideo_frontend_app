// To parse this JSON data, do
//
//     final getMovieByIdModel = getMovieByIdModelFromJson(jsonString);

import 'dart:convert';

import '../../../../custom_model/movie_model.dart';

GetMovieByIdModel getMovieByIdModelFromJson(String str) => GetMovieByIdModel.fromJson(json.decode(str));

String getMovieByIdModelToJson(GetMovieByIdModel data) => json.encode(data.toJson());

class GetMovieByIdModel {
    bool? status;
    String? message;
    Movie? movie;

    GetMovieByIdModel({
        this.status,
        this.message,
        this.movie,
    });

    factory GetMovieByIdModel.fromJson(Map<String, dynamic> json) => GetMovieByIdModel(
        status: json["status"],
        message: json["message"],
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "movie": movie?.toJson(),
    };
}

