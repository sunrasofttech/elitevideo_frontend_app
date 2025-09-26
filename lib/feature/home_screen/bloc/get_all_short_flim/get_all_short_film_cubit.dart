import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_model.dart';
import 'package:elite/utils/header.dart';
part 'get_all_short_film_state.dart';

class GetAllShortFilmCubit extends Cubit<GetAllShortFilmState> {
  GetAllShortFilmCubit() : super(GetAllShortFilmInitial());

  getAllShortFilm({
    String? shortFilmTitle,
    String? language,
    String? genre,
  }) async {
    try {
      emit(GetAllShortFilmLoadingState());

      final queryParams = {
        if (shortFilmTitle != null && shortFilmTitle.trim().isNotEmpty) 'short_film_title': shortFilmTitle.trim(),
        if (language != null && language.trim().isNotEmpty) 'language': language.trim(),
        if (genre != null && genre.trim().isNotEmpty) 'genre': genre.trim(),
      };

      final uri = Uri.parse("${AppUrls.shortFlimUrl}/get-all").replace(queryParameters: queryParams);

      log("getAllShortFilm URL => $uri");

      var response = await post(
        uri,
         headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getAllShortFilm =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllShortFilmLoadedState(
              getAllShortFilmModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllShortFilmErrorState(result["message"]));
        }
      } else {
        emit(GetAllShortFilmErrorState(result["message"]));
      }
    }  on SocketException {
      emit(GetAllShortFilmErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllShortFilmErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
