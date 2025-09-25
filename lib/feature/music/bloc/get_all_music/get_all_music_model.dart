// To parse this JSON data, do
//
//     final getMusicModel = getMusicModelFromJson(jsonString);

import 'dart:convert';

GetMusicModel getMusicModelFromJson(String str) => GetMusicModel.fromJson(json.decode(str));

String getMusicModelToJson(GetMusicModel data) => json.encode(data.toJson());

class GetMusicModel {
  bool? status;
  String? message;
  Data? data;

  GetMusicModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetMusicModel.fromJson(Map<String, dynamic> json) => GetMusicModel(
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

class MusicModel {
  String? id;
  String? coverImg;
  String? categoryId;
  String? artistId;
  String? languageId;
  String? songTitle;
  dynamic songUrl;
  String? songFile;
  String? description;
  dynamic watchedCount;
  bool? status;
  bool? isPopular;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;
  Artist? artist;
  Category? language;

  MusicModel({
    this.id,
    this.coverImg,
    this.categoryId,
    this.artistId,
    this.languageId,
    this.songTitle,
    this.songUrl,
    this.songFile,
    this.description,
    this.watchedCount,
    this.status,
    this.isPopular,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.artist,
    this.language,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        id: json["id"],
        coverImg: json["cover_img"],
        categoryId: json["category_id"],
        artistId: json["artist_id"],
        languageId: json["language_id"],
        songTitle: json["song_title"],
        songUrl: json["song_url"],
        songFile: json["song_file"],
        description: json["description"],
        watchedCount: json["watched_count"],
        status: json["status"],
        isPopular: json["is_popular"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        artist: json["artist"] == null ? null : Artist.fromJson(json["artist"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "category_id": categoryId,
        "artist_id": artistId,
        "language_id": languageId,
        "song_title": songTitle,
        "song_url": songUrl,
        "song_file": songFile,
        "description": description,
        "watched_count": watchedCount,
        "status": status,
        "is_popular": isPopular,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
        "artist": artist?.toJson(),
        "language": language?.toJson(),
      };
}

class Artist {
  String? id;
  String? artistName;
  String? profileImg;
  DateTime? createdAt;
  DateTime? updatedAt;

  Artist({
    this.id,
    this.artistName,
    this.profileImg,
    this.createdAt,
    this.updatedAt,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
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

class Category {
  String? id;
  String? name;
  dynamic coverImg;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? status;

  Category({
    this.id,
    this.name,
    this.coverImg,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        coverImg: json["cover_img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover_img": coverImg,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
      };
}
