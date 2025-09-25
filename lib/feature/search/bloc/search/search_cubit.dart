import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/search/bloc/search/search_mode.dart';
import 'package:elite/utils/header.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  search({String? keyword}) async {
    log("$keyword");
    try {
      emit(SearchLoadingState());
      String url;
      if (keyword == null || keyword.trim().isEmpty) {
        url = "${AppUrls.baseUrl}/api/ott/search";
      } else {
        url = "${AppUrls.baseUrl}/api/ott/search?keyword=${Uri.encodeComponent(keyword)}";
      }

      var response = await post(
        Uri.parse(url),
        headers: Header.header,
      );

      final result = jsonDecode(response.body.toString());
      log("Result : = > search $result ${Header.header} ${AppUrls.baseUrl}/api/ott/search?keyword=$keyword");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            SearchLoadedState(
              searchModelFromJson(
                jsonEncode(result),
              ),
            ),
          );
        } else {
          emit(SearchErrorState("${result['message']}"));
        }
      } else {
        emit(SearchErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(SearchErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(SearchErrorState("$e $s"));
    }
  }
}
