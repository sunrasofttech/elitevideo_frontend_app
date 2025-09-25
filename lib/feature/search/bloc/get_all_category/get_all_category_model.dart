// To parse this JSON data, do
//
//     final getAllMovieCategoryModel = getAllMovieCategoryModelFromJson(jsonString);

import 'dart:convert';

GetAllMovieCategoryModel getAllMovieCategoryModelFromJson(String str) =>
    GetAllMovieCategoryModel.fromJson(json.decode(str));

String getAllMovieCategoryModelToJson(GetAllMovieCategoryModel data) => json.encode(data.toJson());

class GetAllMovieCategoryModel {
  bool? status;
  String? message;
  int? totalItems;
  int? totalPages;
  int? currentPage;
  List<Category>? categories;

  GetAllMovieCategoryModel({
    this.status,
    this.message,
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.categories,
  });

  factory GetAllMovieCategoryModel.fromJson(Map<String, dynamic> json) => GetAllMovieCategoryModel(
        status: json["status"],
        message: json["message"],
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        categories:
            json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  String? id;
  String? name;
  String? img;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.img,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        img: json["img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "img": img,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
