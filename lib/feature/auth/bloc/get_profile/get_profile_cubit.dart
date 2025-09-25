import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileInitial());

  getProfile() async {
    try {
      emit(GetProfileLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.getProfileUrl}$userId"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > getProfile $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(GetProfileLoadedState(getUserModelFromJson(json.encode(result))));
        } else {
          emit(GetProfileErrorState("${result['message']}"));
        }
      } else {
        emit(GetProfileErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetProfileErrorState("Check Internet Connection"));
    } on FormatException catch (_) {
      emit(ServerDown());
    } catch (e, s) {
      emit(GetProfileErrorState("$e $s"));
    }
  }
}
