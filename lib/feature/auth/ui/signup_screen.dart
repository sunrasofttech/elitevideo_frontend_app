import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/bloc/login/login_cubit.dart';
import 'package:elite/feature/auth/bloc/register_user/register_user_cubit.dart';
import 'package:elite/feature/auth/model/jwt_model.dart';
import 'package:elite/feature/auth/ui/login_screen.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/storage/storage.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textformfield.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Utility {
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
                    text: "Signup with your email".tr(),
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
                  sb30h(),
                  sb30h(),
                  sb30h(),
                  TextFormFieldWidget(
                    rounded: 30,
                    hintText: "Name".tr(),
                    hintTextColor: AppColor.navColor,
                    controller: nameController,
                  ),
                  sb20h(),
                  TextFormFieldWidget(
                    rounded: 30,
                    hintText: "Email".tr(),
                    hintTextColor: AppColor.navColor,
                    controller: emailController,
                  ),
                  sb20h(),
                  TextFormFieldWidget(
                    rounded: 30,
                    hintText: "Mobile".tr(),
                    showPrefix: true,
                    inputFormater: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: TextWidget(
                        text: '+91',
                        fontSize: 18,
                        color: AppColor.navColor,
                      ),
                    ),
                    hintTextColor: AppColor.navColor,
                    controller: mobileController,
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
                  sb20h(),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        AppToast.showError(context, "Login", state.error.toString());
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
                    builder: (context, loginState) {
                      return BlocConsumer<RegisterUserCubit, RegisterUserState>(
                        listener: (context, state) async {
                          if (state is RegisterUserErrorState) {
                            AppToast.showError(context, "Register", state.error.toString());
                            return;
                          }

                          if (state is RegisterUserLoadedState) {
                            final cubit = context.read<LoginCubit>();
                            await cubit.logDeviceInfo();
                            cubit.login(emailController.text.trim(), passwordController.text.trim());
                          }
                        },
                        builder: (context, state) {
                          return GradientButton(
                            inProgress: (state is RegisterUserLoadingState || loginState is LoginLoadingState),
                            text: ' Sign up'.tr(),
                            onTap: () {
                              context.read<RegisterUserCubit>().registerUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    mobileNo: mobileController.text,
                                  );
                            },
                          );
                        },
                      );
                    },
                  ),
                  sb30h(),
                  RichText(
                    text: TextSpan(
                      text: 'Already a user? '.tr(),
                      style: const TextStyle(color: AppColor.navColor, fontSize: 17),
                      children: [
                        TextSpan(
                          text: ' Login'.tr(),
                          style: const TextStyle(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
