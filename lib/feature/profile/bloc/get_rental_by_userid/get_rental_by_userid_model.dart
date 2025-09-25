// To parse this JSON data, do
//
//     final getRentalModel = getRentalModelFromJson(jsonString);

import 'dart:convert';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_model.dart';

import '../../../../custom_model/movie_model.dart';
import '../../../../custom_model/short_film_model.dart';

GetRentalModel getRentalModelFromJson(String str) => GetRentalModel.fromJson(json.decode(str));

String getRentalModelToJson(GetRentalModel data) => json.encode(data.toJson());

class GetRentalModel {
  bool? status;
  String? message;
  Data? data;

  GetRentalModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetRentalModel.fromJson(Map<String, dynamic> json) => GetRentalModel(
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
  List<Rental>? rentals;

  Data({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.rentals,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        rentals: json["rentals"] == null ? [] : List<Rental>.from(json["rentals"]!.map((x) => Rental.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "rentals": rentals == null ? [] : List<dynamic>.from(rentals!.map((x) => x.toJson())),
      };
}

class Rental {
  String? id;
  String? movieId;
  String? shortfilmId;
  String? seriesId;
  String? userId;
  String? cost;
  DateTime? rentedOn;
  DateTime? validityDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Movie? movie;
  WebSeries? series;
  User? user;
  ShortFilm? shortfilm;

  Rental({
    this.id,
    this.movieId,
    this.shortfilmId,
    this.seriesId,
    this.userId,
    this.cost,
    this.rentedOn,
    this.validityDate,
    this.createdAt,
    this.updatedAt,
    this.movie,
    this.series,
    this.user,
    this.shortfilm,
  });

  factory Rental.fromJson(Map<String, dynamic> json) => Rental(
        id: json["id"],
        movieId: json["movie_id"],
        shortfilmId: json["shortfilm_id"],
        seriesId: json["series_id"],
        userId: json["user_id"],
        cost: json["cost"],
        rentedOn: json["rented_on"] == null ? null : DateTime.parse(json["rented_on"]),
        validityDate: json["validity_date"] == null ? null : DateTime.parse(json["validity_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
        series: json["series"] == null ? null : WebSeries.fromJson(json["series"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        shortfilm: json["shortfilm"] == null ? null : ShortFilm.fromJson(json["shortfilm"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_id": movieId,
        "shortfilm_id": shortfilmId,
        "series_id": seriesId,
        "user_id": userId,
        "cost": cost,
        "rented_on": rentedOn?.toIso8601String(),
        "validity_date": validityDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "movie": movie?.toJson(),
        "series": series?.toJson(),
        "user": user?.toJson(),
        "shortfilm": shortfilm?.toJson(),
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
        subscriptionEndDate:
            json["subscription_end_date"] == null ? null : DateTime.parse(json["subscription_end_date"]),
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
        "subscription_end_date":
            "${subscriptionEndDate!.year.toString().padLeft(4, '0')}-${subscriptionEndDate!.month.toString().padLeft(2, '0')}-${subscriptionEndDate!.day.toString().padLeft(2, '0')}",
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
      };
}
