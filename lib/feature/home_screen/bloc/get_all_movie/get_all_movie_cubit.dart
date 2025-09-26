import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_model.dart';
import 'package:elite/utils/header.dart';
part 'get_all_movie_state.dart';

class GetAllMovieCubit extends Cubit<GetAllMovieState> {
  GetAllMovieCubit() : super(GetAllMovieInitial());

  getAllMovie() async {
    try {
      emit(GetAllMovieLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.movieUrl}/get-all"),
     headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getAllMovie =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMovieLaodedState(
              getAllMoviesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMovieErrorState(result["message"]));
        }
      } else {
        emit(GetAllMovieErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetAllMovieErrorState("Check Internet Connection"));
    } catch (e) {
      emit(GetAllMovieErrorState("Unexpected error $e"));
    }
  }
}
