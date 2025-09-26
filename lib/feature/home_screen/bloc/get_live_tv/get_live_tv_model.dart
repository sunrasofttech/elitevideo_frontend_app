// To parse this JSON data, do
//
//     final getLiveModel = getLiveModelFromJson(jsonString);

import 'dart:convert';

GetLiveModel getLiveModelFromJson(String str) => GetLiveModel.fromJson(json.decode(str));

String getLiveModelToJson(GetLiveModel data) => json.encode(data.toJson());

class GetLiveModel {
  bool? status;
  String? message;
  Data? data;

  GetLiveModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetLiveModel.fromJson(Map<String, dynamic> json) => GetLiveModel(
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
  List<Channel>? channels;

  Data({
    this.total,
    this.page,
    this.totalPages,
    this.channels,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        totalPages: json["totalPages"],
        channels: json["channels"] == null ? [] : List<Channel>.from(json["channels"]!.map((x) => Channel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "totalPages": totalPages,
        "channels": channels == null ? [] : List<dynamic>.from(channels!.map((x) => x.toJson())),
      };
}

class ChannelAd {
  String? id;
  String? livetvChannelId;
  String? videoAdId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Channel? livetvChannel;
  VideoAd? videoAd;

  ChannelAd({
    this.id,
    this.livetvChannelId,
    this.videoAdId,
    this.createdAt,
    this.updatedAt,
    this.livetvChannel,
    this.videoAd,
  });

  factory ChannelAd.fromJson(Map<String, dynamic> json) => ChannelAd(
        id: json["id"],
        livetvChannelId: json["livetv_channel_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        livetvChannel: json["livetv_channel"] == null ? null : Channel.fromJson(json["livetv_channel"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "livetv_channel_id": livetvChannelId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "livetv_channel": livetvChannel?.toJson(),
        "video_ad": videoAd?.toJson(),
      };
}

class Channel {
  String? id;
  String? coverImg;
  String? posterImg;
  String? liveCategoryId;
  String? name;
  String? androidChannelUrl;
  String? iosChannelUrl;
  bool? is_livetv_on_rent;
  bool? status;
  String? description;
  int? reportCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ChannelAd>? channelAds;

  Channel({
    this.id,
    this.coverImg,
    this.posterImg,
    this.liveCategoryId,
    this.name,
    this.androidChannelUrl,
    this.is_livetv_on_rent,
    this.iosChannelUrl,
    this.status,
    this.description,
    this.reportCount,
    this.createdAt,
    this.updatedAt,
    this.channelAds,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        liveCategoryId: json["live_category_id"],
        name: json["name"],
        androidChannelUrl: json["android_channel_url"],
        iosChannelUrl: json["ios_channel_url"],
        is_livetv_on_rent: json["is_livetv_on_rent"],
        status: json["status"],
        description: json["description"],
        reportCount: json["report_count"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        channelAds: json["channel_ads"] == null
            ? []
            : List<ChannelAd>.from(json["channel_ads"]!.map((x) => ChannelAd.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "live_category_id": liveCategoryId,
        "name": name,
        "android_channel_url": androidChannelUrl,
        "ios_channel_url": iosChannelUrl,
        "is_livetv_on_rent": is_livetv_on_rent,
        "status": status,
        "description": description,
        "report_count": reportCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "channel_ads": channelAds == null ? [] : List<dynamic>.from(channelAds!.map((x) => x.toJson())),
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
