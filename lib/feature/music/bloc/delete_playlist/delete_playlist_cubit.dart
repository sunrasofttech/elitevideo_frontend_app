import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

part 'delete_playlist_state.dart';

class DeletePlaylistCubit extends Cubit<DeletePlaylistState> {
  DeletePlaylistCubit() : super(DeletePlaylistInitial());

  deletePlaylist({required String musicId}) async {
    try {
      emit(DeletePlaylistLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.baseUrl}/api/ott/playlist/$musicId"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("--==>>$result ${AppUrls.baseUrl}/api/ott/music/$musicId ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(DeletePlaylistLoadedState());
        } else {
          emit(DeletePlaylistErrorState("${result['message']}"));
        }
      } else {
        emit(DeletePlaylistErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(DeletePlaylistErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(DeletePlaylistErrorState("$e $s"));
    }
  }
}
