import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:elite/feature/home_screen/bloc/check_rental/check_rental_model.dart';
import 'package:elite/main.dart';

import '../../../../constant/app_string.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

part 'check_rental_state.dart';

class CheckRentalCubit extends Cubit<CheckRentalState> {
  CheckRentalCubit() : super(CheckRentalInitial());

  checkRental({
    String? typeId,
    ContentType? type,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "type_id": typeId,
        "type": type?.name,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(CheckRentalLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/rental/checkrental/api"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );

      final curlCommand = StringBuffer();
      curlCommand.writeln("curl -X POST \\");
      curlCommand.writeln("  '${AppUrls.baseUrl}/api/ott/rental' \\");
    
      curlCommand.writeln("  -d '$body'");

      log("🔄 CURL REQUEST:\n$curlCommand");

      final result = jsonDecode(response.body.toString());
      log("Result : = > checkRental $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            CheckRentalLoadedState(
              checkRentalModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(CheckRentalErrorState("${result['message']}"));
        }
      } else {
        emit(CheckRentalErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(CheckRentalErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(CheckRentalErrorState("$e $s"));
    }
  }
}
