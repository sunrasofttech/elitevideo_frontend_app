import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_model.dart';
import 'package:elite/utils/header.dart';
part 'get_all_tv_show_state.dart';

class GetAllTvShowSeriesCubit extends Cubit<GetAllTVSeriesState> {
  GetAllTvShowSeriesCubit() : super(GetAllTVSeriesInitial());

  getAllSeries({
    String? languageId,
    String? categoryId,
    String? name,
    String? search,
  }) async {
    try {
      emit(GetAllTVSeriesLoadingState());

      final queryParams = <String, String>{
        'show_type': 'tvshows',
      };

      if (languageId != null && languageId.trim().isNotEmpty) {
        queryParams['language'] = languageId.trim();
      }
      if (categoryId != null && categoryId.trim().isNotEmpty) {
        queryParams['category'] = categoryId.trim();
      }
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['name'] = search.trim();
      }

      final uri = Uri.parse("${AppUrls.seriesUrl}/get-all").replace(
        queryParameters: queryParams,
      );

      log("GetAllTvShowSeriesCubit => $uri");
      final response = await post(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getAllSeries =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllTVSeriesLoadedState(
              getSeriesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllTVSeriesErrorState(result["message"]));
        }
      } else {
        emit(GetAllTVSeriesErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllTVSeriesErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
