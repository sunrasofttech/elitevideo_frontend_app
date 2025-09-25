import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_model.dart';
import 'package:elite/utils/header.dart';
part 'get_all_series_state.dart';

class GetAllSeriesCubit extends Cubit<GetAllSeriesState> {
  GetAllSeriesCubit() : super(GetAllSeriesInitial());

  getAllSeries({
    String? languageId,
    String? categoryId,
    String? name,
    String? search,
  }) async {
    try {
      emit(GetAllSeriesLoadingState());

      final queryParams = <String, String>{
        'show_type': 'series',
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

      log("Series Url => $uri");
      final response = await post(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getAllSeries =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllSeriesLoadedState(getSeriesModelFromJson(json.encode(result))),
          );
        } else {
          emit(GetAllSeriesErrorState(result["message"]));
        }
      } else {
        emit(GetAllSeriesErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetAllSeriesErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(
        GetAllSeriesErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
