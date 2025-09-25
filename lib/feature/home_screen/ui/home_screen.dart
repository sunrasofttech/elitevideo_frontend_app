import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_model.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_cubit.dart';
import 'package:elite/feature/home_screen/ui/live_tv/live_tv_desc.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/feature/home_screen/ui/movie/video_descrption.dart';
import 'package:elite/feature/home_screen/ui/short_film/short_film_detail.dart';
// import 'package:elite/feature/home_screen/ui/short_film/video_descrption.dart';
import 'package:elite/feature/home_screen/ui/web_series/web_series_details.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_cubit.dart';
import 'package:elite/feature/music/bloc/get_choose_for_you/get_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/get_popular_music/get_popular_music_cubit.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_cubit.dart';
import 'package:elite/feature/splash_screen/onboarding_screen.dart';
import 'package:elite/utils/ithernet.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/skeloton.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import '../../../custom_model/movie_model.dart';
// import '../../../custom_model/short_film_model.dart';
import '../bloc/get_highlighted_content/get_highlighted_content_cubit.dart';
import 'web_series/video_descrption.dart';

class HighlightedItem {
  final String type;
  final dynamic item;

  HighlightedItem({required this.type, required this.item});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Utility {
  double rating = 0.0;
  double avgRating = 0.0;
  int totalRatings = 0;
  int _selectedCategoryIndex = 0;
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  final List<HighlightedItem> _highlightedItems = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;

      final movieList = _highlightedItems;
      if (movieList.isEmpty) return;

      if (_currentPage < movieList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<GetAllMovieCubit>().getAllMovie();
          await context.read<GetAllShortFilmCubit>().getAllShortFilm();
          await context.read<GetAllSeriesCubit>().getAllSeries();
          await context.read<GetAllMusicCubit>().getAllMusic();
          await context.read<GetContinueWatchingCubit>().getContinueWatching();
          await context.read<HighlightedMovieCubit>().getHighLightedMovie();
          await context.read<GetHighlightedContentCubit>().getHighlightedContent();
          await context.read<GetPopularMusicCubit>().getAllMusic();
          context.read<GetChooseForYouCubit>().getAllMusic();
        },
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(63, 173, 213, 1).withOpacity(0.3),
          body: SingleChildScrollView(
            child: BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
              builder: (context, state) {
                if (state is GetAllMovieLoadingState) {
                  return const SkelotonWidget(loading: true);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _carouselSection(),
                    _getContinueWatching(),
                    sb10h(),
                    _categoryBar(),
                    sb10h(),
                    _filteredContent(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _carouselSection() {
    return BlocConsumer<GetHighlightedContentCubit, GetHighlightedContentState>(
      listener: (context, state) {
        if (state is GetHighlightedContentErrorState && state.error.contains("Session expired. Please login again")) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (route) => false,
          );
          return;
        }
      },
      builder: (context, state) {
        // if (state is GetAllMovieLoadingState) {
        //   return const Center(
        //     child: CustomCircularProgressIndicator(),
        //   );
        // }
        if (state is GetHighlightedContentLoadedState) {
          // _highlightedMovies =
          _highlightedItems.clear();

          final movieList = state.model.data?.movies ?? [];
          final shortFilmsList = state.model.data?.shortFilms ?? [];
          final seriesList = state.model.data?.series ?? [];

          if (movieList.isNotEmpty) {
            _highlightedItems.addAll(movieList.map((e) => HighlightedItem(type: 'movie', item: e)));
          }
          if (shortFilmsList.isNotEmpty) {
            _highlightedItems.addAll(shortFilmsList.map((e) => HighlightedItem(type: 'shortFilm', item: e)));
          }
          if (seriesList.isNotEmpty) {
            _highlightedItems.addAll(seriesList.map((e) => HighlightedItem(type: 'series', item: e)));
          }

          if (_highlightedItems.isEmpty) return const SizedBox();
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.42,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _currentPage = index;
              },
              itemCount: _highlightedItems.length,
              itemBuilder: (context, index) {
                var highlighted = _highlightedItems[index];
                final data = highlighted.item;
                return GestureDetector(
                  onTap: () {
                    if (highlighted.type == 'movie') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieDetailScreen(id: data.id ?? '')),
                      );
                    } else if (highlighted.type == 'shortFilm') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShortFilmDetailScreen(id: data.id ?? '')),
                      );
                    } else if (highlighted.type == 'series') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebSeriesDetails(id: data.id ?? '', type: ContentType.series),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      // Background image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${AppUrls.baseUrl}/${data.coverImg}"),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color.fromRGBO(24, 27, 35, 0.7),
                                Color.fromRGBO(24, 27, 35, 0.9),
                                Color.fromRGBO(24, 27, 35, 1.0),
                              ],
                              stops: [0.0, 0.4, 0.75, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                GradientButton(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  showAnimation: false,
                                  text: 'Watch Now'.tr(),
                                  onTap: null,
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.13),
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    onPressed: () {
                                      if (data.trailorVideo == null || (data.trailorVideo?.isEmpty ?? true)) {
                                        AppToast.showError(context, "No Video", "No Trailer Video Upload");
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoDescrptionScreen(model: data, isTrailer: true),
                                        ),
                                      );
                                    },
                                    child: TextWidget(
                                      text: 'Trailer'.tr(),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: const Color.fromRGBO(245, 253, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: highlighted.type == "movie"
                                      ? "${data.movieName ?? ""}"
                                      : highlighted.type == "series"
                                      ? data?.seriesName ?? ""
                                      : highlighted.type == "shortFilm"
                                      ? data?.shortFilmTitle ?? ""
                                      : "",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                                if ((data as dynamic)?.toJson()?.containsKey('ratings') == true) ...[
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            itemBuilder: (context, index) {
                                              bool isSelected = index < rating;
                                              return Icon(
                                                index < rating ? Icons.star : Icons.star_border,
                                                color: isSelected ? Colors.orange : AppColor.whiteColor,
                                                size: 30,
                                              );
                                            },
                                            onRatingUpdate: (ratingvalue) {
                                              setState(() {
                                                rating = ratingvalue;
                                              });
                                            },
                                            initialRating: double.tryParse(data?.averageRating.toString() ?? "") ?? 0.0,
                                            allowHalfRating: true,
                                            minRating: 0.5,
                                            unratedColor: AppColor.whiteColor,
                                            itemCount: 5,
                                            itemSize: 25,
                                            updateOnDrag: true,
                                          ),
                                          sb5w(),
                                          TextWidget(text: "(${data?.averageRating ?? "0"})"),
                                        ],
                                      ),
                                      sb5h(),
                                      TextWidget(
                                        text: "From ${data?.ratings.length ?? 0} users",
                                        color: AppColor.textGreyColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            TextWidget(
                              text: "${data.category?.name ?? ""}",
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: AppColor.greyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getContinueWatching() {
    return BlocConsumer<GetContinueWatchingCubit, GetContinueWatchingState>(
      listener: (context, state) {
        if (state is GetContinueWatchingErrorState && state.error.contains("Session expired. Please login again")) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (route) => false,
          );
          return;
        }
      },
      builder: (context, state) {
        if (state is GetContinueWatchingLoadedState) {
          return state.model.data?.isEmpty ?? false
              ? const SizedBox()
              : Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color.fromRGBO(0, 0, 0, 0.6), Colors.transparent],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: "Continue Watching .".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                        sb15h(),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.model.data?.length,
                            itemBuilder: (context, index) {
                              final data = state.model.data?[index];

                              double progress = 0.0;
                              if (data?.content?.movieTime != null && data?.currentTime != null) {
                                double totalSeconds = _parseDurationToSeconds(data?.content?.movieTime! ?? "");
                                if (totalSeconds > 0) {
                                  progress = data!.currentTime! / totalSeconds;
                                  progress = progress.clamp(0.0, 1.0);
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (data?.type == "movie") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailScreen(
                                          lastPosition: data?.currentTime,
                                          id: data?.typeId ?? "",
                                          // model: Movie(
                                          //   viewCount: data?.content?.viewCount,
                                          //   videoLink: data?.content?.videoLink,
                                          //   description: data?.content?.description,
                                          //   coverImg: data?.content?.coverImg,
                                          //   genreId: data?.content?.genreId,
                                          //   id: data?.content?.id,
                                          //   isHighlighted: data?.content?.isHighlighted,
                                          //   isMovieOnRent: data?.content?.isMovieOnRent,
                                          //   isWatchlist: data?.content?.isWatchlist,
                                          //   quality: data?.content?.quality,
                                          //   showSubscription: data?.content?.showSubscription,
                                          //   movieVideo: data?.content?.movieVideo,
                                          //   movieTime: data?.content?.movieTime,
                                          //   releasedBy: data?.content?.releasedBy,
                                          //   releasedDate: data?.content?.releasedDate,
                                          //   status: data?.content?.status,
                                          //   updatedAt: data?.content?.updatedAt,
                                          //   subtitle: data?.content?.subtitle,
                                          //   movieName: data?.content?.movieName,
                                          //   reportCount: data?.content?.reportCount,
                                          //   createdAt: data?.content?.createdAt,
                                          //   movieCategory: data?.content?.movieCategory,
                                          //   movieLanguage: data?.content?.movieLanguage,
                                          //   movieRentPrice: data?.content?.movieRentPrice,
                                          //   posterImg: data?.content?.posterImg,
                                          //   rentedTimeDays: data?.content?.rentedTimeDays,
                                          //   trailorVideo: data?.content?.trailorVideo,
                                          //   trailorVideoLink: data?.content?.trailorVideoLink,
                                          //   movieAd: data?.ads != null && data!.ads!.isNotEmpty
                                          //       ? data.ads!
                                          //           .map((ad) => MovieAd(
                                          //                 id: ad.id,
                                          //                 videoAdId: ad.videoAdId,
                                          //                 createdAt: ad.createdAt,
                                          //                 movieId: ad.movieId,
                                          //                 updatedAt: ad.updatedAt,
                                          //                 videoAd: ad.videoAd,
                                          //               ))
                                          //           .toList()
                                          //       : [],
                                          // ),
                                          //  isTrailer: false,
                                        ),
                                      ),
                                    );
                                  } else if (data?.type == "shortfilm") {
                                    // var datum = data?.content;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShortFilmDetailScreen(
                                          // model: ShortFilm(
                                          //   id: datum?.id,
                                          //   shortFilmTitle: datum?.shortFilmTitle,
                                          //   coverImg: datum?.coverImg,
                                          //   createdAt: datum?.createdAt,
                                          //   description: datum?.description,
                                          //   genreId: datum?.genreId,
                                          //   isHighlighted: datum?.isHighlighted,
                                          //   isMovieOnRent: datum?.isMovieOnRent,
                                          //   isWatchlist: datum?.isWatchlist,
                                          //   movieCategory: datum?.movieCategory,
                                          //   movieLanguage: datum?.movieLanguage,
                                          //   movieRentPrice: datum?.movieRentPrice,
                                          //   movieTime: datum?.movieTime,
                                          //   posterImg: datum?.posterImg,
                                          //   quality: datum?.quality,
                                          //   releasedBy: datum?.releasedBy,
                                          //   releasedDate: datum?.releasedDate.toString(),
                                          //   rentedTimeDays: datum?.rentedTimeDays,
                                          //   reportCount: datum?.reportCount,
                                          //   shortVideo: datum?.shortVideo,
                                          //   showSubscription: datum?.showSubscription,
                                          //   status: datum?.status,
                                          //   subtitle: datum?.subtitle,
                                          //   viewCount: datum?.viewCount,
                                          //   videoLink: datum?.videoLink,
                                          //   updatedAt: datum?.updatedAt,
                                          //   shortfilmAds: data?.ads != null && data!.ads!.isNotEmpty
                                          //       ? data.ads!
                                          //           .map((ad) => MovieAd(
                                          //                 id: ad.id,
                                          //                 videoAdId: ad.videoAdId,
                                          //                 createdAt: ad.createdAt,
                                          //                 movieId: ad.movieId,
                                          //                 updatedAt: ad.updatedAt,
                                          //                 videoAd: ad.videoAd,
                                          //               ))
                                          //           .toList()
                                          //       : [],
                                          // ),
                                          id: data?.typeId ?? "",
                                          lastPosition: data?.currentTime,
                                        ),
                                      ),
                                    );
                                  } else if (data?.type == "season_episode") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EpisodeDescScreen(
                                          episode: Episode(
                                            coverImg: data?.content?.coverImg,
                                            createdAt: data?.content?.createdAt,
                                            episodeName: data?.content?.episodeName,
                                            episodeNo: data?.content?.episodeNo,
                                            id: data?.content?.id,
                                            releasedDate: data?.content?.releasedDate.toString(),
                                            seasonId: data?.content?.seasonId,
                                            seriesId: data?.content?.seriesId,
                                            status: data?.content?.status,
                                            video: data?.content?.video,
                                            updatedAt: data?.content?.updatedAt,
                                            videoLink: data?.content?.videoLink,
                                            episodeAd: data?.ads != null && data!.ads!.isNotEmpty
                                                ? data.ads!
                                                      .map(
                                                        (ad) => MovieAd(
                                                          id: ad.id,
                                                          videoAdId: ad.videoAdId,
                                                          createdAt: ad.createdAt,
                                                          movieId: ad.movieId,
                                                          updatedAt: ad.updatedAt,
                                                          videoAd: ad.videoAd,
                                                        ),
                                                      )
                                                      .toList()
                                                : [],
                                          ),
                                          lastPosition: data?.currentTime,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 160,
                                            margin: const EdgeInsets.only(right: 12),
                                            child: CustomCachedCard(
                                              imageUrl: data?.type == "season_episode"
                                                  ? "${AppUrls.baseUrl}/${data?.content?.coverImg}"
                                                  : "${AppUrls.baseUrl}/${data?.content?.posterImg}",
                                              width: 250,
                                              height: 160,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(21),
                                                bottomRight: Radius.circular(21),
                                              ),
                                              child: LinearProgressIndicator(
                                                value: progress,
                                                minHeight: 6,
                                                backgroundColor: Colors.transparent,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      sb5h(),
                                      TextWidget(
                                        text: data?.type == "shortfilm"
                                            ? data?.content?.shortFilmTitle ?? 'N/A'
                                            : data?.type == "movie"
                                            ? data?.content?.movieName ?? 'N/A'
                                            : data?.content?.episodeName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(Duration(seconds: data?.currentTime ?? 0)),
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }
        return const SizedBox();
      },
    );
  }

  Widget _movieSection() {
    return BlocWithInternetHandler<GetAllMovieCubit, GetAllMovieState>(
      onRetry: () {
        context.read<HighlightedMovieCubit>().getHighLightedMovie();
        context.read<GetAllMovieCubit>().getAllMovie();
        context.read<GetMostViewedCubit>().getMostViewedMovie();
        context.read<GetProfileCubit>().getProfile();
        context.read<GetSettingCubit>().getSetting();
        context.read<GetSubscriptionCubit>().getAllSub();
      },
      loading: Center(child: Lottie.asset(AppImages.loadingLottie)),
      builder: (context, state) {
        if (state is GetAllMovieLoadingState) {
          return Center(child: Lottie.asset(AppImages.loadingLottie));
        }

        if (state is GetAllMovieLaodedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Top Movies".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                sb15h(),
                SizedBox(
                  height: state.model.data?.movies?.isEmpty ?? true ? 10 : 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.model.data?.movies?.length,
                    itemBuilder: (context, index) {
                      var data = state.model.data?.movies?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MovieDetailScreen(id: data?.id ?? "")),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
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
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _getShortFilm() {
    return BlocBuilder<GetAllShortFilmCubit, GetAllShortFilmState>(
      builder: (context, state) {
        if (state is GetAllShortFilmLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Short Film".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                sb15h(),
                SizedBox(
                  height: state.model.data?.isEmpty ?? true ? 10 : 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.model.data?.length,
                    itemBuilder: (context, index) {
                      var data = state.model.data?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShortFilmDetailScreen(id: data?.id ?? "")),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
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
                                text: '${data?.shortFilmTitle}',
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
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getSeries() {
    return BlocConsumer<GetAllSeriesCubit, GetAllSeriesState>(
      listener: (context, state) {
        if (state is GetAllSeriesErrorState && state.error.contains("Session expired. Please login again")) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (route) => false,
          );
          return;
        }
      },
      builder: (context, state) {
        if (state is GetAllSeriesLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Web Series".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                sb15h(),
                SizedBox(
                  height: state.model.data?.isEmpty ?? true ? 10 : 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.model.data?.length,
                    itemBuilder: (context, index) {
                      var data = state.model.data?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebSeriesDetails(id: data?.id ?? "", type: ContentType.series),
                            ),
                          );
                          context.read<GetLiveTvCubit>().getAllLiveCategory();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
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
                                text: '${data?.seriesName}',
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
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getLiveTv() {
    return BlocConsumer<GetLiveTvCubit, GetLiveTvState>(
      listener: (context, state) {
        if (state is GetLiveTvErrorState && state.error.contains("Session expired. Please login again")) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (route) => false,
          );
          return;
        }
      },
      builder: (context, state) {
        if (state is GetLiveTvLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Live TV".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                sb15h(),
                SizedBox(
                  height: state.model.data?.channels?.isEmpty ?? true ? 0 : 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.model.data?.channels?.length,
                    itemBuilder: (context, index) {
                      var data = state.model.data?.channels?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LiveTvDesc(model: data, isTrailer: false)),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
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
                                text: '${data?.name}',
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
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  double _parseDurationToSeconds(String duration) {
    try {
      final parts = duration.trim().split(":");
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return (minutes * 60 + seconds).toDouble();
    } catch (_) {
      return 0.0;
    }
  }

  _getTvShow() {
    return BlocConsumer<GetAllTvShowSeriesCubit, GetAllTVSeriesState>(
      listener: (context, state) {
        if (state is GetAllTVSeriesErrorState && state.error.contains("Session expired. Please login again")) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
            (route) => false,
          );
          return;
        }
      },
      builder: (context, state) {
        log("State is $state");
        if (state is GetAllTVSeriesLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Tv Show".tr(), fontWeight: FontWeight.w600, fontSize: 16),
                sb15h(),
                SizedBox(
                  height: state.model.data?.isEmpty ?? true ? 10 : 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.model.data?.length,
                    itemBuilder: (context, index) {
                      var data = state.model.data?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebSeriesDetails(id: data?.id ?? "", type: ContentType.series),
                            ),
                          );
                          context.read<GetLiveTvCubit>().getAllLiveCategory();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 160,
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomCachedCard(imageUrl: "${AppUrls.baseUrl}/${data?.posterImg}", width: 250, height: 160),
                              ),
                            ),
                            sb5h(),
                            SizedBox(
                              width: 200,
                              child: TextWidget(
                                text: '${data?.seriesName}',
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
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _categoryBar() {
    final categories = ['For You'.tr(), 'Movie'.tr(), 'Short Film'.tr(), 'Series'.tr(), 'Tv Show'.tr(), 'Live TV'.tr()];

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
              debugPrint('Selected: ${categories[index]}');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      margin: const EdgeInsets.only(right: 6),
                    ),
                  TextWidget(
                    text: categories[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filteredContent() {
    if (_selectedCategoryIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _movieSection(),
          sb15h(),
          _getShortFilm(),
          sb15h(),
          _getSeries(),
          sb15h(),
          _getLiveTv(),
          sb15h(),
          _getTvShow(),
        ],
      );
    } else {
      switch (_selectedCategoryIndex) {
        case 1:
          return _movieSection();
        case 2:
          return _getShortFilm();
        case 3:
          return _getSeries();
        case 4:
          return _getTvShow();
        case 5:
          return _getLiveTv();
        default:
          return const SizedBox();
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds watched";
  }
}
