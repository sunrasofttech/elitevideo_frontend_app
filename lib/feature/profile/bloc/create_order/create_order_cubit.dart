import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/profile/bloc/create_order/create_order_model.dart';
import 'package:elite/utils/header.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit() : super(CreateOrderInitial());

  createOrder({
    String? amount,
  }) async {
    try {
      emit(CreateOrderLoadingState());
      Map<String, dynamic> requestBody = {
        "amount": amount,
      };
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/order/create"),
        body: json.encode(
          requestBody,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > $result $requestBody");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            CreateOrderLoadedState(createOrderModelFromJson(json.encode(result))),
          );
        } else {
          emit(CreateOrderErrorState("${result['message']}"));
        }
      } else {
        emit(CreateOrderErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(CreateOrderErrorState("$e $s"));
    }
  }
}
