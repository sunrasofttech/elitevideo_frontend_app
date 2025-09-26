import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_webseries_by_id/get_webseries_by_id_model.dart';
import 'package:elite/utils/header.dart';

part 'get_webseries_by_id_state.dart';

class GetWebseriesByIdCubit extends Cubit<GetWebseriesByIdState> {
  GetWebseriesByIdCubit() : super(GetWebseriesByIdInitial());

  getWebseriesById(String id) async {
    try {
      emit(GetWebseriesByIdLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/series/$id");
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getWebseriesById =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetWebseriesByIdLoadedState(
              getWebseriesByModelModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetWebseriesByIdErrorState(result["message"]));
        }
      } else {
        emit(GetWebseriesByIdErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetWebseriesByIdErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetWebseriesByIdErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
