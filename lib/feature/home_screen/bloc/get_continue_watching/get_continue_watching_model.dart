// To parse this JSON data, do
//
//     final continueWatchingModel = continueWatchingModelFromJson(jsonString);

import 'dart:convert';

import 'package:elite/custom_model/movie_model.dart';

ContinueWatchingModel continueWatchingModelFromJson(String str) => ContinueWatchingModel.fromJson(json.decode(str));

String continueWatchingModelToJson(ContinueWatchingModel data) => json.encode(data.toJson());

class ContinueWatchingModel {
    bool? status;
    String? message;
    List<Datum>? data;

    ContinueWatchingModel({
        this.status,
        this.message,
        this.data,
    });

    factory ContinueWatchingModel.fromJson(Map<String, dynamic> json) => ContinueWatchingModel(
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
    String? userId;
    String? type;
    String? typeId;
    int? currentTime;
    bool? isWatched;
    DateTime? updatedAt;
    DateTime? createdAt;
    Content? content;
    List<Ad>? ads;

    Datum({
        this.id,
        this.userId,
        this.type,
        this.typeId,
        this.currentTime,
        this.isWatched,
        this.updatedAt,
        this.createdAt,
        this.content,
        this.ads,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        typeId: json["type_id"],
        currentTime: json["current_time"],
        isWatched: json["is_watched"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        content: json["content"] == null ? null : Content.fromJson(json["content"]),
        ads: json["ads"] == null ? [] : List<Ad>.from(json["ads"]!.map((x) => Ad.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "type_id": typeId,
        "current_time": currentTime,
        "is_watched": isWatched,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "content": content?.toJson(),
        "ads": ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
    };
}

class Ad {
    String? id;
    String? seasonEpisodeId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    VideoAd? videoAd;
    String? shortfilmId;
    String? movieId;

    Ad({
        this.id,
        this.seasonEpisodeId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.videoAd,
        this.shortfilmId,
        this.movieId,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        seasonEpisodeId: json["season_episode_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
        shortfilmId: json["shortfilm_id"],
        movieId: json["movie_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "season_episode_id": seasonEpisodeId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "video_ad": videoAd?.toJson(),
        "shortfilm_id": shortfilmId,
        "movie_id": movieId,
    };
}

// class VideoAd {
//     String? id;
//     String? adVideo;
//     dynamic adUrl;
//     String? videoTime;
//     String? skipTime;
//     String? title;
//     DateTime? createdAt;
//     DateTime? updatedAt;

//     VideoAd({
//         this.id,
//         this.adVideo,
//         this.adUrl,
//         this.videoTime,
//         this.skipTime,
//         this.title,
//         this.createdAt,
//         this.updatedAt,
//     });

//     factory VideoAd.fromJson(Map<String, dynamic> json) => VideoAd(
//         id: json["id"],
//         adVideo: json["ad_video"],
//         adUrl: json["ad_url"],
//         videoTime: json["video_time"],
//         skipTime: json["skip_time"],
//         title: json["title"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "ad_video": adVideo,
//         "ad_url": adUrl,
//         "video_time": videoTime,
//         "skip_time": skipTime,
//         "title": title,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//     };
// }

class Content {
    String? id;
    String? coverImg;
    bool? status;
    String? seriesId;
    String? seasonId;
    String? episodeName;
    String? episodeNo;
    String? videoLink;
    String? video;
    DateTime? releasedDate;
    String? movieTime;
    String? movieRentPrice;
    bool? isMovieOnRent;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? shortFilmTitle;
    String? posterImg;
    String? movieLanguage;
    String? genreId;
    String? movieCategory;
    String? shortVideo;
    bool? quality;
    bool? subtitle;
    String? description;
    int? rentedTimeDays;
    bool? showSubscription;
    bool? isHighlighted;
    bool? isWatchlist;
    int? viewCount;
    String? releasedBy;
    int? reportCount;
    String? movieName;
    String? movieVideo;
    String? trailorVideoLink;
    String? trailorVideo;

    Content({
        this.id,
        this.coverImg,
        this.status,
        this.seriesId,
        this.seasonId,
        this.episodeName,
        this.episodeNo,
        this.videoLink,
        this.video,
        this.releasedDate,
        this.movieTime,
        this.movieRentPrice,
        this.isMovieOnRent,
        this.createdAt,
        this.updatedAt,
        this.shortFilmTitle,
        this.posterImg,
        this.movieLanguage,
        this.genreId,
        this.movieCategory,
        this.shortVideo,
        this.quality,
        this.subtitle,
        this.description,
        this.rentedTimeDays,
        this.showSubscription,
        this.isHighlighted,
        this.isWatchlist,
        this.viewCount,
        this.releasedBy,
        this.reportCount,
        this.movieName,
        this.movieVideo,
        this.trailorVideoLink,
        this.trailorVideo,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        coverImg: json["cover_img"],
        status: json["status"],
        seriesId: json["series_id"],
        seasonId: json["season_id"],
        episodeName: json["episode_name"],
        episodeNo: json["episode_no"],
        videoLink: json["video_link"],
        video: json["video"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        shortFilmTitle: json["short_film_title"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        shortVideo: json["short_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        rentedTimeDays: json["rented_time_days"],
        showSubscription: json["show_subscription"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        reportCount: json["report_count"],
        movieName: json["movie_name"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "status": status,
        "series_id": seriesId,
        "season_id": seasonId,
        "episode_name": episodeName,
        "episode_no": episodeNo,
        "video_link": videoLink,
        "video": video,
        "released_date": releasedDate?.toIso8601String(),
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "short_film_title": shortFilmTitle,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "short_video": shortVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "rented_time_days": rentedTimeDays,
        "show_subscription": showSubscription,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "report_count": reportCount,
        "movie_name": movieName,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
    };
}
