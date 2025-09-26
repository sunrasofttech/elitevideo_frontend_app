import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  forgetPassword(
    String mobileNumber,
    String newPassword,
  ) async {
    try {
      emit(ForgetPasswordLoadingState());
      var response = await post(
        Uri.parse(AppUrls.loginUrl),
        body: json.encode({
          "mobile_no": mobileNumber,
          "newPassword": newPassword,
        }),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > login $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(ForgetPasswordLoadedState());
        } else {
          emit(ForgetPasswordErrorState("${result['message']}"));
        }
      } else {
        emit(ForgetPasswordErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(ForgetPasswordErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(ForgetPasswordErrorState("$e $s"));
    }
  }
}
