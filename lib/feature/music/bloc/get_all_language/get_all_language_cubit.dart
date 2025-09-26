import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';

import 'get_all_language_model.dart';
part 'get_all_language_state.dart';

class GetAllLanguageCubit extends Cubit<GetAllLanguageState> {
  GetAllLanguageCubit() : super(GetAllLanguageInitial());

  getAllLanguage({String? name}) async {
    try {
      emit(GetAllLanguageLoadingState());

      final queryParams = <String, String>{};
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      final uri = Uri.parse("${AppUrls.movieLanguageUrl}/get-all").replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await post(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllLanguageLoadedState(
              getMovieLanguageModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllLanguageErrorState(result["message"]));
        }
      } else {
        emit(GetAllLanguageErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllLanguageErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
