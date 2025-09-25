import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';

import '../../../../utils/header.dart';
import 'get_all_movie_by_category_model.dart';

part 'get_movie_by_category_id_state.dart';

class GetMovieByCategoryIdCubit extends Cubit<GetMovieByCategoryIdState> {
  GetMovieByCategoryIdCubit() : super(GetMovieByCategoryIdInitial());

  getAllMovie(String categoryId) async {
    try {
      emit(GetMovieByCategoryIdLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.movieUrl}/get-all?category_id=$categoryId"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("GetMovieByCategoryIdCubit =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetMovieByCategoryIdLoadedState(
              getAllMoviesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetMovieByCategoryIdErrorState(result["message"]));
        }
      } else {
        emit(GetMovieByCategoryIdErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetMovieByCategoryIdErrorState("Check Internet Connection"));
    } catch (e) {
      emit(GetMovieByCategoryIdErrorState("Unexpected error $e"));
    }
  }
}
