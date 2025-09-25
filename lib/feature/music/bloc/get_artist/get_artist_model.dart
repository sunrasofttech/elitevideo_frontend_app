// To parse this JSON data, do
//
//     final getAllArtistModel = getAllArtistModelFromJson(jsonString);

import 'dart:convert';

GetAllArtistModel getAllArtistModelFromJson(String str) => GetAllArtistModel.fromJson(json.decode(str));

String getAllArtistModelToJson(GetAllArtistModel data) => json.encode(data.toJson());

class GetAllArtistModel {
    bool? status;
    String? message;
    List<Datum>? data;

    GetAllArtistModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllArtistModel.fromJson(Map<String, dynamic> json) => GetAllArtistModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? artistName;
    String? profileImg;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.artistName,
        this.profileImg,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        artistName: json["artist_name"],
        profileImg: json["profile_img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "artist_name": artistName,
        "profile_img": profileImg,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
