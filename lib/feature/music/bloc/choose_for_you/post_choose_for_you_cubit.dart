import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'post_choose_for_you_state.dart';

class PostChooseForYouCubit extends Cubit<PostChooseForYouState> {
  PostChooseForYouCubit() : super(PostChooseForYouInitial());

  postChoose({required String musicId}) async {
    try {
      emit(PostChooseForYouLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/choosen-for-u-music"),
        body: json.encode(
          {
            "user_id": userId,
            "music_id": musicId,
          },
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("--==>>$result ${AppUrls.baseUrl}/api/ott/music/$musicId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostChooseForYouLoadedState());
        } else {
          emit(PostChooseForYouErrorState("${result['message']}"));
        }
      } else {
        emit(PostChooseForYouErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostChooseForYouErrorState("Check Internet Connection"));
    } on FormatException catch (_) {
      emit(ServerDown());
    } catch (e, s) {
      emit(PostChooseForYouErrorState("$e $s"));
    }
  }
}
