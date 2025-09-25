import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';

part 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  PaymentHistoryCubit() : super(PaymentHistoryInitial());

  paymentHistory({
    String? amount,
    String? orderId,
    bool? isSubscrption,
  }) async {
    try {
      var body = {
        "user_id": userId,
        "status": "completed",
        "amount": amount,
        "order_id": orderId,
        "type": isSubscrption ?? false ? "subscription" : "rented"
      }..removeWhere(
          (k, v) => v == null,
        );
      emit(PaymentHistoryLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.baseUrl}/api/ott/payment-history"),
        body: json.encode(
          body,
        ),
        headers: Header.header,
      );
      final result = jsonDecode(response.body.toString());
      log("Result : = > postContinueWatching $body $result ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(PaymentHistoryLoadedState());
        } else {
          emit(PaymentHistoryErrorState("${result['message']}"));
        }
      } else {
        emit(PaymentHistoryErrorState("${result['message']}"));
      }
    } on SocketException {
      emit(PaymentHistoryErrorState("Check Internet Connection"));
    } catch (e, s) {
      emit(PaymentHistoryErrorState("$e $s"));
    }
  }
}
