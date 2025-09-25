import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_shortfilm_id/get_shortfilm_by_id_model.dart';
import 'package:elite/utils/header.dart';

part 'get_shortfilm_by_id_state.dart';

class GetShortfilmByIdCubit extends Cubit<GetShortfilmByIdState> {
  GetShortfilmByIdCubit() : super(GetShortfilmByIdInitial());

  getShortFilm(String id) async {
    try {
      emit(GetShortfilmByIdLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/short-film/$id");
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("GetShortfilmByIdCubit =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetShortfilmByIdLoadedState(
              getShortFilmByIdModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetShortfilmByIdErrorState(result["message"]));
        }
      } else {
        emit(GetShortfilmByIdErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetShortfilmByIdErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetShortfilmByIdErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
