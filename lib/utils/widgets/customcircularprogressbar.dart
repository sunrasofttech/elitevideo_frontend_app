import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  State<CustomCircularProgressIndicator> createState() => _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState extends State<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: AppColor.blackColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColor.whiteColor,
        ),
      ),
    );
  }
}
