import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_language/get_all_language_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music_category/get_all_music_category_model.dart';
import 'package:elite/feature/music/bloc/get_artist/get_artist_cubit.dart';
import 'package:elite/feature/music/bloc/get_choose_for_you/get_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/get_playlist/get_all_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/get_popular_music/get_popular_music_cubit.dart';
import 'package:elite/feature/music/ui/playlistScreen.dart';
import 'package:elite/feature/music/ui/playlist_scren.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_screen.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_audio_player.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custom_empty.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/skeloton.dart';
import 'package:elite/utils/widgets/textformfield.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../utils/widgets/custom_svg.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => MusicScreenState();
}

class MusicScreenState extends State<MusicScreen> with Utility {
  ValueNotifier<String> selectedIndex = ValueNotifier<String>("-1");
  ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  @override
  void dispose() {
    selectedIndex.dispose();
    isSearching.dispose();
    searchFocusNode.unfocus();
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void resetSearch() {
    isSearching.value = false;
    searchController.clear();
    searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ValueListenableBuilder<bool>(
          valueListenable: isSearching,
          builder: (context, searching, _) {
            return searching
                ? TextFormFieldWidget(
                    focusNode: searchFocusNode,
                    controller: searchController,
                    onChanged: (p0) {
                      setState(() {});
                      context.read<GetAllMusicCubit>().getAllMusic(search: p0, categoryId: null);
                    },
                    decoration: InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : TextWidget(text: "Music".tr(), fontSize: 16, fontWeight: FontWeight.w600);
          },
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isSearching,
            builder: (context, searching, _) {
              return GestureDetector(
                onTap: () {
                  if (searching) {
                    searchController.clear();
                  }
                  isSearching.value = !isSearching.value;
                },
                child: const CustomSvgImage(height: 30, width: 30, imageUrl: AppImages.searchSvg),
              );
            },
          ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetAllMusicCategoryCubit, GetAllMusicCategoryState>(
              builder: (context, state) {
                if (state is GetAllMusicCategoryLoadedState) {
                  List<MusicCategory> categories = [MusicCategory(id: "-1", name: "All"), ...(state.model.data ?? [])];
                  return SizedBox(
                    height: 60,
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedIndex,
                      builder: (context, currentId, _) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = categories[index];
                            final isSelected = data.id == currentId;
                            return GestureDetector(
                              onTap: () {
                                selectedIndex.value = data.id ?? "";
                                if (selectedIndex.value == "-1") {
                                  context.read<GetAllMusicCubit>().getAllMusic();
                                  return;
                                }
                                context.read<GetAllMusicCubit>().getAllMusic(categoryId: data.id);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF4DC5FD) : const Color.fromRGBO(67, 67, 67, 0.32),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextWidget(
                                  text: data.name ?? "",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            sb15h(),
            sb15h(),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, v, _) {
                return (v != "-1" || searchController.text.isNotEmpty)
                    ? const SizedBox()
                    : BlocBuilder<GetAllPlaylistCubit, GetAllPlaylistState>(
                        builder: (context, state) {
                          log(state.toString());
                          if (state is GetAllPlaylistLoadingState) {
                            return const Center(child: CustomCircularProgressIndicator());
                          }
                          if (state is GetAllPlaylistLoadedState) {
                            return state.model.playlists?.isEmpty ?? true
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 17),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              text: "Playlist Created By You".tr(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ],
                                        ),
                                      ),
                                      sb10h(),
                                      SizedBox(
                                        height: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: (state.model.playlists?.length ?? 0),
                                            itemBuilder: (context, index) {
                                              var data = state.model.playlists?[index];

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Playlistscreen(
                                                        data: data?.songs,
                                                        text: data?.name ?? "",
                                                        color:
                                                            AppColor.playlistGradients[index %
                                                                AppColor.playlistGradients.length],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 120,
                                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: AppColor
                                                          .playlistGradients[index % AppColor.playlistGradients.length],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      data?.name ?? "",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox();
                        },
                      );
              },
            ),
            sb15h(),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, v, _) {
                return (v != "-1" || searchController.text.isNotEmpty)
                    ? const SizedBox()
                    : BlocBuilder<GetPopularMusicCubit, GetPopularMusicState>(
                        builder: (context, state) {
                          log(state.toString());
                          if (state is GetPopularMusicLoadingState) {
                            return const Center(child: CustomCircularProgressIndicator());
                          }
                          if (state is GetPopularMusicLoadedState) {
                            return state.model.data?.items?.isEmpty ?? true
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 17),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              text: "Quick picks".tr(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AudioPlayerScreen(
                                                      playlist: state.model.data?.items ?? [],
                                                      startIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: AppColor.whiteColor),
                                                ),
                                                child: TextWidget(text: "Play all".tr(), color: AppColor.navColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sb10h(),
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: (state.model.data?.items?.length ?? 0) > 5
                                            ? 5
                                            : (state.model.data?.items?.length ?? 0),
                                        itemBuilder: (context, index) {
                                          var data = state.model.data?.items?[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AudioPlayerScreen(
                                                    playlist: state.model.data?.items ?? [],
                                                    startIndex: index,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              height: 70,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CustomCachedCard(
                                                    height: 60,
                                                    width: 60,
                                                    imageUrl: data?.coverImg ?? "",
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextWidget(text: data?.songTitle, fontWeight: FontWeight.w700),
                                                        TextWidget(
                                                          text: data?.artist?.artistName ?? "",
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColor.navColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox();
                        },
                      );
              },
            ),
            sb15h(),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, v, _) {
                return (v != "-1" || searchController.text.isNotEmpty)
                    ? const SizedBox()
                    : BlocBuilder<GetChooseForYouCubit, GetChooseForYouState>(
                        builder: (context, state) {
                          log(state.toString());
                          if (state is GetChooseForYouLoadingState) {
                            return const Center(child: CustomCircularProgressIndicator());
                          }
                          if (state is GetChooseForYouLoadedState) {
                            return state.model.data?.isEmpty ?? true
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 17),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              text: "Choose For you".tr(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AudioPlayerScreen(
                                                      playlist: state.model.data ?? [],
                                                      startIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: AppColor.whiteColor),
                                                ),
                                                child: TextWidget(text: "Play all".tr(), color: AppColor.navColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sb10h(),
                                      SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: state.model.data?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            var data = state.model.data?[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AudioPlayerScreen(
                                                      playlist: state.model.data ?? [],
                                                      startIndex: index,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 110,
                                                margin: const EdgeInsets.only(right: 12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustomCachedCard(
                                                      height: 100,
                                                      width: 100,
                                                      imageUrl: "${AppUrls.baseUrl}/${data?.coverImg ?? ""}",
                                                    ),
                                                    const SizedBox(height: 5),
                                                    TextWidget(
                                                      text: data?.songTitle ?? "",
                                                      fontWeight: FontWeight.w700,
                                                      maxlines: 1,
                                                      textOverflow: TextOverflow.ellipsis,
                                                    ),
                                                    TextWidget(
                                                      text: data?.artist?.artistName ?? "",
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColor.navColor,
                                                      maxlines: 1,
                                                      textOverflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox();
                        },
                      );
              },
            ),
            sb15h(),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, v, _) {
                return (v != "-1" || searchController.text.isNotEmpty)
                    ? const SizedBox()
                    : BlocBuilder<GetAllLanguageCubit, GetAllLanguageState>(
                        builder: (context, state) {
                          log("$state");
                          if (state is GetAllLanguageLoadingState) {
                            return const Center(child: CustomCircularProgressIndicator());
                          }
                          if (state is GetAllLanguageLoadedState) {
                            return state.model.data?.isEmpty ?? true
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: TextWidget(
                                          text: "Featured Playlist by Language".tr(),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      sb10h(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: SizedBox(
                                          height: 170,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var data = state.model.data?[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PlaylistScreen(
                                                        coverImg: data?.coverImg ?? "",
                                                        languageId: data?.id ?? "",
                                                        name: data?.name ?? "",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustomCachedCard(
                                                      height: 120,
                                                      width: 120,
                                                      imageUrl: "${AppUrls.baseUrl}/${data?.coverImg ?? ""}",
                                                    ),
                                                    sb10h(),
                                                    TextWidget(text: "${data?.name}"),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: state.model.data?.length,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox();
                        },
                      );
              },
            ),
            sb15h(),
            ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, v, _) {
                return (v != "-1" || searchController.text.isNotEmpty)
                    ? const SizedBox()
                    : BlocBuilder<GetArtistCubit, GetArtistState>(
                        builder: (context, state) {
                          log("$state");
                          if (state is GetArtistErrorState) {
                            return const Center(child: CustomCircularProgressIndicator());
                          }
                          if (state is GetArtistLoadedState) {
                            return state.model.data?.isEmpty ?? true
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: TextWidget(
                                          text: "Featured Playlist for you".tr(),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      sb10h(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: SizedBox(
                                          height: 170,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              var data = state.model.data?[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PlaylistScreen(
                                                        coverImg: data?.profileImg ?? "",
                                                        artistId: data?.id ?? "",
                                                        name: data?.artistName ?? "",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustomCachedCard(
                                                      height: 120,
                                                      width: 120,
                                                      imageUrl: "${AppUrls.baseUrl}/${data?.profileImg ?? ""}",
                                                    ),
                                                    sb5h(),
                                                    TextWidget(text: data?.artistName ?? ""),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: state.model.data?.length,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox();
                        },
                      );
              },
            ),
            BlocBuilder<GetSettingCubit, GetSettingState>(
              builder: (context, settingState) {
                return BlocBuilder<GetAllMusicCubit, GetAllMusicState>(
                  builder: (context, state) {
                    if (state is GetAllMusicLoadingState) {
                      return const SkelotonWidget(loading: true);
                    }

                    if (state is GetAllMusicLoadedState) {
                      final musicList = state.model.data?.items ?? [];

                      return musicList.isEmpty
                          ? const Center(child: CustomEmptyWidget())
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: selectedIndex,
                                    builder: (context, v, _) {
                                      return v != "-1"
                                          ? const SizedBox()
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const TextWidget(
                                                  text: "All Songs.",
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AudioPlayerScreen(playlist: musicList, startIndex: 0),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: AppColor.whiteColor),
                                                    ),
                                                    child: TextWidget(text: "Play all".tr(), color: AppColor.navColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                    },
                                  ),
                                  sb10h(),
                                  GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: musicList.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 15,
                                    ),
                                    itemBuilder: (context, index) {
                                      final music = musicList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (settingState is GetSettingLoadedState) {
                                            final isSongOnSubscription =
                                                settingState.model.setting?.isSongOnSubscription ?? true;

                                            if (!isSongOnSubscription) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AudioPlayerScreen(playlist: musicList, startIndex: index),
                                                ),
                                              );
                                            } else {
                                              if (isUserSubscribed) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AudioPlayerScreen(playlist: musicList, startIndex: index),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 120,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: NetworkImage("${AppUrls.baseUrl}/${music.coverImg ?? ""}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextWidget(
                                              text: music.songTitle ?? "",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              maxlines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                            ),
                                            TextWidget(
                                              text: music.artist?.artistName ?? "",
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                              maxlines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
