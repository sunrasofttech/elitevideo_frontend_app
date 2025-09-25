import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/service_rating/get_series_rating/get_series_rating_model.dart';
import 'package:elite/utils/header.dart';

part 'get_series_rating_state.dart';

class GetSeriesRatingCubit extends Cubit<GetSeriesRatingState> {
  GetSeriesRatingCubit() : super(GetSeriesRatingInitial());

  getShortFilmRating(String id) async {
    try {
      emit(GetSeriesRatingLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/series-rating/average/$id");
      var response = await post(
        uri,
     headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getShortFilmRating =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSeriesRatingLoadedState(
              getSeriesRatingByIdModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSeriesRatingErrorState(result["message"]));
        }
      } else {
        emit(GetSeriesRatingErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetSeriesRatingErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetSeriesRatingErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
