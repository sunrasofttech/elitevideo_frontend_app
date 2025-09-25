// To parse this JSON data, do
//
//     final getAllMusicModel = getAllMusicModelFromJson(jsonString);

import 'dart:convert';

GetAllMusicModel getAllMusicModelFromJson(String str) => GetAllMusicModel.fromJson(json.decode(str));

String getAllMusicModelToJson(GetAllMusicModel data) => json.encode(data.toJson());

class GetAllMusicModel {
    bool? status;
    String? message;
    List<MusicCategory>? data;
    Pagination? pagination;

    GetAllMusicModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetAllMusicModel.fromJson(Map<String, dynamic> json) => GetAllMusicModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MusicCategory>.from(json["data"]!.map((x) => MusicCategory.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class MusicCategory {
    String? id;
    String? name;
    dynamic coverImg;
    DateTime? createdAt;
    DateTime? updatedAt;

    MusicCategory({
        this.id,
        this.name,
        this.coverImg,
        this.createdAt,
        this.updatedAt,
    });

    factory MusicCategory.fromJson(Map<String, dynamic> json) => MusicCategory(
        id: json["id"],
        name: json["name"],
        coverImg: json["cover_img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover_img": coverImg,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class Pagination {
    int? total;
    int? page;
    int? limit;
    int? totalPages;

    Pagination({
        this.total,
        this.page,
        this.limit,
        this.totalPages,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
    };
}
