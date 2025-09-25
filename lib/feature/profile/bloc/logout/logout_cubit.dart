import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  logout(
    String userId,
    String deviceId,
  ) async {
    try {
      emit(LogoutLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/user/logout"),
        body: json.encode({
          "user_id": userId,
          "device_id": deviceId,
        }),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > logout $result $deviceId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(LogoutLoadedState());
        } else {
          emit(LogoutErrorState(
            result['message'],
          ));
        }
      } else {
        emit(LogoutErrorState(result['message']));
      }
    } on SocketException {
      emit(LogoutErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(LogoutErrorState("$e $s"));
    }
  }
}
