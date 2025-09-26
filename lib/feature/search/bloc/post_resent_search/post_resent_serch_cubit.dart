import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../../../../constant/app_string.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'post_resent_serch_state.dart';

class PostResentSerchCubit extends Cubit<PostResentSerchState> {
  PostResentSerchCubit() : super(PostResentSerchInitial());

  postResentSearch(
    ContentType type,
    String typeId,
  ) async {
    try {
      emit(PostResentSerchLoadingState());
      var response = await post(
        Uri.parse(
          "${AppUrls.baseUrl}/api/ott/recent-search",
        ),
        body: json.encode({
          "user_id": userId,
          "type": type.name,
          "type_id": typeId,
        }),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > post Resent Search $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostResentSerchLoadedState());
        } else {
          emit(
            PostResentSerchErrorState(
              result['message'],
            ),
          );
        }
      } else {
        emit(PostResentSerchErrorState(
          result['message'],
        ));
      }
    } on SocketException {
      emit(PostResentSerchErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(PostResentSerchErrorState("$e $s"));
    }
  }
}
