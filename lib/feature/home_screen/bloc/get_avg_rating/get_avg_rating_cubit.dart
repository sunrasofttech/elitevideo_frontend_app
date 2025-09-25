import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:http/http.dart';
import 'package:elite/feature/home_screen/bloc/get_avg_rating/get_avg_rating_model.dart';
import 'package:elite/utils/header.dart';
part 'get_avg_rating_state.dart';

class GetAvgRatingCubit extends Cubit<GetAvgRatingState> {
  GetAvgRatingCubit() : super(GetAvgRatingInitial());

  getRate(String movieId) async {
    try {
      emit(GetAvgRatingLoadingState());

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/movie-rating/average/$movieId");

      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getRate =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAvgRatingLoadedState(
              getRatingInfoModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAvgRatingErrorState(result["message"]));
        }
      } else {
        emit(GetAvgRatingErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetAvgRatingErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAvgRatingErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
