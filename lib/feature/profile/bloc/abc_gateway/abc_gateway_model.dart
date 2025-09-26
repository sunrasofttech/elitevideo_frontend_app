// To parse this JSON data, do
//
//     final abcGatewayModel = abcGatewayModelFromJson(jsonString);

import 'dart:convert';

AbcGatewayModel abcGatewayModelFromJson(String str) => AbcGatewayModel.fromJson(json.decode(str));

String abcGatewayModelToJson(AbcGatewayModel data) => json.encode(data.toJson());

class AbcGatewayModel {
    bool? status;
    String? msg;
    Data? data;

    AbcGatewayModel({
        this.status,
        this.msg,
        this.data,
    });

    factory AbcGatewayModel.fromJson(Map<String, dynamic> json) => AbcGatewayModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
    };
}

class Data {
    String? userId;
    String? amount;
    String? paymentStatus;
    DateTime? date;
    String? merchantTransactionId;
    String? clientId;
    String? paymentUrl;

    Data({
        this.userId,
        this.amount,
        this.paymentStatus,
        this.date,
        this.merchantTransactionId,
        this.clientId,
        this.paymentUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        amount: json["amount"],
        paymentStatus: json["paymentStatus"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        merchantTransactionId: json["merchantTransactionId"],
        clientId: json["clientId"],
        paymentUrl: json["paymentUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "amount": amount,
        "paymentStatus": paymentStatus,
        "date": date?.toIso8601String(),
        "merchantTransactionId": merchantTransactionId,
        "clientId": clientId,
        "paymentUrl": paymentUrl,
    };
}
