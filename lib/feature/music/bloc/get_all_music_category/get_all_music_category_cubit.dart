import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

import 'get_all_music_category_model.dart';
part 'get_all_music_category_state.dart';

class GetAllMusicCategoryCubit extends Cubit<GetAllMusicCategoryState> {
  GetAllMusicCategoryCubit() : super(GetAllMusicCategoryInitial());

  getAllMusic({String? search}) async {
    try {
      emit(GetAllMusicCategoryLoadingState());

     
      final uri = Uri.parse("${AppUrls.musicCategoryUrl}/get-all");

      final response = await post(
        uri,
          headers: Header.header,
      );

      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMusicCategoryLoadedState(
              getAllMusicModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMusicCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllMusicCategoryErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetAllMusicCategoryErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllMusicCategoryErrorState("$e $s"));
    }
  }
}
