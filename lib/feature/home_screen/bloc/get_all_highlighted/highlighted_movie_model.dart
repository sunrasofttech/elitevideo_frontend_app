// To parse this JSON data, do
//
//     final highlightedMovieModel = highlightedMovieModelFromJson(jsonString);

import 'dart:convert';

HighlightedMovieModel highlightedMovieModelFromJson(String str) => HighlightedMovieModel.fromJson(json.decode(str));

String highlightedMovieModelToJson(HighlightedMovieModel data) => json.encode(data.toJson());

class HighlightedMovieModel {
    bool? status;
    String? message;
    List<Datum>? data;

    HighlightedMovieModel({
        this.status,
        this.message,
        this.data,
    });

    factory HighlightedMovieModel.fromJson(Map<String, dynamic> json) => HighlightedMovieModel(
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
    String? movieId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    VideoAd? videoAd;

    Ad({
        this.id,
        this.movieId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.videoAd,
    });

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        movieId: json["movie_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "movie_id": movieId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "video_ad": videoAd?.toJson(),
    };
}

class VideoAd {
    String? id;
    String? adVideo;
    dynamic adUrl;
    String? videoTime;
    String? skipTime;
    String? title;
    DateTime? createdAt;
    DateTime? updatedAt;

    VideoAd({
        this.id,
        this.adVideo,
        this.adUrl,
        this.videoTime,
        this.skipTime,
        this.title,
        this.createdAt,
        this.updatedAt,
    });

    factory VideoAd.fromJson(Map<String, dynamic> json) => VideoAd(
        id: json["id"],
        adVideo: json["ad_video"],
        adUrl: json["ad_url"],
        videoTime: json["video_time"],
        skipTime: json["skip_time"],
        title: json["title"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ad_video": adVideo,
        "ad_url": adUrl,
        "video_time": videoTime,
        "skip_time": skipTime,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class Content {
    String? id;
    String? movieName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    String? genreId;
    String? movieCategory;
    int? reportCount;
    String? videoLink;
    String? movieVideo;
    String? trailorVideoLink;
    dynamic trailorVideo;
    bool? quality;
    bool? subtitle;
    String? description;
    String? movieTime;
    String? movieRentPrice;
    bool? isMovieOnRent;
    int? rentedTimeDays;
    bool? showSubscription;
    bool? isHighlighted;
    bool? isWatchlist;
    int? viewCount;
    String? releasedBy;
    DateTime? releasedDate;
    dynamic position;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? seriesId;
    String? seasonId;
    String? episodeName;
    String? episodeNo;
    String? video;
    String? showType;
    String? shortFilmTitle;
    String? shortVideo;

    Content({
        this.id,
        this.movieName,
        this.status,
        this.coverImg,
        this.posterImg,
        this.movieLanguage,
        this.genreId,
        this.movieCategory,
        this.reportCount,
        this.videoLink,
        this.movieVideo,
        this.trailorVideoLink,
        this.trailorVideo,
        this.quality,
        this.subtitle,
        this.description,
        this.movieTime,
        this.movieRentPrice,
        this.isMovieOnRent,
        this.rentedTimeDays,
        this.showSubscription,
        this.isHighlighted,
        this.isWatchlist,
        this.viewCount,
        this.releasedBy,
        this.releasedDate,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.seriesId,
        this.seasonId,
        this.episodeName,
        this.episodeNo,
        this.video,
        this.showType,
        this.shortFilmTitle,
        this.shortVideo,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        reportCount: json["report_count"],
        videoLink: json["video_link"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        rentedTimeDays: json["rented_time_days"],
        showSubscription: json["show_subscription"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        position: json["position"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        seriesId: json["series_id"],
        seasonId: json["season_id"],
        episodeName: json["episode_name"],
        episodeNo: json["episode_no"],
        video: json["video"],
        showType: json["show_type"],
        shortFilmTitle: json["short_film_title"],
        shortVideo: json["short_video"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "report_count": reportCount,
        "video_link": videoLink,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "rented_time_days": rentedTimeDays,
        "show_subscription": showSubscription,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "position": position,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "series_id": seriesId,
        "season_id": seasonId,
        "episode_name": episodeName,
        "episode_no": episodeNo,
        "video": video,
        "show_type": showType,
        "short_film_title": shortFilmTitle,
        "short_video": shortVideo,
    };
}
