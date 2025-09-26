import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/ui/change_password.dart';
import 'package:elite/feature/profile/ui/edit_profile.dart';
import 'package:elite/feature/profile/ui/language.dart';
import 'package:elite/feature/profile/ui/setting/download_screen.dart';
import 'package:elite/feature/profile/ui/setting/notification.dart';
import 'package:elite/feature/profile/ui/setting/rented_movie.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_detail.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custom_html_data.dart';
import 'package:elite/utils/widgets/custom_svg.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<GetSettingCubit, GetSettingState>(
          builder: (context, state) {
            if (state is GetSettingLoadingState) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }

            if (state is GetSettingLoadedState) {
              return CustomAuthDesignScreen(
                center: false,
                data: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
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
                              text: "Settings".tr(),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        sb40h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.profileRoundedSvg,
                            height: 28,
                            width: 28,
                          ),
                          title: TextWidget(
                            text: "Profile Setting".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Set your Email, Password, Username".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageSelectionScreen(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.languageSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "App Language".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: getLanguageName(context.locale).tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingDownloadScreen(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.downloadSSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Download".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Set the quality of download".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RentedMovie(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.subscriptionSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Rented".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Subscription details & Device Manager".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionDetail(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.subscriptionSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Subscription".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Subscription details & Device Manager".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationScreen(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.notificationSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Notification".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Control the Notification Settings of App".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangePasswordScreen(),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.changePasswordSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Change Password".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Update your password".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomHtmlScreen(
                                    title: "Help Support".tr(), data: state.model.setting?.helpSupport ?? ""),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.helpSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Help Support".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Help Center".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomHtmlScreen(
                                    title: "Term & Condition".tr(), data: state.model.setting?.termsAndCondition ?? ""),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.helpSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Term & Condition".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "View the rules and conditions of using this app".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb5h(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomHtmlScreen(
                                  title: "Privacy Policy".tr(),
                                  data: state.model.setting?.privacyPolicy ?? "",
                                ),
                              ),
                            );
                          },
                          leading: const CustomSvgImage(
                            imageUrl: AppImages.helpSvg,
                            height: 25,
                            width: 25,
                          ),
                          title: TextWidget(
                            text: "Privacy Policy".tr(),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          subtitle: TextWidget(
                            text: "Learn how we collect, use, and protect your data".tr(),
                            color: AppColor.greyColor,
                          ),
                        ),
                        sb20h(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showLogoutDialog(context);
                            },
                            child: TextWidget(
                              text: "Logout".tr(),
                              fontSize: 17,
                              color: AppColor.blueColor,
                            ),
                          ),
                        ),
                        sb30h(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showDeleteAccountDialog(context);
                            },
                            child: TextWidget(
                              text: "Delete Account".tr(),
                              fontSize: 16,
                              color: AppColor.redColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
