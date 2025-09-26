import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'get_continue_watching_state.dart';

class GetContinueWatchingCubit extends Cubit<GetContinueWatchingState> {
  GetContinueWatchingCubit() : super(GetContinueWatchingInitial());

  getContinueWatching() async {
    try {
      emit(GetContinueWatchingLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/continue-watching/list?user_id=$userId");
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getContinueWatching => ${AppUrls.baseUrl}/api/ott/continue-watching/list?user_id=$userId $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetContinueWatchingLoadedState(
              continueWatchingModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetContinueWatchingErrorState(result["message"]));
        }
      } else {
        emit(GetContinueWatchingErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetContinueWatchingErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetContinueWatchingErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
