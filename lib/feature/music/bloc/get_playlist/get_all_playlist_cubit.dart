import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/music/bloc/get_playlist/get_all_playlist_model.dart';
import 'package:elite/main.dart';
import '../../../../utils/header.dart';
part 'get_all_playlist_state.dart';

class GetAllPlaylistCubit extends Cubit<GetAllPlaylistState> {
  GetAllPlaylistCubit() : super(GetAllPlaylistInitial());

  getAllPlaylist({String? search}) async {
    try {
      emit(GetAllPlaylistLoadingState());

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/playlist/user/$userId");

      final response = await get(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body.toString());
      log("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=>>>> $result $uri");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllPlaylistLoadedState(
              getPlaylistModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllPlaylistErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllPlaylistErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetAllPlaylistErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllPlaylistErrorState("$e $s"));
    }
  }
}
