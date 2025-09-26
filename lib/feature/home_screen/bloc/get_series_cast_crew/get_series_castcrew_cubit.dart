import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_series_cast_crew/get_series_castcrew_model.dart';
import 'package:elite/utils/header.dart';

part 'get_series_castcrew_state.dart';

class GetSeriesCastcrewCubit extends Cubit<GetSeriesCastcrewState> {
  GetSeriesCastcrewCubit() : super(GetSeriesCastcrewInitial());

  getCastCrew({String? movieId}) async {
    try {
      emit(GetSeriesCastcrewLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/series/cast-crew/by-series/$movieId"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getCastCrew => $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSeriesCastcrewLoadedState(
              getSeriesCastCrewModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSeriesCastcrewErrorState(result["message"]));
        }
      } else {
        emit(GetSeriesCastcrewErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetSeriesCastcrewErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetSeriesCastcrewErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
