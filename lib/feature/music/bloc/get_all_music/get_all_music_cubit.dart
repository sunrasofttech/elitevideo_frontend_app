import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_model.dart';
import 'package:elite/utils/header.dart';

import '../../../../constant/app_urls.dart';
part 'get_all_music_state.dart';

class GetAllMusicCubit extends Cubit<GetAllMusicState> {
  GetAllMusicCubit() : super(GetAllMusicInitial());

  getAllMusic({
    String? search,
    String? categoryId,
  }) async {
    try {
      emit(GetAllMusicLoadingState());

      final uri = Uri.parse("${AppUrls.musicUrl}/get-all").replace(queryParameters: {
        if (search != null && search.trim().isNotEmpty) "search": search.trim(),
        if (categoryId != null && categoryId.trim().isNotEmpty) "category_id": categoryId.trim(),
      });

      var response = await post(
        uri,
           headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getAllMusic =>  $result $uri");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMusicLoadedState(
              getMusicModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMusicErrorState(result["message"]));
        }
      } else {
        emit(GetAllMusicErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetAllMusicErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllMusicErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
