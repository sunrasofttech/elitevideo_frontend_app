import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
import 'package:http/http.dart';
part 'post_movie_rating_state.dart';

class PostMovieRatingCubit extends Cubit<PostMovieRatingState> {
  PostMovieRatingCubit() : super(PostMovieRatingInitial());

  postMovieRate({
    String? movieId,
    String? rating,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "movie_id": movieId,
        "rating": rating,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostMovieRatingLoadingState());
      var response = await post(
        Uri.parse(AppUrls.ratingUrl),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postWatchList $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostMovieRatingLoadedState());
        } else {
          emit(PostMovieRatingErrorState("${result['message']}"));
        }
      } else {
        emit(PostMovieRatingErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostMovieRatingErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostMovieRatingErrorState("$e $s"));
    }
  }
}
