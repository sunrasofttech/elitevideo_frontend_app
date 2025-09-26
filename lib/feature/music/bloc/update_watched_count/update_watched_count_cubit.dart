import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';
part 'update_watched_count_state.dart';

class UpdateWatchedCountCubit extends Cubit<UpdateWatchedCountState> {
  UpdateWatchedCountCubit() : super(UpdateWatchedCountInitial());

  updateWatched({required int count, required String musicId}) async {
    try {
      emit(UpdateWatchedCountLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.baseUrl}/api/ott/music/$musicId"),
        body: json.encode(
          {
            "watched_count": "${count + 1}",
          },
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("--==>>$result ${AppUrls.baseUrl}/api/ott/music/$musicId ${count + 1} ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateWatchedCountLoadedState());
        } else {
          emit(UpdateWatchedCountErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateWatchedCountErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(UpdateWatchedCountErrorState("Check Internet Connection"));
    } on FormatException catch (_) {
      emit(ServerDown());
    } catch (e, s) {
      emit(UpdateWatchedCountErrorState("$e $s"));
    }
  }
}
