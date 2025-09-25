import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/profile/bloc/change_password/change_password_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/textformfield.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../utils/widgets/custombutton.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with Utility {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
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
                      text: "Change Password".tr(),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                sb40h(),
                sb20h(),
                TextFormFieldWidget(
                  controller: oldPasswordController,
                  rounded: 30,
                  backgroundColor: AppColor.backgroundGreyColor,
                  hintText: "Old Password".tr(),
                ),
                sb20h(),
                TextFormFieldWidget(
                  controller: newPasswordController,
                  rounded: 30,
                  backgroundColor: AppColor.backgroundGreyColor,
                  hintText: "New Password".tr(),
                ),
                sb30h(),
                BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                  listener: (context, state) {
                    if (state is ChangePasswordErrorState) {
                      AppToast.showError(context, state.error, "");
                      return;
                    }

                    if (state is ChangePasswordLoadedState) {
                      AppToast.showError(context, "Password", "Change Pass Successfully");
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    return GradientButton(
                      text: 'Save'.tr(),
                      onTap: () {
                        context.read<ChangePasswordCubit>().changePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                            );
                      },
                    );
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
