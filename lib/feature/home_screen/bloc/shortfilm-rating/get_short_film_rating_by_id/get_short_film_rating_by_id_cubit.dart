import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

import 'get_short_fim_rating_by_id_model.dart';

part 'get_short_film_rating_by_id_state.dart';

class GetShortFilmRatingByIdCubit extends Cubit<GetShortFilmRatingByIdState> {
  GetShortFilmRatingByIdCubit() : super(GetShortFilmRatingByIdInitial());

  getShortFilmRating(String id) async {
    try {
      emit(GetShortFilmRatingByIdLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/short-film/rating/$id/ratings");
      var response = await post(
        uri,
          headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("GetShortFilmRatingByIdCubit =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetShortFilmRatingByIdLoadedState(
              getShortFilmRatingByIdModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetShortFilmRatingByIdErrorState(result["message"]));
        }
      } else {
        emit(GetShortFilmRatingByIdErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetShortFilmRatingByIdErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetShortFilmRatingByIdErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
