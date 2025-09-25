import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'post_playlist_state.dart';

class PostPlaylistCubit extends Cubit<PostPlaylistState> {
  PostPlaylistCubit() : super(PostPlaylistInitial());

  postPlaylist({required String name}) async {
    try {
      emit(PostPlaylistLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/playlist/create"),
        body: json.encode(
          {
            "user_id": userId,
            "name": name,
          },
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("--==>>$result ${AppUrls.baseUrl}/api/ott/playlist/create");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostPlaylistLoadedState());
        } else {
          emit(PostPlaylistErrorState("${result['message']}"));
        }
      } else {
        emit(PostPlaylistErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostPlaylistErrorState("Check Internet Connection"));
    } on FormatException catch (_) {
      emit(ServerDown());
    } catch (e, s) {
      emit(PostPlaylistErrorState("$e $s"));
    }
  }
}
