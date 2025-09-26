import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_movie_rating/post_movie_rating_cubit.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/feature/home_screen/ui/movie/video_descrption.dart';
import 'package:elite/feature/home_screen/ui/short_film/short_film_detail.dart';
import 'package:elite/feature/home_screen/ui/web_series/web_series_details.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_cubit.dart';
import 'package:elite/utils/ithernet.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../../custom_model/movie_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Utility {
  double rating = 0.0;
  double avgRating = 0.0;
  int totalRatings = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<GetAllMovieCubit>().getAllMovie();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _carouselSection(),
                sb15h(),
                _movieSection(),
                sb15h(),
                _getShortFilm(),
                sb15h(),
                _getSeries(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _carouselSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.42,
      child: BlocBuilder<GetAllMovieCubit, GetAllMovieState>(
        builder: (context, state) {
          // if (state is GetAllMovieLoadingState) {
          //   return const Center(
          //     child: CustomCircularProgressIndicator(),
          //   );
          // }
          if (state is GetAllMovieLaodedState) {
            List<Movie> highlightedMovieList =
                state.model.data?.movies?.where((e) => e.isHighlighted == true).toList() ?? [];

            return PageView.builder(
              itemCount: highlightedMovieList.length,
              itemBuilder: (context, index) {
                var data = highlightedMovieList[index];
                avgRating = double.tryParse(data.averageRating ?? '') ?? 0.0;
                totalRatings = data.totalRatings ?? 0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          id: data.id ?? "",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "${AppUrls.baseUrl}/${data.posterImg}",
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  text: 'Watch Now !'.tr(),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoDescrptionScreen(
                                          model: data,
                                          isTrailer: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              sb10w(),
                              Expanded(
                                child: GradientButton(
                                  text: 'Traler'.tr(),
                                  onTap: () {
                                    if (data.trailorVideo == null || (data.trailorVideo?.isEmpty ?? true)) {
                                      AppToast.showError(context, "", "No Trailer Video Upload");
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoDescrptionScreen(
                                          model: data,
                                          isTrailer: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        sb15h(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: "${data.movieName}",
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      TextWidget(
                                        text: "${data.category?.name}",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: AppColor.greyColor,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: avgRating,
                                            allowHalfRating: true,
                                            minRating: 0.5,
                                            itemCount: 5,
                                            itemSize: 25,
                                            unratedColor: AppColor.whiteColor,
                                            updateOnDrag: true,
                                            itemBuilder: (context, index) {
                                              return Icon(
                                                index < avgRating ? Icons.star : Icons.star_border,
                                                color: index < avgRating ? Colors.orange : AppColor.whiteColor,
                                                size: 30,
                                              );
                                            },
                                            onRatingUpdate: (newRating) {
                                              setState(() {
                                                rating = newRating;
                                                avgRating = newRating;
                                              });
                                              context.read<PostMovieRatingCubit>().postMovieRate(
                                                    movieId: data.id ?? "",
                                                    rating: newRating.toString(),
                                                  );
                                            },
                                          ),
                                          sb10w(),
                                          TextWidget(text: "(${avgRating.toStringAsFixed(1)})"),
                                        ],
                                      ),
                                      sb5h(),
                                      TextWidget(
                                        text: "From $totalRatings users",
                                        color: AppColor.textGreyColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
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
      loading: const Center(
        child: CustomCircularProgressIndicator(),
      ),
      builder: (context, state) {
        if (state is GetAllMovieLoadingState) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }

        if (state is GetAllMovieLaodedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Top Movies".tr(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                sb15h(),
                SizedBox(
                  height: 170,
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
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                id: data?.id ?? "",
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage("${AppUrls.baseUrl}/${data?.posterImg}"),
                                  fit: BoxFit.cover,
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
                TextWidget(
                  text: "Short Film".tr(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                sb15h(),
                SizedBox(
                  height: 170,
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
                              builder: (context) => ShortFilmDetailScreen(
                                id: data?.id ?? "",
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage("${AppUrls.baseUrl}/${data?.posterImg}"),
                                  fit: BoxFit.cover,
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
    return BlocBuilder<GetAllSeriesCubit, GetAllSeriesState>(
      builder: (context, state) {
        if (state is GetAllSeriesLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Web Series".tr(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                sb15h(),
                SizedBox(
                  height: 170,
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
                              builder: (context) => WebSeriesDetails(
                                id: data?.id ?? "",
                                type: ContentType.series,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              height: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage("${AppUrls.baseUrl}/${data?.posterImg}"),
                                  fit: BoxFit.cover,
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
}
