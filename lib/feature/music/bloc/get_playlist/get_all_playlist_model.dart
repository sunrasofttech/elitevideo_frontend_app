// To parse this JSON data, do
//
//     final getPlaylistModel = getPlaylistModelFromJson(jsonString);

import 'dart:convert';

import '../get_all_music/get_all_music_model.dart';

GetPlaylistModel getPlaylistModelFromJson(String str) => GetPlaylistModel.fromJson(json.decode(str));

String getPlaylistModelToJson(GetPlaylistModel data) => json.encode(data.toJson());

class GetPlaylistModel {
    bool? status;
    String? message;
    List<Playlist>? playlists;

    GetPlaylistModel({
        this.status,
        this.message,
        this.playlists,
    });

    factory GetPlaylistModel.fromJson(Map<String, dynamic> json) => GetPlaylistModel(
        status: json["status"],
        message: json["message"],
        playlists: json["playlists"] == null ? [] : List<Playlist>.from(json["playlists"]!.map((x) => Playlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "playlists": playlists == null ? [] : List<dynamic>.from(playlists!.map((x) => x.toJson())),
    };
}

class Playlist {
    String? id;
    String? userId;
    String? name;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<MusicModel>? songs;

    Playlist({
        this.id,
        this.userId,
        this.name,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.songs,
    });

    factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        songs: json["songs"] == null ? [] : List<MusicModel>.from(json["songs"]!.map((x) => MusicModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "songs": songs == null ? [] : List<dynamic>.from(songs!.map((x) => x.toJson())),
    };
}

class PlaylistSong {
    String? playlistId;
    String? songId;

    PlaylistSong({
        this.playlistId,
        this.songId,
    });

    factory PlaylistSong.fromJson(Map<String, dynamic> json) => PlaylistSong(
        playlistId: json["playlist_id"],
        songId: json["song_id"],
    );

    Map<String, dynamic> toJson() => {
        "playlist_id": playlistId,
        "song_id": songId,
    };
}
