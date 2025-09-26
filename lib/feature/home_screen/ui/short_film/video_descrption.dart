import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/post_continue_watching/post_continue_watching_cubit.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_cubit.dart';
import 'package:elite/model/genre.dart';
import 'package:elite/model/short_film.dart' as model;
import 'package:elite/feature/home_screen/bloc/get_cast_crew/get_cast_crew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_watchlist/post_watchlist_cubit.dart';
import 'package:elite/utils/storage/hive_db.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_video_player.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../custom_model/short_film_model.dart' as short;
import '../../bloc/get_continue_watching/get_continue_watching_cubit.dart';

class ShortFlimDescrptionScreen extends StatefulWidget {
  const ShortFlimDescrptionScreen({super.key, required this.model, this.lastPosition});
  final short.ShortFilm model;
  final int? lastPosition;

  @override
  State<ShortFlimDescrptionScreen> createState() => _ShortFlimDescrptionScreenState();
}

class _ShortFlimDescrptionScreenState extends State<ShortFlimDescrptionScreen> with Utility {
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  PostContinueWatchingCubit? _watchingCubit;
  Future<void> _downloadVideo({required model.ShortFilm movie}) async {
    try {
      setState(() {
        _isDownloading = true;
      });
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.mp4';
      final imageFileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final videoFilePath = '${dir.path}/$fileName';
      final imageFilePath = '${dir.path}/$imageFileName';

      await Dio().download(
        widget.model.shortVideo?.contains("https") ?? false
            ? "${widget.model.shortVideo}"
            : "${AppUrls.baseUrl}/${widget.model.shortVideo}",
        videoFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      await Dio().download(
        "${movie.posterImg}",
        imageFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      movie.localVideoPath = videoFilePath;
      movie.localImagePath = imageFilePath;
      await HiveDb.saveShortFilVideo(movie);
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });

      AppToast.showSuccess(context, "Download", "Download Successfully".tr());
    } catch (e) {
      AppToast.showError(context, "Download", "Download Failed $e");
    }
  }

  @override
  void initState() {
    FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    context.read<GetCastCrewCubit>().getCastCrew(
          movieId: widget.model.id ?? "",
        );
    _checkIfDownloaded();
    super.initState();
  }

  @override
  void dispose() {
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    context.read<GetContinueWatchingCubit>().getContinueWatching();
    super.dispose();
  }

