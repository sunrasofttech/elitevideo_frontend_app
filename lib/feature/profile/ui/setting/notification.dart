import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:elite/utils/storage/noti.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../../constant/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with Utility {
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    final enabled = await NotificationPreference.isEnabled();
    setState(() {
      _isEnabled = enabled;
    });
  }

  Future<void> _onSwitchChanged(bool value) async {
    setState(() => _isEnabled = value);
    await NotificationPreference.setEnabled(value);

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('all');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('all');
    }
  }

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
                      text: "Notification".tr(),
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
                    TextWidget(
                      text: "Want to show push notification".tr(),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    Switch(
                      value: _isEnabled,
                      activeColor: AppColor.blueColor,
                      onChanged: _onSwitchChanged,
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
