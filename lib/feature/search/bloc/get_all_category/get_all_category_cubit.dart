import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/search/bloc/get_all_category/get_all_category_model.dart';
import 'package:elite/utils/header.dart';
part 'get_all_category_state.dart';

class GetAllMovieCategoryCubit extends Cubit<GetAllCategoryState> {
  GetAllMovieCategoryCubit() : super(GetAllCategoryInitial());

  getAllMovieCategory({
    String? name,
  }) async {
    try {
      emit(GetAllCategoryLoadingState());
      final queryParams = <String, String>{};
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      final uri = Uri.parse("${AppUrls.movieCategoryUrl}/get-all").replace(
        queryParameters: queryParams,
      );

      final response = await post(
        uri,
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("${result} ${Header.header} ${AppUrls.movieCategoryUrl}/get-all");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllCategoryLoadedState(
              getAllMovieCategoryModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCategoryErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCategoryErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCategoryErrorState("$e $s"));
    }
  }
}
