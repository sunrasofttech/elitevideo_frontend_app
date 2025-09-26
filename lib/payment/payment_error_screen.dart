import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:lottie/lottie.dart';
import '../feature/dashboard/dashboard.dart';

class PaymentErrorScreen extends StatefulWidget {
  const PaymentErrorScreen({super.key, this.message});
  final String? message;

  @override
  State<PaymentErrorScreen> createState() => _PaymentErrorScreenState();
}

class _PaymentErrorScreenState extends State<PaymentErrorScreen> with Utility {
  int second = 5;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (second == 1) {
        timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              key: dashboardGlobalKey,
            ),
          ),
          (route) => false,
        );
      }
      setState(() {
        second--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppImages.errorLottie, height: MediaQuery.of(context).size.height * 0.5),
            const TextWidget(
              text: "Payment Failed !.",
              style: TextStyle(
                fontSize: 20,
                color: AppColor.whiteColor,
              ),
            ),
            sb5h(),
            const TextWidget(
              text: "Try after some time 😒😒",
              style: TextStyle(
                fontSize: 20,
                color: AppColor.whiteColor,
              ),
            ),
            sb10h(),
            TextWidget(
              text: "Redirecting in $second sec .......",
              color: AppColor.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
