import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/constant/image_picker_utils.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/profile/bloc/update_profile/update_profile_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textformfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with Utility {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  XFile? selectedProfile;

  @override
  void initState() {
    context.read<GetProfileCubit>().getProfile();
    super.initState();
  }

  Future<void> _selectProfile() async {
    XFile? selectedImg = await ImagePickerUtil.pickImageFromGallery();
    setState(() {
      selectedProfile = selectedImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<GetProfileCubit, GetProfileState>(listener: (context, state) {
          if (state is GetProfileLoadedState) {
            nameController.text = state.model.user?.name ?? "";
            emailController.text = state.model.user?.email ?? "";
            mobileController.text = state.model.user?.mobileNo ?? "";
          }
        }, builder: (context, state) {
          return CustomAuthDesignScreen(
            center: false,
            data: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sb40h(),
                    sb40h(),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: AppColor.gradientColorList,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: selectedProfile != null
                                    ? Image.file(
                                        File(selectedProfile!.path),
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'asset/test/default.png',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: _selectProfile,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: AppColor.greenColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sb20h(),
                    TextFormFieldWidget(
                      rounded: 30,
                      backgroundColor: AppColor.backgroundGreyColor,
                      controller: nameController,
                      hintText: "Name".tr(),
                    ),
                    sb20h(),
                    TextFormFieldWidget(
                      rounded: 30,
                      backgroundColor: AppColor.backgroundGreyColor,
                      hintText: "Email".tr(),
                      controller: emailController,
                    ),
                    sb20h(),
                    TextFormFieldWidget(
                      rounded: 30,
                      backgroundColor: AppColor.backgroundGreyColor,
                      hintText: "Mobile".tr(),
                      controller: mobileController,
                    ),
                    sb30h(),
                    BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                      listener: (context, state) {
                        if (state is UpdateProfileErrorState) {
                          AppToast.showError(context, state.error, "");
                          return;
                        }
                        if (state is UpdateProfileLoadedState) {
                          AppToast.showError(context, "Update Succesfully".tr(), "");
                          Navigator.pop(context);
                          context.read<GetProfileCubit>().getProfile();
                        }
                      },
                      builder: (context, state) {
                        return GradientButton(
                          inProgress: (state is UpdateProfilLoadingState),
                          text: 'Save'.tr(),
                          onTap: () {
                            context.read<UpdateProfileCubit>().updateProfile(
                                  email: emailController.text,
                                  name: nameController.text,
                                  mobileNo: mobileController.text,
                                  profilePicture: selectedProfile != null ? File(selectedProfile!.path) : null,
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
