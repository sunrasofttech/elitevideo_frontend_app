import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'short_film_rate_state.dart';

class ShortFilmRateCubit extends Cubit<ShortFilmRateState> {
  ShortFilmRateCubit() : super(ShortFilmRateInitial());

  postShortFilmRate({
    String? movieId,
    String? rating,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "short_film_id": movieId,
        "rating": rating,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(ShortFilmRateLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/short-film/rating/rate"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postWatchList $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(ShortFilmRateLoadedState());
        } else {
          emit(ShortFilmRateErrorState("${result['message']}"));
        }
      } else {
        emit(ShortFilmRateErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(ShortFilmRateErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(ShortFilmRateErrorState("$e $s"));
    }
  }
}
