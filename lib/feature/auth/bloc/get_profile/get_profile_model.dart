import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
    bool? status;
    String? message;
    User? user;

    GetUserModel({
        this.status,
        this.message,
        this.user,
    });

    factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
        status: json["status"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user?.toJson(),
    };
}

class User {
    String? id;
    String? profilePicture;
    String? name;
    String? email;
    bool? isFirstTimeUser;
    String? deviceId;
    String? deviceToken;
    String? mobileNo;
    String? password;
    dynamic appVersion;
    bool? isPaidMember;
    bool? isActive;
    String? subscriptionId;
    bool? isSubscription;
    DateTime? subscriptionEndDate;
    bool? isBlock;
    dynamic activeDate;
    String? jwtApiToken;
    String? model;
    String? brand;
    String? device;
    String? manufacturer;
    String? androidVersion;
    String? sdk;
    String? board;
    String? fingerprint;
    String? hardware;
    String? androidId;
    String? product;
    DateTime? createdAt;
    DateTime? updatedAt;
    Subscription? subscription;

    User({
        this.id,
        this.profilePicture,
        this.name,
        this.email,
        this.isFirstTimeUser,
        this.deviceId,
        this.deviceToken,
        this.mobileNo,
        this.password,
        this.appVersion,
        this.isPaidMember,
        this.isActive,
        this.subscriptionId,
        this.isSubscription,
        this.subscriptionEndDate,
        this.isBlock,
        this.activeDate,
        this.jwtApiToken,
        this.model,
        this.brand,
        this.device,
        this.manufacturer,
        this.androidVersion,
        this.sdk,
        this.board,
        this.fingerprint,
        this.hardware,
        this.androidId,
        this.product,
        this.createdAt,
        this.updatedAt,
        this.subscription,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profilePicture: json["profile_picture"],
        name: json["name"],
        email: json["email"],
        isFirstTimeUser: json["is_first_time_user"],
        deviceId: json["deviceId"],
        deviceToken: json["deviceToken"],
        mobileNo: json["mobile_no"],
        password: json["password"],
        appVersion: json["app_version"],
        isPaidMember: json["is_paid_member"],
        isActive: json["is_active"],
        subscriptionId: json["subscription_id"],
        isSubscription: json["is_subscription"],
        subscriptionEndDate: json["subscription_end_date"] == null ? null : DateTime.parse(json["subscription_end_date"]),
        isBlock: json["is_block"],
        activeDate: json["active_date"],
        jwtApiToken: json["jwt_api_token"],
        model: json["model"],
        brand: json["brand"],
        device: json["device"],
        manufacturer: json["manufacturer"],
        androidVersion: json["android_version"],
        sdk: json["SDK"],
        board: json["board"],
        fingerprint: json["fingerprint"],
        hardware: json["hardware"],
        androidId: json["android_ID"],
        product: json["Product"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_picture": profilePicture,
        "name": name,
        "email": email,
        "is_first_time_user": isFirstTimeUser,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "mobile_no": mobileNo,
        "password": password,
        "app_version": appVersion,
        "is_paid_member": isPaidMember,
        "is_active": isActive,
        "subscription_id": subscriptionId,
        "is_subscription": isSubscription,
        "subscription_end_date": "${subscriptionEndDate!.year.toString().padLeft(4, '0')}-${subscriptionEndDate!.month.toString().padLeft(2, '0')}-${subscriptionEndDate!.day.toString().padLeft(2, '0')}",
        "is_block": isBlock,
        "active_date": activeDate,
        "jwt_api_token": jwtApiToken,
        "model": model,
        "brand": brand,
        "device": device,
        "manufacturer": manufacturer,
        "android_version": androidVersion,
        "SDK": sdk,
        "board": board,
        "fingerprint": fingerprint,
        "hardware": hardware,
        "android_ID": androidId,
        "Product": product,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "subscription": subscription?.toJson(),
    };
}

class Subscription {
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

    Subscription({
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

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
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
