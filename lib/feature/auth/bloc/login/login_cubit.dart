import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/auth/bloc/login/error_model.dart';
import 'package:elite/feature/auth/bloc/login/login_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  String? model, brand, device, manufacturer, androidVersion, sdk, board, fingerprint, hardware, androidId, product;

  Future<void> logDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        model = webInfo.userAgent;
        device = webInfo.browserName.name;
        manufacturer = "Web";
        androidId = webInfo.vendor ?? "";
        product = webInfo.appName;
        androidVersion = webInfo.appVersion;

        debugPrint('✅ Web Device Info Loaded');
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

        model = androidInfo.model;
        brand = androidInfo.brand;
        device = androidInfo.device;
        manufacturer = androidInfo.manufacturer;
        androidVersion = androidInfo.version.release;
        sdk = androidInfo.version.sdkInt.toString();
        board = androidInfo.board;
        fingerprint = androidInfo.fingerprint;
        hardware = androidInfo.hardware;
        androidId = androidInfo.id;
        product = androidInfo.product;

        debugPrint('✅ Android Device Info Loaded');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.utsname.machine;
        brand = "Apple";
        device = iosInfo.name;
        manufacturer = iosInfo.model;
        androidVersion = iosInfo.systemVersion;
        sdk = iosInfo.systemName;
        androidId = iosInfo.identifierForVendor ?? "";
        product = iosInfo.systemName;
      }
    } catch (e) {
      debugPrint('❌ Error getting device info: $e');
    }
  }

  login(
    String email,
    String password,
  ) async {
    try {
      emit(LoginLoadingState());
      var response = await post(
        Uri.parse(AppUrls.loginUrl),
        body: json.encode({
          "email": email,
          "password": password,
          "deviceToken": token ?? "",
          "deviceId": androidId ?? "",
          "model": model ?? "",
          "brand": brand ?? "",
          "device": device ?? "",
          "manufacturer": manufacturer ?? "",
          "android_version": androidVersion ?? "",
          "SDK": sdk ?? "",
          "board": board ?? "",
          "fingerprint": fingerprint ?? "",
          "hardware": hardware ?? "",
          "android_ID": androidId ?? "",
          "Product": product ?? "",
          "app_version": appVersion,
        }),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > login $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(LoginLoadedState(loginModelFromJson(json.encode(result))));
        } else {
          emit(LoginErrorState(error: result['message'], model: loginErrorModelFromJson(json.encode(result))));
        }
      } else {
        emit(LoginErrorState(error: result['message'], model: loginErrorModelFromJson(json.encode(result))));
      }
    } on SocketException {
      emit(LoginErrorState(error: "Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(LoginErrorState(error: "$e $s"));
    }
  }
}
