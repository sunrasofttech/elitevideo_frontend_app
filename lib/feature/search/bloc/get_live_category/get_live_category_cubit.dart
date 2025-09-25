import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/utils/header.dart';
import 'get_live_category_model.dart';
part 'get_live_category_state.dart';

class GetLiveCategoryCubit extends Cubit<GetLiveCategoryState> {
  GetLiveCategoryCubit() : super(GetLiveCategoryInitial());

  getAllLiveCategory() async {
    try {
      emit(GetLiveCategoryLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.liveTvCategory}/get-all"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetLiveCategoryLoadedState(
              getLiveCategoryModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetLiveCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetLiveCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetLiveCategoryErrorState("$e $s"));
    }
  }
}
