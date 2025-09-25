// To parse this JSON data, do
//
//     final getPopularMusicModel = getPopularMusicModelFromJson(jsonString);

import 'dart:convert';

import '../get_all_music/get_all_music_model.dart';

GetPopularMusicModel getPopularMusicModelFromJson(String str) => GetPopularMusicModel.fromJson(json.decode(str));

String getPopularMusicModelToJson(GetPopularMusicModel data) => json.encode(data.toJson());

class GetPopularMusicModel {
    bool? status;
    String? message;
    Data? data;

    GetPopularMusicModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetPopularMusicModel.fromJson(Map<String, dynamic> json) => GetPopularMusicModel(
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
    int? totalItems;
    int? totalPages;
    int? currentPage;
    List<MusicModel>? items;

    Data({
        this.totalItems,
        this.totalPages,
        this.currentPage,
        this.items,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        items: json["items"] == null ? [] : List<MusicModel>.from(json["items"]!.map((x) => MusicModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

