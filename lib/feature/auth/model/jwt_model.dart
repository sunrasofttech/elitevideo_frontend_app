// To parse this JSON data, do
//
//     final jwtModel = jwtModelFromJson(jsonString);

import 'dart:convert';

JwtModel jwtModelFromJson(String str) => JwtModel.fromJson(json.decode(str));

String jwtModelToJson(JwtModel data) => json.encode(data.toJson());

class JwtModel {
    String? id;
    String? name;
    int? iat;
    int? exp;

    JwtModel({
        this.id,
        this.name,
        this.iat,
        this.exp,
    });

    factory JwtModel.fromJson(Map<String, dynamic> json) => JwtModel(
        id: json["id"],
        name: json["name"],
        iat: json["iat"],
        exp: json["exp"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iat": iat,
        "exp": exp,
    };
}
