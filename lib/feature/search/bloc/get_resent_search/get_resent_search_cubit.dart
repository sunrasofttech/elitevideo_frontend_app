import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

import 'get_resent_search_model.dart';

part 'get_resent_search_state.dart';

class GetResentSearchCubit extends Cubit<GetResentSearchState> {
  GetResentSearchCubit() : super(GetResentSearchInitial());

  getResentSearch() async {
    try {
      emit(GetResentSearchLoadingState());
      var response = await get(
        Uri.parse("${AppUrls.baseUrl}/api/ott/recent-search?user_id=$userId"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("message getResentSearch => $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetResentSearchLoadedState(
              resentSearchModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetResentSearchErrorState("${result['message']}"));
        }
      } else {
        emit(GetResentSearchErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetResentSearchErrorState("$e $s"));
    }
  }
}
