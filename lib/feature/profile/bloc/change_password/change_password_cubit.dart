import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      emit(ChangePasswordLoadingState());
      var body = {
        "id": userId,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/user/change-password"),
        body: json.encode(body),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > Change Pasword POST ${AppUrls.baseUrl}/api/ott/user/change-password $body $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(ChangePasswordLoadedState());
        } else {
          emit(ChangePasswordErrorState("${result['message']}"));
        }
      } else {
        emit(ChangePasswordErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(ChangePasswordErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(ChangePasswordErrorState("$e $s"));
    }
  }
}
