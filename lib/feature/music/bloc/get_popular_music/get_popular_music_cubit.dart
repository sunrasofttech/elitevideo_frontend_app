import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/music/bloc/get_popular_music/get_popular_music_model.dart';
import 'package:elite/utils/header.dart';

part 'get_popular_music_state.dart';

class GetPopularMusicCubit extends Cubit<GetPopularMusicState> {
  GetPopularMusicCubit() : super(GetPopularMusicInitial());

  getAllMusic({String? search}) async {
    try {
      emit(GetPopularMusicLoadingState());

      final uri = Uri.parse("${AppUrls.musicUrl}/get-all?is_popular=true");

      final response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetPopularMusicLoadedState(
              getPopularMusicModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetPopularMusicErrorState("${result['message']}"));
        }
      } else {
        emit(GetPopularMusicErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetPopularMusicErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetPopularMusicErrorState("$e $s"));
    }
  }
}