  void _checkIfDownloaded() {
    final id = widget.model.id ?? "";
    _isDownloaded = HiveDb.isShortFilmDownloaded(id);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchingCubit = context.read<PostContinueWatchingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<GetContinueWatchingCubit>().getContinueWatching();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              context.read<GetContinueWatchingCubit>().getContinueWatching();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColor.whiteColor,
            ),
          ),
          title: TextWidget(
            text: "${widget.model.shortFilmTitle}",
            fontSize: 15,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: CustomVideoPlayer(
                      lastPosition: widget.lastPosition,
                      ads: widget.model.shortfilmAds,
                      audioUrl: (widget.model.shortVideo == null && widget.model.shortVideo!.isEmpty)
                          ? "${widget.model.videoLink}"
                          : widget.model.shortVideo?.contains("https") ?? false
                              ? "${AppUrls.baseUrl}/${widget.model.shortVideo}"
                              : "${AppUrls.baseUrl}/${widget.model.shortVideo}",
                      handleOnChanged: (int watchTime, {bool isWatched = false}) {
                        final videoUrl = (widget.model.shortVideo?.isNotEmpty == true
                            ? "${AppUrls.baseUrl}/${widget.model.shortVideo}"
                            : widget.model.videoLink ?? "");
                        log("videoUrl=====> $videoUrl");
                        if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
                          return;
                        }
                        _watchingCubit?.postContinueWatching(
                          contentType: ContentType.shortfilm,
                          typeId: widget.model.id,
                          currentTime: watchTime,
                          isWatched: isWatched,
                        );
                      },
                    ),
                  ),
                ),
                sb20h(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocListener<PostWatchlistCubit, PostWatchlistState>(
                      listener: (context, state) {
                        if (state is PostWatchlistErrorState) {
                          AppToast.showError(context, state.error, "");
                          return;
                        }

                        if (state is PostWatchlistLoadedState) {
                          AppToast.showError(context, "Added to watch List".tr(), "");
                          context.read<GetWatchlistCubit>().getWatchList();
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          context.read<PostWatchlistCubit>().postWatchList(
                                shortfilmId: widget.model.id ?? "",
                                type: ContentType.shortfilm,
                              );
                        },
                        child: Column(
                          children: [
                            IconButton(
                              color: AppColor.whiteColor,
                              onPressed: () {
                                context.read<PostWatchlistCubit>().postWatchList(
                                      shortfilmId: widget.model.id ?? "",
                                      type: ContentType.shortfilm,
                                    );
                              },
                              icon: const Icon(Icons.add),
                            ),
                            TextWidget(
                              text: "Add To WatchList".tr(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          color: AppColor.whiteColor,
                          onPressed: () {
                            final movieId = widget.model.id ?? "";
                            final link = "https://bigcinema.com?type=${ContentType.shortfilm}&id=$movieId";
                            Share.share("Watch this Short Film on ${AppString.appName} 🎬\n$link");
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                          ),
                        ),
                        TextWidget(
                          text: "Share".tr(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: _isDownloading ? _downloadProgress : 1,
                              strokeWidth: 3,
                              backgroundColor: Colors.grey,
                              color: _isDownloaded ? Colors.green : AppColor.whiteColor,
                            ),
                            IconButton(
                              color: AppColor.whiteColor,
                              onPressed: () {
                                if (!_isDownloading && !_isDownloaded) {
                                  _downloadVideo(
                                    movie: model.ShortFilm(
                                      category: Genre(
                                        coverImg: widget.model.category?.coverImg,
                                        createdAt: widget.model.category?.createdAt,
                                        id: widget.model.category?.id,
                                        name: widget.model.category?.name,
                                        status: widget.model.category?.status,
                                        updatedAt: widget.model.category?.updatedAt,
                                      ),
                                      coverImg: widget.model.coverImg,
                                      createdAt: widget.model.createdAt,
                                      description: widget.model.description,
                                      genre: Genre(
                                        coverImg: widget.model.genre?.coverImg,
                                        createdAt: widget.model.genre?.createdAt,
                                        id: widget.model.genre?.id,
                                        name: widget.model.genre?.name,
                                        status: widget.model.genre?.status,
                                        updatedAt: widget.model.genre?.updatedAt,
                                      ),
                                      genreId: widget.model.genreId,
                                      id: widget.model.id,
                                      isHighlighted: widget.model.isHighlighted,
                                      isMovieOnRent: widget.model.isMovieOnRent,
                                      isWatchlist: widget.model.isWatchlist,
                                      language: Genre(
                                        coverImg: widget.model.language?.coverImg,
                                        createdAt: widget.model.language?.createdAt,
                                        id: widget.model.id,
                                        name: widget.model.language?.name,
                                        status: widget.model.language?.status,
                                        updatedAt: widget.model.language?.updatedAt,
                                      ),
                                      movieCategory: widget.model.movieCategory,
                                      movieLanguage: widget.model.movieLanguage,
                                      shortFilmTitle: widget.model.shortFilmTitle,
                                      movieRentPrice: widget.model.movieRentPrice,
                                      movieTime: widget.model.movieTime,
                                      shortVideo: widget.model.shortVideo,
                                      posterImg: widget.model.posterImg,
                                      quality: widget.model.quality,
                                      releasedBy: widget.model.releasedBy,
                                      releasedDate: widget.model.releasedDate,
                                      status: widget.model.status,
                                      subtitle: widget.model.subtitle,
                                      updatedAt: widget.model.updatedAt,
                                      videoLink: widget.model.videoLink,
                                      averageRating: widget.model.averageRating,
                                      totalRatings: widget.model.totalRatings,
                                      showSubscription: widget.model.showSubscription,
                                      viewCount: widget.model.viewCount,
                                      rentedTimeDays: widget.model.rentedTimeDays.toString(),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                _isDownloaded ? Icons.check : Icons.download,
                                color: _isDownloaded ? Colors.green : AppColor.whiteColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        TextWidget(text: _isDownloading ? "Dowloading" : "Download".tr())
                      ],
                    ),
                  ],
                ),
                sb20h(),
                BlocBuilder<GetCastCrewCubit, GetCastCrewState>(
                  builder: (context, state) {
                    if (state is GetCastCrewLoadingState) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    if (state is GetCastCrewLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "Cast".tr(),
                          ),
                          sb10h(),
                          state.model.data?.isEmpty ?? true
                              ? TextWidget(text: "No Cast Crew Avaliable".tr())
                              : SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var data = state.model.data?[index];
                                      return Column(
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
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor: Colors.white,
                                              child: ClipOval(
                                                child: Image.network(
                                                  "${AppUrls.baseUrl}/${data?.profileImg ?? ''}",
                                                  width: 44,
                                                  height: 44,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      'asset/test/default.png',
                                                      width: 44,
                                                      height: 44,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          sb5h(),
                                          TextWidget(text: "${data?.name}"),
                                          sb5h(),
                                          TextWidget(
                                            text: "${data?.role}",
                                            color: AppColor.greyColor,
                                          )
                                        ],
                                      );
                                    },
                                    itemCount: state.model.data?.length,
                                  ),
                                ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                sb10h(),
                TextWidget(
                  text: "Description".tr(),
                ),
                sb10h(),
                Html(
                  data: widget.model.description,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14.0),
                      color: AppColor.whiteColor,
                    ),
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
