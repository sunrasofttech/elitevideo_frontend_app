import 'dart:developer';
import 'package:elite/feature/trailer/trailer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/downloads/ui/download.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_highlighted_content/get_highlighted_content_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_cubit.dart';
import 'package:elite/feature/home_screen/ui/home_screen.dart';
import 'package:elite/feature/music/bloc/get_all_language/get_all_language_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite/feature/music/bloc/get_artist/get_artist_cubit.dart';
import 'package:elite/feature/music/bloc/get_choose_for_you/get_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/get_playlist/get_all_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/get_popular_music/get_popular_music_cubit.dart';
import 'package:elite/feature/music/ui/music_screen.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/ui/profile_screen.dart';
import 'package:elite/feature/search/bloc/get_all_category/get_all_category_cubit.dart';
import 'package:elite/feature/search/bloc/get_live_category/get_live_category_cubit.dart';
import 'package:elite/feature/search/bloc/get_resent_search/get_resent_search_cubit.dart';
import 'package:elite/feature/search/bloc/search/search_cubit.dart';
import 'package:elite/feature/search/ui/search_screen.dart';
import 'package:elite/feature/splash_screen/onboarding_screen.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_bottom_bar.dart';
// import 'package:app_links/app_links.dart';
import 'package:elite/utils/widgets/custom_no_network.dart';
import 'package:elite/utils/widgets/custom_server_down.dart';
import 'package:elite/utils/widgets/mini_player.dart';
import '../../utils/widgets/audio_player_singleton.dart';
import '../profile/bloc/get_subscription/get_subscription_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.currentIndex});
  final int? currentIndex;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with Utility {
  int currentIndex = 0;
  late Widget currentPage;
  List<Widget> pages = [];

  HomeScreen homeScreen = const HomeScreen();
  MusicScreen musicScreen = MusicScreen(key: musicScreenState);
  SearchScreen searchScreen = SearchScreen(key: searchScreenState);
  TrailerScreen _trailerScreen = TrailerScreen();
  DownloadScreen downloadScreen = const DownloadScreen();
  ProfileScreen profileScreen = const ProfileScreen();
  // final appLinks = AppLinks();

  void switchTab(int index) {
    setState(() {
      currentIndex = index;
      currentPage = pages[currentIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex ?? 0;
    pages = [homeScreen, _trailerScreen, musicScreen, searchScreen, downloadScreen, profileScreen];
    currentPage = pages[currentIndex];
    context.read<GetAllPlaylistCubit>().getAllPlaylist();
    context.read<HighlightedMovieCubit>().getHighLightedMovie();
    context.read<GetChooseForYouCubit>().getAllMusic();
    context.read<GetAllMovieCubit>().getAllMovie();
    context.read<GetMostViewedCubit>().getMostViewedMovie();
    context.read<GetProfileCubit>().getProfile();
    context.read<GetHighlightedContentCubit>().getHighlightedContent();
    context.read<GetSettingCubit>().getSetting();
    context.read<GetAllMusicCategoryCubit>().getAllMusic();
    context.read<GetAllMusicCubit>().getAllMusic();
    context.read<GetLiveTvCubit>().getAllLiveCategory();
    context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
    context.read<GetLiveCategoryCubit>().getAllLiveCategory();
    context.read<GetLiveTvCubit>().getAllLiveCategory();
    context.read<GetContinueWatchingCubit>().getContinueWatching();
    context.read<SearchCubit>().search();
    context.read<GetAllSeriesCubit>().getAllSeries();
    context.read<GetResentSearchCubit>().getResentSearch();
    context.read<GetAllShortFilmCubit>().getAllShortFilm();
    context.read<GetAllTvShowSeriesCubit>().getAllSeries();
    context.read<GetSubscriptionCubit>().getAllSub();
    context.read<GetAllLanguageCubit>().getAllLanguage();
    context.read<GetPopularMusicCubit>().getAllMusic();
    context.read<GetArtistCubit>().getAllArtist();
    // appLinks.uriLinkStream.listen(
    //   (Uri? uri) {
    //     debugPrint("Received Uri: $uri");
    //     // final movieId = uri?.queryParameters['id'];
    //     // AppToast.showSuccess("🆕 Opened from link with ID: $movieId");
    //   },
    //   onError: (err) {
    //     debugPrint("Error in deep linking: $err");
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetSettingCubit, GetSettingState>(
      listener: (context, state) {
        if (state is GetSettingLoadedState) {
          checkVersion(
            state.model.setting?.currentVersion ?? "",
            state.model.setting?.playStoreLink ?? "",
            context,
            state.model.setting?.requiredVersion ?? "",
          );
        }
      },
      child: RefreshIndicator(
        backgroundColor: AppColor.whiteColor,
        color: AppColor.greenColor,
        onRefresh: () async {
          await context.read<HighlightedMovieCubit>().getHighLightedMovie();
          await context.read<GetPopularMusicCubit>().getAllMusic();
          context.read<GetChooseForYouCubit>().getAllMusic();
        },
        child: Scaffold(
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) async {
              // bool isAutoRotate = await OrientationHelper.isAutoRotateOn();
              // log("Auto rotate currently: $isAutoRotate");

              // OrientationHelper.autoRotateStream.listen((enabled) {
              //   log("Auto rotate changed: $enabled");
              // });
              if (currentIndex == 1) {
                musicScreenState.currentState?.searchFocusNode.unfocus();
              }
              if (currentIndex == 2) {
                searchScreenState.currentState?.searchFocusNode.unfocus();
              }
              FocusScope.of(context).unfocus();
              final hasInternet = await checkInternetConnection();
              if (!hasInternet) {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoInternetScreen(
                        onRetry: () {
                          context.read<HighlightedMovieCubit>().getHighLightedMovie();
                          context.read<GetAllMovieCubit>().getAllMovie();
                          context.read<GetMostViewedCubit>().getMostViewedMovie();
                          context.read<GetProfileCubit>().getProfile();
                          context.read<GetHighlightedContentCubit>().getHighlightedContent();
                          context.read<GetSettingCubit>().getSetting();
                          context.read<GetAllMusicCategoryCubit>().getAllMusic();
                          context.read<GetAllMusicCubit>().getAllMusic();
                          context.read<GetLiveTvCubit>().getAllLiveCategory();
                          context.read<GetContinueWatchingCubit>().getContinueWatching();
                          context.read<GetAllSeriesCubit>().getAllSeries();
                          context.read<GetAllShortFilmCubit>().getAllShortFilm();
                          context.read<GetAllTvShowSeriesCubit>().getAllSeries();
                          context.read<GetSubscriptionCubit>().getAllSub();
                        },
                      ),
                    ),
                  );
                }
                return;
              }
              setState(() {
                currentIndex = index;
              });
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocListener<GetProfileCubit, GetProfileState>(
                  listener: (context, state) {
                    if (state is ServerDown) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CustomServerDown();
                          },
                        ),
                        (route) => false,
                      );
                    }
                    if (state is GetProfileErrorState && state.error.contains("Session expired. Please login again")) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
                        (route) => false,
                      );
                      return;
                    }
                    if (state is GetProfileLoadedState) {
                      isUserSubscribed = state.model.user?.isSubscription ?? false;
                      showAds = !(isUserSubscribed && (state.model.user?.subscription?.addfreeMovieShows ?? true));
                      log("is User Subscribed => $isUserSubscribed Show Ads => $showAds");
                    }
                  },
                  child: IndexedStack(index: currentIndex, children: pages),
                ),
              ),
              StreamBuilder<PlayerState>(
                stream: globalAudioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final isPlaying = state?.playing ?? false;

                  if (currentIndex == 1 || isPlaying) {
                    return const MiniPlayer();
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
