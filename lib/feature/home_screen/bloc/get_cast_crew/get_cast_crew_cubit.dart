import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_cast_crew/get_cast_crew_model.dart';
import 'package:elite/utils/header.dart';

part 'get_cast_crew_state.dart';

class GetCastCrewCubit extends Cubit<GetCastCrewState> {
  GetCastCrewCubit() : super(GetCastCrewInitial());

  getCastCrew({String? movieId}) async {
    try {
      emit(GetCastCrewLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/movie/cast-crew/by-movie/$movieId"),
          headers: Header.header,
      );
      final result = jsonDecode(response.body);
      log("getCastCrew => $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetCastCrewLoadedState(
              getCastCrewModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetCastCrewErrorState(result["message"]));
        }
      } else {
        emit(GetCastCrewErrorState(result["message"]));
      }
    } on SocketException {
      emit(GetCastCrewErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetCastCrewErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
