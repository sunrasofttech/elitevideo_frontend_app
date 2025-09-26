// To parse this JSON data, do
//
//     final checkRentalModel = checkRentalModelFromJson(jsonString);

import 'dart:convert';

CheckRentalModel checkRentalModelFromJson(String str) => CheckRentalModel.fromJson(json.decode(str));

String checkRentalModelToJson(CheckRentalModel data) => json.encode(data.toJson());

class CheckRentalModel {
    bool? status;
    String? message;
    Data? data;

    CheckRentalModel({
        this.status,
        this.message,
        this.data,
    });

    factory CheckRentalModel.fromJson(Map<String, dynamic> json) => CheckRentalModel(
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
    String? id;
    dynamic movieId;
    String? shortfilmId;
    dynamic seriesId;
    String? userId;
    String? cost;
    DateTime? rentedOn;
    DateTime? validityDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    Data({
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
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    };
}
