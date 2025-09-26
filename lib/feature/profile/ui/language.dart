import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../utils/widgets/custom_auth_design.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  LanguageSelectionScreenState createState() => LanguageSelectionScreenState();
}

class LanguageSelectionScreenState extends State<LanguageSelectionScreen> with Utility {
  Locale selectedLocale = const Locale('en', 'US');

  final Map<String, Locale> languageMap = {
    'English': const Locale('en', 'US'),
    'Hindi': const Locale('hi', 'US'),
    'Marathi': const Locale('mr', 'IN'),
    // 'Tamil': const Locale('ta', 'IN'),
    // 'Telugu': const Locale('te', 'IN'),
  };

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
                      text: "Language".tr(),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                sb30h(),
                Text(
                  'Select your preferred\nLanguage'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ),
                const SizedBox(height: 30),
                ...languageMap.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RadioListTile<Locale>(
                        value: entry.value,
                        groupValue: selectedLocale,
                        onChanged: (value) {
                          setState(() {
                            selectedLocale = value!;
                          });
                        },
                        title: Text(
                          entry.key,
                          style: const TextStyle(
                            color: AppColor.whiteColor,
                          ),
                        ),
                        activeColor: AppColor.whiteColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                sb15h(),
                GradientButton(
                  text: 'Save'.tr(),
                  onTap: () {
                    context.setLocale(selectedLocale).then((e) => {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                key: dashboardGlobalKey,
                              ),
                            ),
                            (route) => false,
                          ),
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
