import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_model.dart';
import 'package:elite/utils/header.dart';
part 'get_most_viewed_state.dart';

class GetMostViewedCubit extends Cubit<GetMostViewedState> {
  GetMostViewedCubit() : super(GetMostViewedInitial());

  getMostViewedMovie() async {
    try {
      emit(GetMostViewedLoadingState());
      var response = await post(
        Uri.parse(AppUrls.getMostViewedMovieUrl),
    headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetMostViewedLoadedState(
              mostViewedModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetMostViewedErrorState(result["message"]));
        }
      } else {
        emit(GetMostViewedErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetMostViewedErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(
        GetMostViewedErrorState("catch error $e, $s"),
      );
    }
  }
}
