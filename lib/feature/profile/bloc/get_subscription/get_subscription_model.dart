// To parse this JSON data, do
//
//     final getAllSubscriptionModel = getAllSubscriptionModelFromJson(jsonString);

import 'dart:convert';

GetAllSubscriptionModel getAllSubscriptionModelFromJson(String str) => GetAllSubscriptionModel.fromJson(json.decode(str));

String getAllSubscriptionModelToJson(GetAllSubscriptionModel data) => json.encode(data.toJson());

class GetAllSubscriptionModel {
    bool? status;
    String? message;
    List<SubscriptionPlan>? data;

    GetAllSubscriptionModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllSubscriptionModel.fromJson(Map<String, dynamic> json) => GetAllSubscriptionModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<SubscriptionPlan>.from(json["data"]!.map((x) => SubscriptionPlan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class SubscriptionPlan {
    String? id;
    String? planName;
    bool? allContent;
    bool? watchonTvLaptop;
    bool? addfreeMovieShows;
    int? numberOfDeviceThatLogged;
    String? maxVideoQuality;
    String? amount;
    String? timeDuration;
    bool? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    SubscriptionPlan({
        this.id,
        this.planName,
        this.allContent,
        this.watchonTvLaptop,
        this.addfreeMovieShows,
        this.numberOfDeviceThatLogged,
        this.maxVideoQuality,
        this.amount,
        this.timeDuration,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
        id: json["id"],
        planName: json["plan_name"],
        allContent: json["all_content"],
        watchonTvLaptop: json["watchon_tv_laptop"],
        addfreeMovieShows: json["addfree_movie_shows"],
        numberOfDeviceThatLogged: json["number_of_device_that_logged"],
        maxVideoQuality: json["max_video_quality"],
        amount: json["amount"],
        timeDuration: json["time_duration"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "plan_name": planName,
        "all_content": allContent,
        "watchon_tv_laptop": watchonTvLaptop,
        "addfree_movie_shows": addfreeMovieShows,
        "number_of_device_that_logged": numberOfDeviceThatLogged,
        "max_video_quality": maxVideoQuality,
        "amount": amount,
        "time_duration": timeDuration,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
