import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_model.dart';
import 'package:elite/utils/header.dart';
part 'get_live_tv_state.dart';

class GetLiveTvCubit extends Cubit<GetLiveTvState> {
  GetLiveTvCubit() : super(GetLiveTvInitial());

  getAllLiveCategory({
    String? search,
    String? liveCatId,
  }) async {
    try {
      emit(GetLiveTvLoadingState());

      final queryParams = <String, String>{};

      if (search != null && search.isNotEmpty) {
        queryParams['name'] = search;
      }

      if (liveCatId != null && liveCatId.isNotEmpty) {
        queryParams['live_category_id'] = liveCatId;
      }

      final uri = Uri.parse("${AppUrls.liveTvUrl}/get-all").replace(queryParameters: queryParams);

      final response = await post(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());

      log("message = = = = $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetLiveTvLoadedState(
              getLiveModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetLiveTvErrorState("${result['message']}"));
        }
      } else {
        emit(GetLiveTvErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetLiveTvErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetLiveTvErrorState("$e $s"));
    }
  }
}
