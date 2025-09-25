import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_short_film_castcrew/get_short_film_castcrew_model.dart';
import 'package:elite/utils/header.dart';

part 'get_short_film_castcrew_state.dart';

class GetShortFilmCastcrewCubit extends Cubit<GetShortFilmCastcrewState> {
  GetShortFilmCastcrewCubit() : super(GetShortFilmCastcrewInitial());

  getCastCrew({String? movieId}) async {
    try {
      emit(GetShortFilmCastcrewLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/short-film/cast-crew/by-shortfilmId/$movieId"),
         headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getCastCrew => $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetShortFilmCastcrewLoadedState(
              getShortFiImCastCrewModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetShortFilmCastcrewErrorState(result["message"]));
        }
      } else {
        emit(GetShortFilmCastcrewErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetShortFilmCastcrewErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetShortFilmCastcrewErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
