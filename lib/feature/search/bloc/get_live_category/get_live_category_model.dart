// To parse this JSON data, do
//
//     final getLiveCategoryModel = getLiveCategoryModelFromJson(jsonString);

import 'dart:convert';

GetLiveCategoryModel getLiveCategoryModelFromJson(String str) => GetLiveCategoryModel.fromJson(json.decode(str));

String getLiveCategoryModelToJson(GetLiveCategoryModel data) => json.encode(data.toJson());

class GetLiveCategoryModel {
    bool? status;
    String? message;
    Data? data;

    GetLiveCategoryModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetLiveCategoryModel.fromJson(Map<String, dynamic> json) => GetLiveCategoryModel(
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
    List<Category>? categories;

    Data({
        this.total,
        this.page,
        this.totalPages,
        this.categories,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        totalPages: json["totalPages"],
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "totalPages": totalPages,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    };
}

class Category {
    String? id;
    dynamic coverImg;
    String? name;
    bool? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Category({
        this.id,
        this.coverImg,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        coverImg: json["cover_img"],
        name: json["name"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "name": name,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
