import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/utils/utility.dart';

class CustomEmptyWidget extends StatefulWidget {
  const CustomEmptyWidget({super.key});

  @override
  State<CustomEmptyWidget> createState() => _CustomEmptyWidgetState();
}

class _CustomEmptyWidgetState extends State<CustomEmptyWidget> with Utility {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppImages.noDataLottie,
            height: 100,
          ),
        ],
      ),
    );
  }
}
