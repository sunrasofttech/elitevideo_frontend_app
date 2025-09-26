import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/bloc/login/login_cubit.dart';
import 'package:elite/feature/auth/model/jwt_model.dart';
import 'package:elite/feature/auth/ui/signup_screen.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/feature/profile/bloc/logout/logout_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/storage/storage.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textformfield.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Utility {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> showPassword = ValueNotifier(true);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    showPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomAuthDesignScreen(
          data: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextWidget(
                    text: "Login with your email".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppColor.whiteColor,
                    ),
                  ),
                  sb20h(),
                  const TextWidget(
                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    textAlign: TextAlign.center,
                    color: AppColor.navColor,
                    fontSize: 12,
                  ),
                  sb40h(),
                  sb30h(),
                  TextFormFieldWidget(
                    rounded: 30,
                    hintText: "Email".tr(),
                    hintTextColor: AppColor.navColor,
                    controller: emailController,
                  ),
                  sb20h(),
                  ValueListenableBuilder<bool>(
                      valueListenable: showPassword,
                      builder: (context, pass, _) {
                        return TextFormFieldWidget(
                          rounded: 30,
                          obscureText: pass,
                          hintText: "Password".tr(),
                          isSuffixIconShow: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              pass ? Icons.visibility_off : Icons.visibility,
                              color: const Color.fromRGBO(184, 231, 255, 1),
                            ),
                            onPressed: () {
                              showPassword.value = !showPassword.value;
                            },
                          ),
                          hintTextColor: AppColor.navColor,
                          controller: passwordController,
                        );
                      }),
                  sb40h(),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        AppToast.showError(context, "Login Error", state.error);
                        return;
                      }

                      if (state is LoginLoadedState) {
                        AppToast.showSuccess(context, "Login", state.model.message.toString());
                        String token = state.model.token ?? "";
                        LocalStorageUtils.saveToken(token);
                        JwtModel decodedToken = JwtModel.fromJson(
                          JwtDecoder.decode(token),
                        );
                        String? id = decodedToken.id;
                        userId = decodedToken.id;
                        token = state.model.token ?? "";
                        LocalStorageUtils.saveUserId(id ?? "")?.then((e) => {
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
                      }
                    },
                    builder: (context, state) {
                      return GradientButton(
                        inProgress: (state is LoginLoadingState),
                        text: 'Continue'.tr(),
                        onTap: () async {
                          final cubit = context.read<LoginCubit>();
                          await cubit.logDeviceInfo();
                          cubit.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                      );
                    },
                  ),
                  sb30h(),
                  RichText(
                    text: TextSpan(
                      text: "New  to App? ".tr(),
                      style: const TextStyle(color: AppColor.navColor, fontSize: 16),
                      children: [
                        TextSpan(
                          text: ' Sign up'.tr(),
                          style: const TextStyle(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  sb30h(),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      if (state is LoginErrorState && state.error.contains("maximum allowed devices")) {
                        return BlocListener<LogoutCubit, LogoutState>(
                          listener: (context, state) async {
                            if (state is LogoutErrorState) {
                              AppToast.showError(context, "Logout", state.error.toString());
                            }
                            if (state is LogoutLoadedState) {
                              final cubit = context.read<LoginCubit>();
                              await cubit.logDeviceInfo();
                              cubit.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                text: "You've reached the maximum allowed devices. Please logout from one to continue.",
                                style: TextStyle(color: Colors.redAccent, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ...state.model?.activeDevices?.map((device) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppColor.greyColor,
                                            )),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                          title: TextWidget(
                                            text: device.deviceId ?? 'Unknown Device',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text: 'Model: ${device.model}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              TextWidget(
                                                text: 'Logged in at: ${device.loginTime}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              context.read<LogoutCubit>().logout(
                                                    state.model?.userId.toString() ?? "",
                                                    device.deviceId ?? "",
                                                  );
                                            },
                                            icon: const Icon(
                                              Icons.logout,
                                              color: AppColor.redColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
