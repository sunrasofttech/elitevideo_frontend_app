import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';
part 'add_song_in_playlist_state.dart';

class AddSongInPlaylistCubit extends Cubit<AddSongInPlaylistState> {
  AddSongInPlaylistCubit() : super(AddSongInPlaylistInitial());

  addSongInPlaylist({required String playlistId, required String songId}) async {
    try {
      emit(AddSongInPlaylistLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/playlist/add-song"),
        body: json.encode(
          {
            "playlist_id": playlistId,
            "song_id": songId,
          },
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("--==>>$result ${AppUrls.baseUrl}/api/ott/playlist/add-song $playlistId $songId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(AddSongInPlaylistLoadedState());
        } else {
          emit(AddSongInPlaylistErrorState("${result['message']}"));
        }
      } else {
        emit(AddSongInPlaylistErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(AddSongInPlaylistErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(AddSongInPlaylistErrorState("$e $s"));
    }
  }
}
