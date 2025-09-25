import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class CustomServerDown extends StatefulWidget {
  const CustomServerDown({super.key});

  @override
  State<CustomServerDown> createState() => _CustomServerDownState();
}

class _CustomServerDownState extends State<CustomServerDown> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppImages.error404Lottie),
            const TextWidget(
              text: "Server Down",
              fontSize: 20,
            ),
            sb15h(),
            GradientButton(
              text: 'Close App',
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
