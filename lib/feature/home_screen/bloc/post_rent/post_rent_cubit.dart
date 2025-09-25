import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/utils/header.dart';

import '../../../../constant/app_urls.dart';
import 'package:intl/intl.dart';
part 'post_rent_state.dart';

class PostRentCubit extends Cubit<PostRentState> {
  PostRentCubit() : super(PostRentInitial());

  postRent({
    String? seriesId,
    String? shortFilmId,
    String? movieId,
    String? userId,
    String? cost,
    String? validityDate,
  }) async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      var body = {
        "series_id": seriesId,
        "movie_id": movieId,
        "shortfilm_id": shortFilmId,
        "user_id": userId,
        "cost": cost,
        "rented_on": todayDate,
        "validity_date": validityDate,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostRentLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/rental"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );

      final curlCommand = StringBuffer();
      curlCommand.writeln("curl -X POST \\");
      curlCommand.writeln("  '${AppUrls.baseUrl}/api/ott/rental' \\");

      curlCommand.writeln("  -d '$body'");

      log("🔄 CURL REQUEST:\n$curlCommand");

      final result = jsonDecode(response.body.toString());
      log("Result : = > postWatchList $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostRentLoadedState());
        } else {
          emit(PostRentErrorState("${result['message']}"));
        }
      } else {
        emit(PostRentErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostRentErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostRentErrorState("$e $s"));
    }
  }
}
