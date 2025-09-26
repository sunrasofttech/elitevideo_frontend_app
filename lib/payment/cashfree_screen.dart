import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_model.dart';
import 'package:elite/feature/home_screen/bloc/payment_history/payment_history_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/model/cashfree_model.dart';
import 'package:elite/payment/payment_error_screen.dart';
import 'package:elite/payment/payment_success_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import '../../main.dart';

class CashFreeScreen extends StatefulWidget {
  const CashFreeScreen({
    Key? key,
    required this.amount,
    this.title = "",
    this.desc = "",
    required this.subscriptionId,
    required this.isSubscription,
    required this.appId,
    this.movieId,
    this.formattedDate,
    this.seriesId,
    this.shortFilmId,
    required this.secrectId,
  }) : super(key: key);

  final String? title;
  final String? desc;
  final int amount;
  final String subscriptionId;
  final bool isSubscription;
  final String? appId;
  final String? secrectId;
  final String? formattedDate;
  final String? movieId;
  final String? seriesId;
  final String? shortFilmId;

  @override
  State<CashFreeScreen> createState() => _CashFreeScreenState();
}

class _CashFreeScreenState extends State<CashFreeScreen> with Utility {
  String orderId = "";
  String paymentSessionId = "";
  CFEnvironment environment = CFEnvironment.PRODUCTION;
  String selectedId = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      context.read<GetProfileCubit>().getProfile();
    });
  }

  ValueNotifier<double> discountedAmount = ValueNotifier<double>(0.0);
  Future<void> getOrderIdAndSessionId(User? model) async {
    double totalAmount = discountedAmount.value != 0.0 ? discountedAmount.value : widget.amount.toDouble();
    var headers = {
      'X-Client-Secret': widget.secrectId,
      'X-Client-Id': widget.appId,
      'x-api-version': '2023-08-01',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var data = json.encode({
      "order_amount": totalAmount,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": model?.id?.toString() ?? "CREATOR123",
        "customer_name": model?.name ?? "CREATOR",
        "customer_email": model?.email ?? "-@cashfree.com",
        "customer_phone": model?.mobileNo ?? "+917972947285"
      },
      "order_meta": {"return_url": "https://b8af79f41056.eu.ngrok.io?order_id=order_123"}
    });
    var response = await repository.sendRequest.request(
      // 'https://sandbox.cashfree.com/pg/orders',
      'https://api.cashfree.com/pg/orders',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    log("message response me ${response}");
    if (response.statusCode == 200) {
      debugPrint("Cash free Model:- ${json.encode(response.data)}");
      CashFreeModel model = cashFreeModelFromJson(jsonEncode(response.data));
      setState(() {
        orderId = model.orderId ?? "";
        paymentSessionId = model.paymentSessionId ?? "";
      });
      debugPrint("Cash free Model orderId:- $orderId, paymentSessionId: $paymentSessionId");
    } else {
      debugPrint("response.statusMessage:- ${response.statusMessage}");
    }
  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint("create session error:- ${e.message}");
    }
    return null;
  }

  webCheckout() async {
    try {
      var session = createSession();
      debugPrint("Session --> $session");
      var theme =
          CFThemeBuilder().setNavigationBarBackgroundColorColor("#0000FF").setNavigationBarTextColor("#ffffff").build();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).setTheme(theme).build();
      var cfPaymentGateway = CFPaymentGatewayService();
      cfPaymentGateway.setCallback(
        (orderId) {
          context.read<PaymentHistoryCubit>().paymentHistory(
                amount: widget.amount.toString(),
                isSubscrption: widget.isSubscription,
                orderId: orderId,
              );
          if (widget.isSubscription) {
            context.read<UpdateProfileCubit>().updateProfile(
                  isSubscription: true,
                  subscriptionEndDate: widget.formattedDate,
                  subscriptionId: widget.subscriptionId,
                );
          } else {
            context.read<PostRentCubit>().postRent(
                  cost: widget.amount.toString(),
                  movieId: widget.movieId,
                  seriesId: widget.seriesId,
                  shortFilmId: widget.shortFilmId,
                  userId: userId,
                  validityDate: widget.formattedDate,
                );
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentSuccessScreen(),
            ),
          );
        },
        (CFErrorResponse p0, orderId) {
          debugPrint("Payment Failed:- ${p0.getMessage()}, ${p0.getCode()}, ${p0.getStatus()}");
          // showMessage(
          //   msg: p0.getMessage() == null || p0.getMessage() == ""
          //       ? "somethingWentWrong"
          //       : p0.getMessage() ?? "somethingWentWrong",
          // );
          // context.read<PaymentFailedCubit>().paymentFailed(widget.amount.toString(), "${p0.getMessage()}", "Cashfree");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentErrorScreen(),
            ),
          );
        },
      );
      cfPaymentGateway.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint("webCheckout catch error: ${e.message}");
    }
  }

  // void _applyCoupon() {
  //   if (_couponController.text.isEmpty) {
  //     showMessage(context, "Coupon Code cannot be empty");
  //     return;
  //   }
  //   final couponCode = _couponController.text.trim();
  //   context.read<CheckCuponCodeCubit>().getCuponCode(couponCode);
  // }

  //bool showCuponField = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetProfileCubit, GetProfileState>(
      listener: (context, state) async {
        if (state is GetProfileErrorState) {}

        if (state is GetProfileLoadedState) {
          await getOrderIdAndSessionId(state.model.user);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.whiteColor,
          ),
          forceMaterialTransparency: true,
          title: const TextWidget(
            text: 'CashFree Payment',
            fontSize: 17,
            color: AppColor.whiteColor,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                sb10h(),
                TextWidget(
                  text: "Original Amount: ₹${widget.amount}",
                  color: AppColor.whiteColor,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<double>(
                  valueListenable: discountedAmount,
                  builder: (context, value, _) {
                    final discounted = value != 0.0;
                    final totalAmount = discounted ? value : double.parse(widget.amount.toString());
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (discounted)
                          Text(
                            "Discounted Amount: ₹${value.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total to Pay: ₹${totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                GradientButton(
                  onTap: webCheckout,
                  text: "Continue to pay",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
