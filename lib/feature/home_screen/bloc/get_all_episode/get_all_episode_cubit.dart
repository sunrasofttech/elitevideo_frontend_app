import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_model.dart';
import 'package:elite/utils/header.dart';

part 'get_all_episode_state.dart';

class GetAllEpisodeCubit extends Cubit<GetAllEpisodeState> {
  GetAllEpisodeCubit() : super(GetAllEpisodeInitial());

  getAllEpisode({
    String? name,
    String? seasonId,
    String? seriesId,
  }) async {
    try {
      emit(GetAllEpisodeLoadingState());

      final queryParams = <String, String>{};

      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (seasonId != null && seasonId.isNotEmpty) queryParams['season_id'] = seasonId;
      if (seriesId != null && seriesId.isNotEmpty) queryParams['series_id'] = seriesId;
      final uri = Uri.parse("${AppUrls.episodeUrl}/get-all").replace(queryParameters: queryParams);
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("getAllEpisode =>  $result $uri");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllEpisodeLoadedState(
              getEpisodeModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllEpisodeErrorState(result["message"]));
        }
      } else {
        emit(GetAllEpisodeErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetAllEpisodeErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllEpisodeErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
