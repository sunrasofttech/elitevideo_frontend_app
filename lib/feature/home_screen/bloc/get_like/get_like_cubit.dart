import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_like/get_like_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
import '../../../../constant/app_string.dart';
part 'get_like_state.dart';

class GetLikeCubit extends Cubit<GetLikeState> {
  GetLikeCubit() : super(GetLikeInitial());

  getLike({required String typeId, required ContentType type}) async {
    try {
      emit(GetLikeLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/like/getlike?user_id=$userId&type=${type.name}&type_id=$typeId"),
    headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("GetLikeCubit => $result ${AppUrls.baseUrl}/api/ott/like/getlike?user_id=$userId&type=${type.name}&type_id=$typeId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetLikeLoadedState(
              getLikedModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetLikeErrorState(result["message"]));
        }
      } else {
        emit(GetLikeErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetLikeErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetLikeErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
