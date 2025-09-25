// To parse this JSON data, do
//
//     final getSettingModel = getSettingModelFromJson(jsonString);

import 'dart:convert';

GetSettingModel getSettingModelFromJson(String str) => GetSettingModel.fromJson(json.decode(str));

String getSettingModelToJson(GetSettingModel data) => json.encode(data.toJson());

class GetSettingModel {
  bool? status;
  String? message;
  Setting? setting;

  GetSettingModel({
    this.status,
    this.message,
    this.setting,
  });

  factory GetSettingModel.fromJson(Map<String, dynamic> json) => GetSettingModel(
        status: json["status"],
        message: json["message"],
        setting: json["setting"] == null ? null : Setting.fromJson(json["setting"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "setting": setting?.toJson(),
      };
}

class Setting {
  String? id;
  String? currentVersion;
  String? requiredVersion;
  String? adminUpi;
  String? adminContactNo;
  String? apk;
  String? razorpayKey;
  String? phonepayKey;
  String? phonepayPaySaltKey;
  String? cashfreeClientSecretKey;
  String? cashfreeClientId;
  String? secretKey;
  String? termsAndCondition;
  String? privacyPolicy;
  String? paymentType;
  String? aboutUs;
  String? playStoreLink;
  String? whatsappContactNumber;
  String? authorName;
  String? developedBy;
  dynamic appLogo;
  String? adminEmail;
  String? firebaseProjectId;
  String? firebaseClientEmail;
  String? firebasePrivateKey;
  String? helpSupport;
  String? spashScreenBanner1;
  String? spashScreenBanner2;
  String? spashScreenBanner3;
  bool? isSongOnSubscription;
  DateTime? createdAt;

  Setting({
    this.id,
    this.currentVersion,
    this.requiredVersion,
    this.adminUpi,
    this.adminContactNo,
    this.apk,
    this.razorpayKey,
    this.phonepayKey,
    this.phonepayPaySaltKey,
    this.cashfreeClientSecretKey,
    this.cashfreeClientId,
    this.secretKey,
    this.termsAndCondition,
    this.privacyPolicy,
    this.paymentType,
    this.aboutUs,
    this.playStoreLink,
    this.whatsappContactNumber,
    this.authorName,
    this.developedBy,
    this.appLogo,
    this.adminEmail,
    this.firebaseProjectId,
    this.firebaseClientEmail,
    this.firebasePrivateKey,
    this.helpSupport,
    this.spashScreenBanner1,
    this.spashScreenBanner2,
    this.spashScreenBanner3,
    this.isSongOnSubscription,
    this.createdAt,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["id"],
        currentVersion: json["current_version"],
        requiredVersion: json["required_version"],
        adminUpi: json["admin_upi"],
        adminContactNo: json["admin_contact_no"],
        apk: json["apk"],
        razorpayKey: json["razorpay_key"],
        phonepayKey: json["phonepay_key"],
        phonepayPaySaltKey: json["phonepay_pay_salt_key"],
        cashfreeClientSecretKey: json["cashfree_client_secret_key"],
        cashfreeClientId: json["cashfree_client_id"],
        secretKey: json["secret_key"],
        termsAndCondition: json["terms_and_condition"],
        privacyPolicy: json["privacy_policy"],
        paymentType: json["payment_type"],
        aboutUs: json["about_us"],
        playStoreLink: json["playStore_link"],
        whatsappContactNumber: json["whatsapp_contact_number"],
        authorName: json["author_name"],
        developedBy: json["developed_by"],
        appLogo: json["app_logo"],
        adminEmail: json["admin_email"],
        firebaseProjectId: json["firebase_project_id"],
        firebaseClientEmail: json["firebase_client_email"],
        firebasePrivateKey: json["firebase_private_key"],
        helpSupport: json["help_support"],
        spashScreenBanner1: json["spash_screen_banner_1"],
        spashScreenBanner2: json["spash_screen_banner_2"],
        spashScreenBanner3: json["spash_screen_banner_3"],
        isSongOnSubscription: json["is_song_on_subscription"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "current_version": currentVersion,
        "required_version": requiredVersion,
        "admin_upi": adminUpi,
        "admin_contact_no": adminContactNo,
        "apk": apk,
        "razorpay_key": razorpayKey,
        "phonepay_key": phonepayKey,
        "phonepay_pay_salt_key": phonepayPaySaltKey,
        "cashfree_client_secret_key": cashfreeClientSecretKey,
        "cashfree_client_id": cashfreeClientId,
        "secret_key": secretKey,
        "terms_and_condition": termsAndCondition,
        "privacy_policy": privacyPolicy,
        "payment_type": paymentType,
        "about_us": aboutUs,
        "playStore_link": playStoreLink,
        "whatsapp_contact_number": whatsappContactNumber,
        "author_name": authorName,
        "developed_by": developedBy,
        "app_logo": appLogo,
        "admin_email": adminEmail,
        "firebase_project_id": firebaseProjectId,
        "firebase_client_email": firebaseClientEmail,
        "firebase_private_key": firebasePrivateKey,
        "help_support": helpSupport,
        "spash_screen_banner_1": spashScreenBanner1,
        "spash_screen_banner_2": spashScreenBanner2,
        "spash_screen_banner_3": spashScreenBanner3,
        "is_song_on_subscription": isSongOnSubscription,
        "createdAt":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
      };
}
