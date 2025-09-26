import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

import 'get_watchlist_model.dart';
part 'get_watchlist_state.dart';

class GetWatchlistCubit extends Cubit<GetWatchlistState> {
  GetWatchlistCubit() : super(GetWatchlistInitial());

  getWatchList({String? type}) async {
    try {
      emit(GetWatchlistLoadingState());
      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/watchlist/$userId")
          .replace(queryParameters: type != null ? {'type': type} : null);
      var response = await post(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetWatchlistLoadedState(
              getWatchListModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetWatchlistErrorState(result["message"]));
        }
      } else {
        emit(GetWatchlistErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetWatchlistErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetWatchlistErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
