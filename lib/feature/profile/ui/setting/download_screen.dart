import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class SettingDownloadScreen extends StatefulWidget {
  const SettingDownloadScreen({super.key});

  @override
  State<SettingDownloadScreen> createState() => _SettingDownloadScreenState();
}

class _SettingDownloadScreenState extends State<SettingDownloadScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomAuthDesignScreen(
          center: false,
          data: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor.backgroundGreyColor,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextWidget(
                      text: "Download".tr(),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                sb30h(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                       child: TextWidget(
                        text: "Download only on Wi-Fi for this device".tr(),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                                           ),
                     ),
                    Switch(
                      value: true,
                      activeColor: AppColor.blueColor,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
