import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/custom_model/movie_model.dart';
import 'package:elite/custom_model/short_film_model.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_model.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_model.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite/feature/home_screen/ui/live_tv/live_tv_desc.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/feature/home_screen/ui/short_film/short_film_detail.dart';
import 'package:elite/feature/home_screen/ui/web_series/video_descrption.dart';
import 'package:elite/feature/home_screen/ui/web_series/web_series_details.dart';
import 'package:elite/feature/search/bloc/get_all_category/get_all_category_cubit.dart';
import 'package:elite/feature/search/bloc/get_live_category/get_live_category_cubit.dart';
import 'package:elite/feature/search/bloc/get_resent_search/get_resent_search_cubit.dart';
import 'package:elite/feature/search/bloc/post_resent_search/post_resent_serch_cubit.dart';
import 'package:elite/feature/search/bloc/search/search_cubit.dart';
import 'package:elite/feature/search/ui/language_category.dart';
import 'package:elite/feature/search/ui/movie_category.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/skeloton.dart';
import 'package:elite/utils/widgets/textformfield.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../home_screen/bloc/get_live_tv/get_live_tv_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with Utility {
  final searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  dispo() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
    searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Search for a content".tr(),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                sb20h(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: AppColor.gradientColorList,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(25, 161, 190, 1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormFieldWidget(
                        focusNode: searchFocusNode,
                        controller: searchController,
                        onChanged: (p0) {
                          setState(() {});
                          context.read<SearchCubit>().search(
                                keyword: p0,
                              );
                        },
                        backgroundColor: Colors.transparent,
                        rounded: 22,
                        hintText: "Search for a content".tr(),
                      ),
                    ),
                  ),
                ),
                sb40h(),
                searchController.text.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
                            builder: (context, state) {
                              if (state is GetAllCategoryLoadedState) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MovieCategoryScreen(),
                                      ),
                                    );
                                  },
                                  child: CategoryCard(
                                    imgHeight: 200,
                                    title: "Movies \n Category",
                                    subtitle: "${state.model.categories?.length ?? 0}",
                                    imagePath: "asset/image/spider.png",
                                    gradientColors: const [
                                      Color.fromRGBO(22, 202, 241, 1),
                                      Color.fromRGBO(1, 67, 167, 1),
                                    ],
                                    cutFromRight: false,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          BlocBuilder<GetLiveCategoryCubit, GetLiveCategoryState>(
                            builder: (context, state) {
                              if (state is GetLiveCategoryLoadedState) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LiveCategoryScreen(),
                                      ),
                                    );
                                  },
                                  child: CategoryCard(
                                    imgHeight: 200,
                                    title: "Live \n Category",
                                    cutFromRight: true,
                                    subtitle: "${state.model.data?.categories?.length ?? 0}",
                                    imagePath: "asset/image/ben.png",
                                    gradientColors: const [
                                      Color.fromRGBO(255, 46, 46, 1),
                                      Color.fromRGBO(224, 137, 57, 1),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
                searchController.text.isEmpty ? sb20h() : const SizedBox(),
                searchController.text.isEmpty ? _resentSearch() : const SizedBox(),
                searchController.text.isEmpty ? sb20h() : const SizedBox(),
                _mostSearchedSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _resentSearch() {
    return BlocBuilder<GetResentSearchCubit, GetResentSearchState>(
      builder: (context, state) {
        if (state is GetResentSearchLoadingState) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }

        if (state is GetResentSearchLoadedState) {
          return state.model.data?.isEmpty ?? true
              ? const SizedBox()
              : Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Resent Search".tr(),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        sb15h(),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.model.data?.length,
                            itemBuilder: (context, index) {
                              final data = state.model.data?[index];
                              return GestureDetector(
                                onTap: () {
                                  if (data?.type == "movie") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieDetailScreen(
                                            id: data?.typeId ?? "",
                                          ),
                                        ));
                                  } else if (data?.type == "shortfilm") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShortFilmDetailScreen(
                                          id: data?.typeId ?? "",
                                        ),
                                      ),
                                    );
                                  } else if (data?.type == "series") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebSeriesDetails(
                                          id: data?.typeId ?? "",
                                          type: ContentType.series,
                                        ),
                                      ),
                                    );
                                  } else if (data?.type == "season_episode") {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EpisodeDescScreen(
                                    //       episode: Episode(
                                    //         coverImg: data?.content?.coverImg,
                                    //         createdAt: data?.content?.createdAt,
                                    //         episodeName: data?.content?.episodeName,
                                    //         episodeNo: data?.content?.episodeNo,
                                    //         id: data?.content?.id,
                                    //         releasedDate: data?.content?.releasedDate.toString(),
                                    //         seasonId: data?.content?.seasonId,
                                    //         seriesId: data?.content?.seriesId,
                                    //         status: data?.content?.status,
                                    //         video: data?.content?.video,
                                    //         updatedAt: data?.content?.updatedAt,
                                    //         videoLink: data?.content?.videoLink,
                                    //         episodeAd: data?.ads != null && data!.ads!.isNotEmpty
                                    //             ? data.ads!
                                    //                 .map((ad) => MovieAd(
                                    //                       id: ad.id,
                                    //                       videoAdId: ad.videoAdId,
                                    //                       createdAt: ad.createdAt,
                                    //                       movieId: ad.movieId,
                                    //                       updatedAt: ad.updatedAt,
                                    //                       videoAd: ad.videoAd,
                                    //                     ))
                                    //                 .toList()
                                    //             : [],
                                    //       ),
                                    //       lastPosition: data?.currentTime,
                                    //     ),
                                    //   ),
                                    // );
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
                                                  ? "${AppUrls.baseUrl}/${data?.details?.coverImg}"
                                                  : "${AppUrls.baseUrl}/${data?.details?.posterImg}",
                                              width: 250,
                                              height: 160,
                                            ),
                                          ),
                                        ],
                                      ),
                                      sb5h(),
                                      TextWidget(
                                        text: data?.type == "shortfilm"
                                            ? data?.details?.shortFilmTitle ?? 'N/A'
                                            : data?.type == "movie"
                                                ? data?.details?.movieName ?? 'N/A'
                                                : data?.type == "series"
                                                    ? data?.details?.seriesName
                                                    : '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
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
        return Container();
      },
    );
  }

  _mostSearchedSection() {
    return BlocListener<PostResentSerchCubit, PostResentSerchState>(
      listener: (context, state) {
        if (state is PostResentSerchLoadedState) {
          context.read<GetResentSearchCubit>().getResentSearch();
        }
      },
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          log("----------------$state");
          if (state is SearchLoadingState) {
            return const SkelotonWidget(loading: true);
          }
          if (state is SearchErrorState) {
            return Center(
              child: TextWidget(
                text: "No Results Found".tr(),
              ),
            );
          }
          if (state is SearchLoadedState) {
            List<Movie> movie = state.model.data?.movies ?? [];
            List<ShortFilm> shortFilm = state.model.data?.shortfilms ?? [];
            List<WebSeries> series = state.model.data?.series ?? [];
            List<Episode> episode = state.model.data?.seasonepisode ?? [];
            List<Channel> liveTv = state.model.data?.livechannel ?? [];
            List<WebSeries> tvShows = state.model.data?.tvshows ?? [];
            log("🎬 Movies found: ${movie.length}");
            log("🎞 ShortFilms found: ${shortFilm.length}");
            log("📺 Series found: ${series.length}");
            log("🎥 Episodes found: ${episode.length}");
            log("📡 LiveTV found: ${liveTv.length}");
            log("📺 TV Shows found: ${tvShows.length}");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (movie.isNotEmpty) _movieSection(movie),
                sb15h(),
                if (shortFilm.isNotEmpty) _getShortFilm(shortFilm),
                sb15h(),
                if (series.isNotEmpty) _getSeries(series),
                sb15h(),
                if (episode.isNotEmpty) _getEpisode(episode),
                sb15h(),
                if (tvShows.isNotEmpty) _getTvShow(tvShows),
                sb15h(),
                if (liveTv.isNotEmpty) _getLiveTv(liveTv),
                // if (movie.isEmpty &&
                //     shortFilm.isEmpty &&
                //     series.isEmpty &&
                //     episode.isEmpty &&
                //     tvShows.isEmpty &&
                //     liveTv.isEmpty)
                //   Center(
                //     child: TextWidget(
                //       text: "No Results Found".tr(),
                //     ),
                //   ),
              ],
            );
          }
          return SizedBox(
            child: Center(
              child: TextWidget(
                text: "No Search Yet".tr(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _movieSection(List<Movie>? movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Movies".tr(),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          sb15h(),
          SizedBox(
            height: 190,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: movies?.length,
              itemBuilder: (context, index) {
                var data = movies?[index];
                return GestureDetector(
                  onTap: () {
                    // searchFocusNode.dispose();
                    // FocusScope.of(context).unfocus();
                    if (searchController.text.isNotEmpty) {
                      context.read<PostResentSerchCubit>().postResentSearch(ContentType.movie, data?.id ?? "");
                    }
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
                        width: 250,
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

  Widget _getShortFilm(List<ShortFilm>? shortfilms) {
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
            height: 190,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: shortfilms?.length,
              itemBuilder: (context, index) {
                var data = shortfilms?[index];
                return GestureDetector(
                  onTap: () {
                    // FocusScope.of(context).unfocus();
                    // searchFocusNode.dispose();
                    if (searchController.text.isNotEmpty) {
                      context.read<PostResentSerchCubit>().postResentSearch(ContentType.shortfilm, data?.id ?? "");
                    }
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
                        width: 250,
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

  Widget _getSeries(List<WebSeries>? series) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Series".tr(),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          sb15h(),
          SizedBox(
            height: 190,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: series?.length,
              itemBuilder: (context, index) {
                var data = series?[index];
                return GestureDetector(
                  onTap: () {
                    // FocusScope.of(context).unfocus();
                    // searchFocusNode.dispose();

                    if (searchController.text.isNotEmpty) {
                      context.read<PostResentSerchCubit>().postResentSearch(ContentType.series, data?.id ?? "");
                    }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
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

  Widget _getEpisode(List<Episode>? episode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Episode".tr(),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          sb15h(),
          SizedBox(
            height: 190,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: episode?.length,
              itemBuilder: (context, index) {
                var data = episode?[index];
                return GestureDetector(
                  onTap: () {
                    // FocusScope.of(context).unfocus();
                    // searchFocusNode.dispose();
                    if (searchController.text.isNotEmpty) {}
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EpisodeDescScreen(
                          episode: data ?? Episode(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        height: 160,
                        margin: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomCachedCard(
                            imageUrl: "${AppUrls.baseUrl}/${data?.coverImg}",
                            width: 250,
                            height: 160,
                          ),
                        ),
                      ),
                      sb5h(),
                      SizedBox(
                        width: 200,
                        child: TextWidget(
                          text: '${data?.episodeName}',
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

  _getTvShow(List<WebSeries> tvShows) {
    return BlocBuilder<GetAllTvShowSeriesCubit, GetAllTVSeriesState>(
      builder: (context, state) {
        if (state is GetAllTVSeriesLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Tv Show".tr(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                sb15h(),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tvShows.length,
                    itemBuilder: (context, index) {
                      var data = tvShows[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebSeriesDetails(
                                id: data.id ?? "",
                                type: ContentType.series,
                              ),
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
                                  imageUrl: "${AppUrls.baseUrl}/${data.posterImg}",
                                  width: 250,
                                  height: 160,
                                ),
                              ),
                            ),
                            sb5h(),
                            SizedBox(
                              width: 200,
                              child: TextWidget(
                                text: '${data.seriesName}',
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

  Widget _getLiveTv(List<Channel> liveTv) {
    return BlocBuilder<GetLiveTvCubit, GetLiveTvState>(
      builder: (context, state) {
        if (state is GetLiveTvLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Live TV".tr(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                sb15h(),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: liveTv.length,
                    itemBuilder: (context, index) {
                      var data = liveTv[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveTvDesc(
                                model: data,
                                isTrailer: false,
                              ),
                            ),
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
                                  imageUrl: "${AppUrls.baseUrl}/${data.posterImg}",
                                  width: 250,
                                  height: 160,
                                ),
                              ),
                            ),
                            sb5h(),
                            SizedBox(
                              width: 200,
                              child: TextWidget(
                                text: '${data.name}',
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

class CategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;
  final bool cutFromRight;
  final double imgHeight;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
    required this.cutFromRight,
    required this.imgHeight,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _bounceAnimation;
  Animation<double>? _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: widget.cutFromRight ? TopRightRoundedSlopeClipper() : TopLeftRoundedSlopeClipper(),
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: widget.cutFromRight ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: widget.cutFromRight ? null : -60,
          right: widget.cutFromRight ? -30 : null,
          child: AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounceAnimation!.value),
                child: Transform.rotate(
                  angle: _rotateAnimation!.value,
                  child: child,
                ),
              );
            },
            child: Image.asset(
              widget.imagePath,
              height: widget.imgHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class TopRightRoundedSlopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40; // top corner radius

    Path path = Path();

    // Start at top-left, move to rounded corner start
    path.moveTo(0, radius);

    // Curve from top-left to the start of slope
    path.quadraticBezierTo(0, 0, radius, 0);

    // Draw the slope downwards to top-right corner
    path.lineTo(size.width - radius, size.height * 0.25);

    // Curve for top-right corner
    path.quadraticBezierTo(size.width, size.height * 0.25, size.width, size.height * 0.25 + radius);

    // Complete rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopLeftRoundedSlopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40;

    Path path = Path();

    // Start at top-right, move to rounded corner start
    path.moveTo(size.width, radius);

    // Curve from top-right to slope start
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);

    // Draw slope downwards to top-left
    path.lineTo(radius, size.height * 0.25);

    // Curve for top-left corner
    path.quadraticBezierTo(0, size.height * 0.25, 0, size.height * 0.25 + radius);

    // Complete rectangle
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
