import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_model.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/feature/home_screen/ui/web_series/video_descrption.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_cubit.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_model.dart';
import 'package:elite/feature/profile/ui/setting/setting.dart';
import 'package:elite/feature/profile/ui/subscription/subscription_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custom_empty.dart';
import 'package:elite/utils/widgets/custom_svg.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/skeloton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../home_screen/ui/short_film/short_film_detail.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomAuthDesignScreen(
            center: false,
            data: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: BlocBuilder<GetProfileCubit, GetProfileState>(
                builder: (context, state) {
                  if (state is GetProfileLoadingState) {
                    return const SkelotonWidget(loading: true);
                  }
                  if (state is GetProfileLoadedState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sb20h(),
                        _profileSection(state.model.user ?? User()),
                        sb30h(),
                        const Expanded(
                          child: WatchListTabSection(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            )),
      ),
    );
  }

  _profileSection(User data) {
    const assetProfile = "asset/test/default.png";
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color.fromRGBO(252, 163, 10, 1),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: data.profilePicture == null
                      ? Image.asset(
                          assetProfile,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: "${data.profilePicture}",
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) => Image.asset(
                            assetProfile,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            if (data.subscription != null)
              const Positioned(
                top: -5,
                right: -10,
                child: CustomSvgImage(
                  imageUrl: AppImages.crownSvg,
                  height: 25,
                  width: 25,
                ),
              ),
          ],
        ),
        sb20w(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sb15h(),
            TextWidget(
              text: "+91 ${data.mobileNo}",
              color: const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            TextWidget(
              text: "${data.email}",
              color: const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            sb10h(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(252, 163, 10, 1),
                    Color.fromRGBO(194, 133, 0, 1),
                    Color.fromRGBO(255, 254, 249, 1),
                    Color.fromRGBO(255, 170, 0, 1),
                    Color.fromRGBO(239, 168, 4, 1),
                  ]),
                ),
                child: TextWidget(
                  text: data.subscription == null ? "Subscription Plan".tr() : "${data.subscription?.planName}",
                  color: AppColor.blackColor,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.settings,
          color: AppColor.greyColor,
        ),
        sb5w(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingScreen(),
              ),
            );
          },
          child: TextWidget(
            text: "Settings".tr(),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
          ),
        ),
        sb5w(),
      ],
    );
  }

  _watchingSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TextWidget(
            text: "Who is Watching",
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
          sb20h(),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: AppColor.gradientColorList,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  sb10h(),
                  const TextWidget(text: "Amit")
                ],
              ),
              sb10w(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: AppColor.gradientColorList,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  sb10h(),
                  const TextWidget(text: "Suraj")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WatchListTabSection extends StatefulWidget {
  const WatchListTabSection({super.key});

  @override
  State<WatchListTabSection> createState() => _WatchListTabSectionState();
}

class _WatchListTabSectionState extends State<WatchListTabSection> with TickerProviderStateMixin, Utility {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<GetWatchlistCubit>().getWatchList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextWidget(
              text: "Watchlist".tr(),
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
            const Spacer(),
            BlocBuilder<GetWatchlistCubit, GetWatchlistState>(
              builder: (context, state) {
                return (state is GetWatchlistLoadingState)
                    ? const CustomCircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          context.read<GetWatchlistCubit>().getWatchList();
                        },
                        color: AppColor.whiteColor,
                      );
              },
            ),
          ],
        ),
        sb10h(),
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: "Movie".tr()),
            Tab(text: "ShortFilm".tr()),
            Tab(text: "Episode".tr()),
          ],
        ),
        BlocBuilder<GetWatchlistCubit, GetWatchlistState>(
          builder: (context, state) {
            if (state is GetWatchlistLoadingState) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: CustomCircularProgressIndicator(),
                ),
              );
            } else if (state is GetWatchlistLoadedState) {
              final allData = state.model.watchlist ?? [];

              final movies = allData.where((e) => e.type == 'movie').toList();
              final shortFilms = allData.where((e) => e.type == 'shortfilm').toList();
              final episodes = allData.where((e) => e.type == 'season_episode').toList();

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _watchListGrid(movies),
                    _watchListGrid(shortFilms),
                    _watchListGrid(episodes),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _watchListGrid(List<Watchlist> data) {
    return data.isEmpty
        ? const CustomEmptyWidget()
        : GridView.builder(
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = data[index];
              final imagePath = item.type == 'movie'
                  ? item.movie?.posterImg
                  : item.type == 'shortfilm'
                      ? item.shortfilm?.posterImg
                      : item.seasonEpisode?.coverImg;

              return GestureDetector(
                onTap: () {
                  if (item.type == 'movie') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(id: item.movieId ?? ""),
                      ),
                    );
                  } else if (item.type == "shortfilm") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShortFilmDetailScreen(id: item.shortfilmId ?? ""),
                      ),
                    );
                  } else if (item.type == "season_episode") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EpisodeDescScreen(
                          episode: item.seasonEpisode,
                        ),
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomCachedCard(
                    height: 130,
                    width: 140,
                    imageUrl: "$imagePath",
                  ),
                ),
              );
            },
          );
  }
}
