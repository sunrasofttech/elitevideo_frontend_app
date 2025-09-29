import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/trailer/get_all_trailer/get_all_trailer_cubit.dart';
import 'package:elite/feature/trailer/trailer_video.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_all_trailer/get_all_trailer_model.dart';

class TrailerScreen extends StatefulWidget {
  const TrailerScreen({super.key});

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextWidget(text: "Trailer".tr(), fontSize: 16, fontWeight: FontWeight.w600),
        actions: [
          sb10w(),
          GestureDetector(
            onTap: () {
              dashboardGlobalKey.currentState?.switchTab(5);
            },
            child: BlocBuilder<GetProfileCubit, GetProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoadedState) {
                  const assetProfile = "asset/test/default.png";
                  String image = "${AppUrls.baseUrl}/${state.model.user?.profilePicture}";
                  return Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: AppColor.gradientColorList,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: state.model.user?.profilePicture == null
                            ? Image.asset(assetProfile, width: 46, height: 46, fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: image,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                                errorWidget: (context, url, error) =>
                                    Image.asset(assetProfile, width: 46, height: 46, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          sb10w(),
        ],
      ),
      body: BlocBuilder<GetAllTrailerCubit, GetAllTrailerState>(
        builder: (context, state) {
          if (state is GetAllTrailerLoadedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.model.data?.trailors?.length,
                      itemBuilder: (context, index) {
                        var data = state.model.data?.trailors?[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrailerVideoDesc(
                                    model: data ?? Trailor(),
                                  ),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 160,
                                margin: const EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomCachedCard(
                                    imageUrl: "${AppUrls.baseUrl}/${data?.posterImg}",
                                    width: 250,
                                    height: 160,
                                  ),
                                ),
                              ),
                              sb5h(),
                              SizedBox(
                                width: 200,
                                child: TextWidget(
                                  text: '${data?.movieName}',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  maxlines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
