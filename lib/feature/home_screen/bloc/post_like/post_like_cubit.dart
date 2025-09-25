import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
import '../../../../constant/app_string.dart';
part 'post_like_state.dart';

class PostLikeCubit extends Cubit<PostLikeState> {
  PostLikeCubit() : super(PostLikeInitial());

  postLike({
    String? shortfilmId,
    String? seasonEpisodeId,
    String? movieId,
    ContentType? type,
    bool? isLiked,
    bool? disLiked,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "type": type?.name,
        "movie_id": movieId,
        "liked": isLiked,
        "disliked": disLiked,
        "season_episode_id": seasonEpisodeId,
        "shortfilm_id": shortfilmId
      }..removeWhere(
          (k, v) => v == null,
        );

      log("1 $body");
      emit(PostLikeLoadingState());
      log("2 $body");
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/like"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      log(" 3Result : = > postLike $body ${response.statusCode}  ");
      final result = jsonDecode(response.body.toString());
      log("Result : = > postLike $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostLikeLoadedState());
        } else {
          emit(PostLikeErrorState("${result['message']}"));
        }
      } else {
        emit(PostLikeErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostLikeErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostLikeErrorState("$e $s"));
    }
  }
}
