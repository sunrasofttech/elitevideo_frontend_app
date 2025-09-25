// import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/profile/bloc/get_watchlist/get_watchlist_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/storage/hive_db.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../model/episode.dart' as ep;
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_model.dart';
import 'package:elite/feature/home_screen/bloc/get_cast_crew/get_cast_crew_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/post_watchlist/post_watchlist_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_video_player.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:path_provider/path_provider.dart';

import '../../bloc/post_continue_watching/post_continue_watching_cubit.dart';

class EpisodeDescScreen extends StatefulWidget {
  const EpisodeDescScreen({super.key, required this.episode, this.lastPosition});
  final Episode? episode;
  final int? lastPosition;

  @override
  State<EpisodeDescScreen> createState() => _EpisodeDescScreenState();
}

class _EpisodeDescScreenState extends State<EpisodeDescScreen> with Utility {
  @override
  void initState() {
    super.initState();
    // FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    _checkIfDownloaded();
  }

  @override
  void dispose() {
    //  FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    context.read<GetContinueWatchingCubit>().getContinueWatching();
    super.dispose();
  }

  PostContinueWatchingCubit? _watchingCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchingCubit = context.read<PostContinueWatchingCubit>();
  }

  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  bool _isDownloaded = false;

  Future<void> _downloadVideo({required ep.Episode episode}) async {
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
        widget.episode?.video?.contains("https") ?? false
            ? "${widget.episode?.video}"
            : "https://${widget.episode?.video}",
        "${AppUrls.baseUrl}/${episode.video}",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      await Dio().download(
        "${AppUrls.baseUrl}/${episode.coverImg}",
        imageFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      episode.localVideoPath = videoFilePath;
      episode.localImagePath = imageFilePath;
      await HiveDb.saveEpisodeVideo(episode);
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });

      AppToast.showSuccess(context, "", "Download Successfully".tr());
    } catch (e) {
      AppToast.showError(context, "", "Download Failed $e");
    }
  }

  void _checkIfDownloaded() {
    final id = widget.episode?.id ?? "";
    _isDownloaded = HiveDb.isEpisodeDownloaded(id);
    setState(() {});
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
            text: "${widget.episode?.episodeName}",
            fontSize: 15,
          ),
        ),
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: CustomVideoPlayer(
                  lastPosition: widget.lastPosition,
                  ads: widget.episode?.episodeAd,
                  audioUrl: (widget.episode?.video == null || widget.episode!.video!.isEmpty)
                      ? "${widget.episode?.videoLink}"
                      : widget.episode?.video?.contains("https") ?? false
                          ? "${widget.episode?.video}"
                          : "https://${widget.episode?.video}",
                  handleOnChanged: (int watchTime, {bool isWatched = false}) {
                    log("==============$watchTime=============");

                    final videoUrl = (widget.episode?.video?.isNotEmpty == true
                        ? "https://${widget.episode?.video}"
                        : widget.episode?.videoLink ?? "");
                    log("videoUrl=====> $videoUrl");
                    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
                      return;
                    }
                    _watchingCubit?.postContinueWatching(
                      contentType: ContentType.season_episode,
                      typeId: widget.episode?.id,
                      currentTime: watchTime,
                      isWatched: isWatched,
                    );
                  },
                ),
              ),
            ),
            sb20h(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocListener<PostWatchlistCubit, PostWatchlistState>(
                            listener: (context, state) {
                              if (state is PostWatchlistErrorState) {
                                AppToast.showError(context, "WatchList", state.error);
                                return;
                              }

                              if (state is PostWatchlistLoadedState) {
                                AppToast.showError(context, "WatchList", "Added to watch List".tr());
                                context.read<GetWatchlistCubit>().getWatchList();
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                context.read<PostWatchlistCubit>().postWatchList(
                                      seasonEpisodeId: widget.episode?.id ?? "",
                                      type: ContentType.season_episode,
                                    );
                              },
                              child: Column(
                                children: [
                                  IconButton(
                                    color: AppColor.whiteColor,
                                    onPressed: () {
                                      context.read<PostWatchlistCubit>().postWatchList(
                                            seasonEpisodeId: widget.episode?.id ?? "",
                                            type: ContentType.season_episode,
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
                                  final movieId = widget.episode?.id ?? "";
                                  final link = "https://bigcinema.com?type=${ContentType.season_episode}&id=$movieId";
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
                                          episode: ep.Episode(
                                            userId: userId,
                                            coverImg: widget.episode?.coverImg,
                                            createdAt: widget.episode?.createdAt,
                                            id: widget.episode?.id,
                                            releasedDate: widget.episode?.releasedDate,
                                            status: widget.episode?.status,
                                            updatedAt: widget.episode?.updatedAt,
                                            videoLink: widget.episode?.videoLink,
                                            video: widget.episode?.video,
                                            episodeName: widget.episode?.episodeName,
                                            episodeNo: widget.episode?.episodeNo,
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
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: TextWidget(
                          text:
                              "Episode ${widget.episode?.episodeNo ?? 'N/A'}: ${widget.episode?.episodeName ?? 'N/A'}",
                          fontSize: 18,
                          maxlines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          color: AppColor.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: TextWidget(
                          text: "Released: ${_formatDate(widget.episode?.releasedDate.toString())}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      // TextWidget(
                      //   text: "Description".tr(),
                      // ),
                      // sb10h(),
                      // Html(
                      //   data: widget.episode?.,
                      //   style: {
                      //     "body": Style(
                      //       fontSize: FontSize(14.0),
                      //       color: AppColor.whiteColor,
                      //     ),
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return 'Invalid date';
    }
  }
}
