import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
part 'post_report_state.dart';

class PostReportCubit extends Cubit<PostReportState> {
  PostReportCubit() : super(PostReportInitial());

  report({
    ContentType? contentType,
    String? contentId,
    String? reason,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "content_type": contentType?.name,
        "content_id": contentId,
        "reason": reason,
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PostReportLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/report/add"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > PostReportCubit $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PostReportLoadedState());
        } else {
          emit(PostReportErrorState("${result['message']}"));
        }
      } else {
        emit(PostReportErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PostReportErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PostReportErrorState("$e $s"));
    }
  }
}
