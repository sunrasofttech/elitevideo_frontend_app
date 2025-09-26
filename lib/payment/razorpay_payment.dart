import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/home_screen/bloc/payment_history/payment_history_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_rent/post_rent_cubit.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/payment/payment_error_screen.dart';
import 'package:elite/payment/payment_success_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../feature/profile/bloc/create_order/create_order_cubit.dart';

class RazorpayScreen extends StatefulWidget {
  const RazorpayScreen({
    super.key,
    required this.amount,
    required this.subscriptionId,
    required this.razorPayKey,
    this.formattedDate,
    this.movieId,
    this.seriesId,
    this.shortFilmId,
    required this.isSubscription,
    required this.contectNo,
    this.email,
  });

  final String contectNo;
  final String? email;
  final int amount;
  final String? movieId;
  final String? seriesId;
  final String? shortFilmId;
  final String subscriptionId;
  final String razorPayKey;
  final String? formattedDate;
  final bool isSubscription;

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> with Utility {
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openRazorpayCheckout(String orderId, String amount) {
    log("message me contatc = > ${widget.contectNo} ${orderId} ${widget.email}");
    var options = {
      'key': widget.razorPayKey,
      'amount': amount,
      'order_id': orderId,
      'name': "No Title",
      'description': "No Description",
      'prefill': {'contact': widget.contectNo, 'email': widget.email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
      AppToast.showError(context, "Failed", "Failed to open Razorpay checkout");
    }
  }

  bool showCuponField = false;

  @override
  Widget build(BuildContext context) {
    log("$userId ${widget.amount} ${widget.email} ${widget.subscriptionId} ${widget.formattedDate}");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Column(
          children: [
            AppBar(
              forceMaterialTransparency: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                  color: AppColor.whiteColor,
                ),
              ),
              title: const TextWidget(
                text: "Pay with Razorpay",
                fontSize: 17,
                color: AppColor.whiteColor,
              ),
            ),
            const Divider(height: 0),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const TextWidget(
                text: 'Pay with Razorpay',
                color: AppColor.whiteColor,
                fontSize: 15,
              ),
              sb10h(),
              TextWidget(
                text: "Original Amount: ₹${widget.amount}",
                color: AppColor.whiteColor,
                fontSize: 17,
              ),
              const SizedBox(height: 8),
              BlocConsumer<CreateOrderCubit, CreateOrderState>(
                listener: (context, state) {
                  if (state is CreateOrderErrorState) {
                    AppToast.showError(context, "Order Error", state.error);
                    return;
                  }
                  if (state is CreateOrderLoadedState) {
                    openRazorpayCheckout(state.model.order?.orderId.toString() ?? "", state.model.order?.amount);
                  }
                },
                builder: (context, state) {
                  return GradientButton(
                    inProgress: state is CreateOrderLoadingState,
                    onTap: () {
                      context.read<CreateOrderCubit>().createOrder(
                            amount: widget.amount.toString(),
                          );
                    },
                    text: "Pay with Razorpay",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    log("Payment Failed Error : - $response Messsage : ${response.message} Code : ${response.code} Error : ${response.error}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentErrorScreen(),
      ),
    );
    //  context.read<PaymentFailedCubit>().paymentFailed(widget.amount.toString(), "${response.message}", "RazorPay");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    debugPrint("Payment Success: ${response.paymentId} ${widget.isSubscription}");
    if (!mounted) return;
    context.read<PaymentHistoryCubit>().paymentHistory(
          amount: widget.amount.toString(),
          isSubscrption: widget.isSubscription,
          orderId: response.orderId,
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
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessScreen(),
          ),
        );
      },
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "External Wallet Selected", "Wallet: ${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
      ),
    );
  }
}
