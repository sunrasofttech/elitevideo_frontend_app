import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_movie_by_id/get_movie_by_id_model.dart';
import 'package:elite/utils/header.dart';

part 'get_movie_by_id_state.dart';

class GetMovieByIdCubit extends Cubit<GetMovieByIdState> {
  GetMovieByIdCubit() : super(GetMovieByIdInitial());

  getMovie(String id) async {
    try {
      emit(GetMovieByIdLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/movie/$id");
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("GetMovieByIdCubit =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetMovieByIdLoadedState(
              getMovieByIdModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetMovieByIdErrorState(result["message"]));
        }
      } else {
        emit(GetMovieByIdErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetMovieByIdErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetMovieByIdErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
