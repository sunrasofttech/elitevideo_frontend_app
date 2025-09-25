import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/auth/ui/login_screen.dart';
import 'package:elite/feature/auth/ui/signup_screen.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with Utility {
  @override
  void initState() {
    context.read<GetSettingCubit>().getSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomAuthDesignScreen(
          data: BlocBuilder<GetSettingCubit, GetSettingState>(
            builder: (context, state) {
              if (state is GetSettingLoadingState) {
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              }
              if (state is GetSettingErrorState) {
                return const Center(
                  child: CustomErrorWidget(),
                );
              }
              if (state is GetSettingLoadedState) {
                var splash1 = "${state.model.setting?.spashScreenBanner1}";
                var splash2 = "${state.model.setting?.spashScreenBanner2}";
                var splash3 = "${state.model.setting?.spashScreenBanner3}";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sb30h(),
                        sb30h(),
                        Transform.rotate(
                          angle: -10 * 3.1415926535 / 180,
                          child: CachedNetworkImage(
                            imageUrl: splash1,
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CustomCircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "asset/test/first.jpg",
                              height: 130,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        sb15h(),
                        Transform.rotate(
                          angle: -10 * 3.1415926535 / 180,
                          child: CachedNetworkImage(
                            imageUrl: splash2,
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CustomCircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "asset/test/second.jpg",
                              height: 130,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        sb15h(),
                        Transform.rotate(
                          angle: -10 * 3.1415926535 / 180,
                          child: CachedNetworkImage(
                            imageUrl: splash3,
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CustomCircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "asset/test/third.png",
                              height: 130,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        sb30h(),
                        TextWidget(
                          text: "Onboarding".tr(),
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        sb20h(),
                        TextWidget(
                          textAlign: TextAlign.center,
                          text: "watch everything you want \nfor free!".tr(),
                          color: AppColor.greyColor,
                          fontSize: 14,
                        ),
                        sb10h(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GradientButton(
                            width: MediaQuery.of(context).size.width * 0.5,
                            text: 'Sign up / Subscribe'.tr(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        sb20h(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: TextWidget(
                            textAlign: TextAlign.center,
                            text: "Login".tr(),
                            color: AppColor.whiteColor,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
