import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/utils/header.dart';
part 'post_continue_watching_state.dart';

class PostContinueWatchingCubit extends Cubit<PostContinueWatchingState> {
  PostContinueWatchingCubit() : super(PostContinueWatchingInitial());

  postContinueWatching({
    ContentType? contentType,
    String? typeId,
    int? currentTime,
    bool? isWatched,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "type": contentType?.name,
        "type_id": typeId,
        "current_time": currentTime,
        "is_watched": isWatched,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostContinueWatchingLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/continue-watching/save"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postContinueWatching $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostContinueWatchingLoadedState());
        } else {
          emit(PostContinueWatchingErrorState("${result['message']}"));
        }
      } else {
        emit(PostContinueWatchingErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostContinueWatchingErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostContinueWatchingErrorState("$e $s"));
    }
  }
}
