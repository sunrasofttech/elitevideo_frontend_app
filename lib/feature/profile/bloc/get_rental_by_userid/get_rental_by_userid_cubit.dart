import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/profile/bloc/get_rental_by_userid/get_rental_by_userid_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'get_rental_by_userid_state.dart';

class GetRentalByUseridCubit extends Cubit<GetRentalByUseridState> {
  GetRentalByUseridCubit() : super(GetRentalByUseridInitial());

  getSRentalByUserId({String? type}) async {
    try {
      emit(GetRentalByUseridLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/rental/get-all?user_id=$userId&type=$type"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("message getRentalByUserId =>  ${AppUrls.baseUrl}/api/ott/rental/get-all?user_id=$userId&type=$type");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetRentalByUseridLoadedState(
              getRentalModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetRentalByUseridErrorState(result["message"]));
        }
      } else {
        emit(GetRentalByUseridErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetRentalByUseridErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetRentalByUseridErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
