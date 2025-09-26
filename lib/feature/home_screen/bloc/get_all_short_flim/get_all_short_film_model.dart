// To parse this JSON data, do
//
//     final getAllShortFilmModel = getAllShortFilmModelFromJson(jsonString);

import 'dart:convert';
import '../../../../custom_model/short_film_model.dart';

GetAllShortFilmModel getAllShortFilmModelFromJson(String str) => GetAllShortFilmModel.fromJson(json.decode(str));

String getAllShortFilmModelToJson(GetAllShortFilmModel data) => json.encode(data.toJson());

class GetAllShortFilmModel {
  bool? status;
  String? message;
  List<ShortFilm>? data;
  Pagination? pagination;

  GetAllShortFilmModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetAllShortFilmModel.fromJson(Map<String, dynamic> json) => GetAllShortFilmModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ShortFilm>.from(json["data"]!.map((x) => ShortFilm.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}
