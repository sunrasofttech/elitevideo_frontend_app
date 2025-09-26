import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../../../../../constant/app_string.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'post_series_rating_state.dart';

class PostSeriesRatingCubit extends Cubit<PostSeriesRatingState> {
  PostSeriesRatingCubit() : super(PostSeriesRatingInitial());

  postSeriesRate({
    String? movieId,
    String? rating,
    required ContentType type,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "series_id": movieId,
        "rating": rating,
        "show_type":type.name,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostSeriesRatingLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/series-rating/rate"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postWatchList $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostSeriesRatingLoadedState());
        } else {
          emit(PostSeriesRatingErrorState("${result['message']}"));
        }
      } else {
        emit(PostSeriesRatingErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostSeriesRatingErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostSeriesRatingErrorState("$e $s"));
    }
  }
}
