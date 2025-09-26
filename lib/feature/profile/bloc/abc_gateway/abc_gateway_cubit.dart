import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/profile/bloc/abc_gateway/abc_gateway_model.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
part 'abc_gateway_state.dart';

class AbcGatewayCubit extends Cubit<AbcGatewayState> {
  AbcGatewayCubit() : super(AbcGatewayInitial());

  abcGateway({
    String? amount,
    bool isSubscription = false,
    bool isCoin = false,
  }) async {
    try {
      emit(AbcGatewayLoadingState());
      String type = '';
      if (isSubscription) {
        type = "subscription";
      } else if (isCoin) {
        type = "coin";
      }
      Map<String, dynamic> requestBody = {
        "userId": userId,
        "amount": amount,
        "type": type,
      };
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/createpayment"),
        body: json.encode(
          requestBody,
        ),
        headers: await Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("$result $requestBody ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            AbcGatewayLoadedState(
              abcGatewayModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(AbcGatewayErrorState("${result['message']}"));
        }
      } else {
        emit(AbcGatewayErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(AbcGatewayErrorState("$e $s"));
    }
  }
}
