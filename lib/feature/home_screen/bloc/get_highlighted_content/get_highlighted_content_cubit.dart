import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_highlighted_content/get_highlighted_content_model.dart';
import 'package:elite/utils/header.dart';

part 'get_highlighted_content_state.dart';

class GetHighlightedContentCubit extends Cubit<GetHighlightedContentState> {
  GetHighlightedContentCubit() : super(GetHighlightedContentInitial());

  getHighlightedContent() async {
    try {
      emit(GetHighlightedContentLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/highlighted-content"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getHighlightedContent => $result ${AppUrls.baseUrl}api/ott/highlighted-content ${Header.header}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetHighlightedContentLoadedState(
              getHighlightedContentModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetHighlightedContentErrorState(result["message"]));
        }
      } else {
        emit(GetHighlightedContentErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetHighlightedContentErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetHighlightedContentErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
