import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../../../../constant/app_string.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'post_watchlist_state.dart';

class PostWatchlistCubit extends Cubit<PostWatchlistState> {
  PostWatchlistCubit() : super(PostWatchlistInitial());

  postWatchList({
    String? movieId,
    String? shortfilmId,
    String? seasonEpisodeId,
    required ContentType type,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "movie_id": movieId,
        "shortfilm_id": shortfilmId,
        "season_episode_id": seasonEpisodeId,
        "type": type.name,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostWatchlistLoadingState());
      var response = await post(
        Uri.parse(AppUrls.watchListUrl),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postWatchList $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostWatchlistLoadedState());
        } else {
          emit(PostWatchlistErrorState("${result['message']}"));
        }
      } else {
        emit(PostWatchlistErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostWatchlistErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(PostWatchlistErrorState("$e $s"));
    }
  }
}
