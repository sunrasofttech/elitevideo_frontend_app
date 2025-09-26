// To parse this JSON data, do
//
//     final getDataByArtistIdAndLanguageIdModel = getDataByArtistIdAndLanguageIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:elite/feature/music/bloc/get_all_music/get_all_music_model.dart';

GetDataByArtistIdAndLanguageIdModel getDataByArtistIdAndLanguageIdModelFromJson(String str) => GetDataByArtistIdAndLanguageIdModel.fromJson(json.decode(str));

String getDataByArtistIdAndLanguageIdModelToJson(GetDataByArtistIdAndLanguageIdModel data) => json.encode(data.toJson());

class GetDataByArtistIdAndLanguageIdModel {
    bool? status;
    String? message;
    List<MusicModel>? data;

    GetDataByArtistIdAndLanguageIdModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetDataByArtistIdAndLanguageIdModel.fromJson(Map<String, dynamic> json) => GetDataByArtistIdAndLanguageIdModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MusicModel>.from(json["data"]!.map((x) => MusicModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

