// To parse this JSON data, do
//
//     final loginErrorModel = loginErrorModelFromJson(jsonString);

import 'dart:convert';

LoginErrorModel loginErrorModelFromJson(String str) => LoginErrorModel.fromJson(json.decode(str));

String loginErrorModelToJson(LoginErrorModel data) => json.encode(data.toJson());

class LoginErrorModel {
  bool? status;
  String? message;
  List<ActiveDevice>? activeDevices;
  String? userId;
  LoginErrorModel({
    this.status,
    this.message,
    this.activeDevices,
    this.userId,
  });

  factory LoginErrorModel.fromJson(Map<String, dynamic> json) => LoginErrorModel(
      status: json["status"],
      message: json["message"],
      activeDevices: json["active_devices"] == null
          ? []
          : List<ActiveDevice>.from(json["active_devices"]!.map((x) => ActiveDevice.fromJson(x))),
      userId: json["user_id"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "active_devices": activeDevices == null ? [] : List<dynamic>.from(activeDevices!.map((x) => x.toJson())),
        "user_id": userId,
      };
}

class ActiveDevice {
  String? deviceId;
  String? model;
  DateTime? loginTime;

  ActiveDevice({
    this.deviceId,
    this.model,
    this.loginTime,
  });

  factory ActiveDevice.fromJson(Map<String, dynamic> json) => ActiveDevice(
        deviceId: json["device_id"],
        model: json["model"],
        loginTime: json["login_time"] == null ? null : DateTime.parse(json["login_time"]),
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "model": model,
        "login_time": loginTime?.toIso8601String(),
      };
}
