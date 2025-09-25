import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/music/bloc/get_data_by_artist_and_language/get_data_by_artist_and_language_model.dart';
import 'package:elite/utils/header.dart';

part 'get_data_by_artist_and_language_state.dart';

class GetDataByArtistAndLanguageCubit extends Cubit<GetDataByArtistAndLanguageState> {
  GetDataByArtistAndLanguageCubit() : super(GetDataByArtistAndLanguageInitial());

  getAllMusic({String? artistId, String? languageId}) async {
    try {
      emit(GetDataByArtistAndLanguageLoadingState());

      final queryParams = <String, String>{};

      if (artistId != null) queryParams['artist_id'] = artistId;
      if (languageId != null) queryParams['language_id'] = languageId;

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/music/artist").replace(queryParameters: queryParams);

      final response = await get(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("================>>>>> $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetDataByArtistAndLanguageLoadedState(
              getDataByArtistIdAndLanguageIdModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetDataByArtistAndLanguageErrorState("${result['message']}"));
        }
      } else {
        emit(GetDataByArtistAndLanguageErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetDataByArtistAndLanguageErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetDataByArtistAndLanguageErrorState("$e $s"));
    }
  }
}
