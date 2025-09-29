import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import 'get_all_trailer_model.dart';

part 'get_all_trailer_state.dart';

class GetAllTrailerCubit extends Cubit<GetAllTrailerState> {
  GetAllTrailerCubit() : super(GetAllTrailerInitial());

  getAllTrailer({String? movieName}) async {
    try {
      emit(GetAllTrailerLoadingState());

      final queryParams = {'movie_name': movieName ?? '',};

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/trailor").replace(queryParameters: queryParams);
      log("getAllTrailer -----------  $uri");
      final response = await get(uri, headers: Header.header,);

      final result = jsonDecode(response.body);
      log("getAllTrailer =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(GetAllTrailerLoadedState(getAllTrailorsModelFromJson(json.encode(result))));
        } else {
          emit(GetAllTrailerErrorState(result["message"]));
        }
      } else {
        emit(GetAllTrailerErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllTrailerErrorState("catch error $e, $s"));
    }
  }
}
