// To parse this JSON data, do
//
//     final getShortFilmByIdModel = getShortFilmByIdModelFromJson(jsonString);

import 'dart:convert';
import '../../../../custom_model/short_film_model.dart';

GetShortFilmByIdModel getShortFilmByIdModelFromJson(String str) => GetShortFilmByIdModel.fromJson(json.decode(str));

String getShortFilmByIdModelToJson(GetShortFilmByIdModel data) => json.encode(data.toJson());

class GetShortFilmByIdModel {
    bool? status;
    String? message;
    ShortFilm? data;

    GetShortFilmByIdModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetShortFilmByIdModel.fromJson(Map<String, dynamic> json) => GetShortFilmByIdModel(
        status: json["status"],
        message: json["message"],
        data: json["shortfilm"] == null ? null : ShortFilm.fromJson(json["shortfilm"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "shortfilm": data?.toJson(),
    };
}

