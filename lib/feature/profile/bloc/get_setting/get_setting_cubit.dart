import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_model.dart';
import 'package:elite/utils/header.dart';
part 'get_setting_state.dart';

class GetSettingCubit extends Cubit<GetSettingState> {
  GetSettingCubit() : super(GetSettingInitial());

  getSetting() async {
    try {
      emit(GetSettingLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.settingUrl}/get"),
          headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSettingLoadedState(
              getSettingModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSettingErrorState(result["message"]));
        }
      } else {
        emit(GetSettingErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetSettingErrorState("Check Internet Connection"));
    }  catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetSettingErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
