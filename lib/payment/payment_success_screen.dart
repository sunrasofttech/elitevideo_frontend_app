import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with Utility {
  int second = 5;

  @override
  void initState() {
    super.initState();
    context.read<GetSettingCubit>().getSetting();
    context.read<GetProfileCubit>().getProfile();
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
      backgroundColor: AppColor.blackColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                AppImages.successLottie,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              sb10h(),
              const TextWidget(
                text: "🎉 Payment Done Successfully 🎉",
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
      ),
    );
  }
}
