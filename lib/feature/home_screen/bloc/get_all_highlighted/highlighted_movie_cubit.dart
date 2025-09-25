import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_model.dart';
import 'package:http/http.dart';
import 'package:elite/utils/header.dart';

import '../../../../constant/app_urls.dart';
part 'highlighted_movie_state.dart';

class HighlightedMovieCubit extends Cubit<HighlightedMovieState> {
  HighlightedMovieCubit() : super(HighlightedMovieInitial());

  getHighLightedMovie() async {
    try {
      emit(HighlightedMovieLoadingState());
      var response = await post(
        Uri.parse(AppUrls.getHighlightedMovieUrl),
          headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            HighlightedMovieLoadedState(
              highlightedMovieModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(HighlightedMovieErrorState(result["message"]));
        }
      } else {
        emit(HighlightedMovieErrorState(result["message"]));
      }
    } on SocketException {
      emit(HighlightedMovieErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        HighlightedMovieErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
