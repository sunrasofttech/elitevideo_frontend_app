import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_model.dart';
import 'package:elite/utils/header.dart';
part 'get_subscription_state.dart';

class GetSubscriptionCubit extends Cubit<GetSubscriptionState> {
  GetSubscriptionCubit() : super(GetSubscriptionInitial());

  getAllSub() async {
    try {
      emit(GetSubscriptionLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.subscriptionPlanUrl}/get-all"),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetSubscriptionLoadedState(
              getAllSubscriptionModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetSubscriptionErrorState("${result['message']}"));
        }
      } else {
        emit(GetSubscriptionErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(GetSubscriptionErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetSubscriptionErrorState("$e $s"));
    }
  }
}
