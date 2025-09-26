import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/music/bloc/get_choose_for_you/get_choose_for_you_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'get_choose_for_you_state.dart';

class GetChooseForYouCubit extends Cubit<GetChooseForYouState> {
  GetChooseForYouCubit() : super(GetChooseForYouInitial());

  getAllMusic({String? search}) async {
    try {
      emit(GetChooseForYouLoadingState());

      final uri = Uri.parse("${AppUrls.baseUrl}/api/ott/choosen-for-u-music?user_id=$userId");

      final response = await get(
        uri,
        headers: Header.header,
      );

      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetChooseForYouLoadedState(
              getChooseForYouModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetChooseForYouErrorState("${result['message']}"));
        }
      } else {
        emit(GetChooseForYouErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetChooseForYouErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetChooseForYouErrorState("$e $s"));
    }
  }
}
