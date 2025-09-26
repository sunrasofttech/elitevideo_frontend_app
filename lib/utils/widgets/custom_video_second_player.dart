// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:last_pod_player/last_pod_player.dart';
// import 'package:elite/custom_model/movie_model.dart';
// import 'package:elite/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class AdSlot {
//   final Duration time;
//   final VideoAd ad;
//   bool played;

//   AdSlot({required this.time, required this.ad, this.played = false});
// }

// class PlayerWidget extends StatefulWidget {
//   final String audioUrl;
//   final Function(int watchTime, {bool isWatched}) handleOnChanged;
//   final List<MovieAd>? ads;
//   final int? lastPosition;
//   final bool isLive;
//   const PlayerWidget({
//     super.key,
//     required this.audioUrl,
//     required this.handleOnChanged,
//     this.ads,
//     this.isLive = false,
//     this.lastPosition,
//   });

//   @override
//   State<PlayerWidget> createState() => _PlayerWidgetState();
// }

// class _PlayerWidgetState extends State<PlayerWidget> with WidgetsBindingObserver {
//   String _url = "";
//   VideoPlayerController? _videoController;
//   ChewieController? _chewieController;
//   PodPlayerController? _podController;
//   Duration _videoDuration = Duration.zero;
//   bool isYoutube = false;
//   bool videoLoadFailed = false;
//   SharedPreferences? _prefs;
//   Timer? _saveTimer;
//   final List<AdSlot> _scheduledAds = [];

//   @override
//   void initState() {
//     super.initState();
//     log("---------------------->>>>> player--INITSTATE--widget <<<<<-------------------------");
//     WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((callback) async {
//       await initVideoPlayer();
//       startLogging();
//       await _initSharedPreferencesAndTimestamp();
//     });
//   }

//   @override
//   void dispose() {
//     log("PLAYER WIDGET DISPOSE CALLED <-----------");
//     stopLogging();
//     _saveTimer?.cancel();
//     try {
//       log("----------disposing _videoController----------");
//       _videoController?.pause();
//       _chewieController?.dispose();
//       _videoController?.dispose();
//     } catch (e) {
//       log("Error disposing _videoController or _chewieController: $e");
//     }

//     try {
//       log("----------disposing _podController----------");
//       _podController?.pause();
//       _podController?.dispose();
//     } catch (e) {
//       log("Error disposing _podController: $e");
//     }
//     super.dispose();
//   }

//   Future<void> initVideoPlayer() async {
//     if (isYoutube) {
//       log("INITIALIZING YOUTUBE:- $_url");
//       await _initializeYoutube();
//     } else {
//       log("INITIALIZING VIDEO PLAYER $_url");
//       _initializePlayer();
//     }
//   }

//   Future<void> _initializeYoutube() async {
//     try {
//       final videoId = YoutubePlayerController.convertUrlToId(_url);
//       log("This is url:- $_url");
//       if (videoId != null) {
//         _podController = PodPlayerController(
//           playVideoFrom: PlayVideoFrom.youtube(_url),
//           podPlayerConfig: const PodPlayerConfig(
//             autoPlay: false,
//             isLooping: false,
//             wakelockEnabled: true,
//             videoQualityPriority: [144, 240, 360],
//           ),
//         );
//         await _podController!.initialise();

//         if (widget.lastPosition != null && (widget.lastPosition! > 0)) {
//           log("Video BAR SEEKING TO:- ${widget.lastPosition}");
//         }
//       }
//     } catch (e, s) {
//       // setState(() {
//       videoLoadFailed = true;
//       // });
//       log("catch error on _initializeYoutube $e, $s");
//       AppToast.showError(msg: "Unable to load this video, please try again later");
//     }

//     setState(() {});
//   }

//   Future<void> _initializePlayer() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 1000));

//       log(">>>> PLAYING FROM NETWORK <<<<");

//       _videoController = VideoPlayerController.networkUrl(Uri.parse(_url))
//         ..addListener(() {
//           try {
//             if (showAds) {
//               log("is User Subscribed => $showAds");
//               _scheduleAds(_videoDuration);
//             }
//           } catch (e, s) {
//             log(">>>> CATCH ERROR WHILE SETTING THE ADS $e, $s <<<<");
//           }
//         });

//       await _videoController!.initialize();

//       // if (widget.recent.inSeconds > 0) {
//       //   log("Video BAR SEEKING TO:- ${widget.recent.inSeconds}");
//       //   _videoController!.seekTo(widget.recent);
//       // }

//       _chewieController = ChewieController(
//         videoPlayerController: _videoController!,
//         allowPlaybackSpeedChanging: true,
//         autoPlay: false,
//         looping: false,
//         allowFullScreen: true,
//         allowMuting: true,
//         deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
//         deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//         subtitle: Subtitles([
//           Subtitle(
//             index: 0,
//             start: const Duration(seconds: 1),
//             end: const Duration(seconds: 5),
//             text: 'This is a sample caption',
//           ),
//         ]),
//         subtitleBuilder: (context, subtitle) => Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(5)),
//           child: Text(subtitle, style: const TextStyle(color: Colors.white)),
//         ),
//         showControls: true,
//       );
//       setState(() {
//         videoLoadFailed = false;
//       });
//     } catch (e, s) {
//       log("Catch Error While video initialization: $e, $s");
//       setState(() {
//         videoLoadFailed = true;
//       });
//       if (mounted) AppToast.showError(msg: "Unable to load the video.. Please try again later...");
//     }
//   }

//   void _resumeMainVideo(Duration resumeFrom) {
//     // log("called resume main video 1");
//     // _disposeController();

//     setState(() {
//       _isAd = false;
//       _showSkipButton = false;
//     });

//     _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.audioUrl))
//       ..initialize().then((e) {
//         log("called resume main video == 2");
//         _videoController!.seekTo(resumeFrom).then((e) {
//           log("called resume main video == 3 $resumeFrom");
//           _controller = ChewieController(
//             videoPlayerController: _videoController!,
//             autoPlay: false,
//             looping: false,
//           );
//           log("called resume main video == 4 ${_videoController?.position}");
//           _addProgressListener();
//           setState(() {});
//         });
//       });
//   }

//   void _addProgressListener() {
//     _videoController!.addListener(() {
//       final current = _videoController!.value.position;
//       widget.handleOnChanged(current.inSeconds, isWatched: false);

//       if (_lastLoggedSecond != current.inSeconds) {
//         _lastLoggedSecond = current.inSeconds;
//       }

//       for (final adSlot in List<AdSlot>.from(_scheduledAds)) {
//         final diff = current.inSeconds - adSlot.time.inSeconds;
//         if (!adSlot.played && diff >= 0 && diff <= 1) {
//           adSlot.played = true;
//           _playAd(adSlot.ad, current);
//           break;
//         }
//       }

//       if (_videoController!.value.position >= _videoDuration && !_isAd && !_hasCompletedVideo) {
//         _hasCompletedVideo = true;
//         widget.handleOnChanged(_videoDuration.inSeconds, isWatched: true);
//       }
//     });
//   }

//   Future<void> _initSharedPreferencesAndTimestamp() async {
//     _prefs = await SharedPreferences.getInstance();
//     await _prefs?.setInt("videoTimestampKey", 0);
//     log("Initialized videoTimestampKey to 0 in SharedPreferences.");
//   }

//   Timer? _timer;
//   void startLogging() async {
//     if (userId == null) {
//       log('USER Id is Null');
//       return;
//     }

//     if (_timer != null && _timer!.isActive) {
//       log('YoutubePlayerLogger: Timer already active.');
//       return;
//     }

//     _timer = Timer.periodic(const Duration(seconds: 50), (timer) async {
//       double totalSeconds;
//       double currentSeconds;

//       if (_podController == null) {
//         currentSeconds = _videoController!.value.position.inSeconds.toDouble();
//         totalSeconds = _videoController!.value.duration.inSeconds.toDouble();
//         log("VIDEO PLAYER CURRENT SECONDS: ${currentSeconds.toDouble().toStringAsFixed(2)}");
//       } else {
//         currentSeconds = _podController!.currentVideoPosition.inSeconds.toDouble();
//         totalSeconds = _podController!.totalVideoLength.inSeconds.toDouble();
//         log("_podController YOUTUBE DURATION__________ ${_podController!.totalVideoLength.inSeconds}");
//         log("_podController YOUTUBE SECONDS__________ ${currentSeconds.toStringAsFixed(2)}");
//       }
//     });
//   }

//   void _scheduleAds(Duration videoDuration) {
//     final ads = widget.ads ?? [];
//     if (ads.isEmpty) return;

//     for (int i = 0; i < ads.length; i++) {
//       final slotTime =
//           i == 0 ? const Duration(seconds: 0) : Duration(seconds: (videoDuration.inSeconds * i ~/ ads.length));
//       final videoAd = ads[i].videoAd ?? VideoAd();
//       _scheduledAds.add(AdSlot(time: slotTime, ad: videoAd));
//     }
//   }

//   void stopLogging() {
//     if (_timer != null && _timer!.isActive) {
//       _timer!.cancel();
//       _timer = null;
//       log("YoutubePlayerLogger: Stopped logging timer.");
//     }
//   }

//   Widget _circularProgressBarWithImg() {
//     return const Center(child: CircularProgressIndicator());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         log("Will POP SCOPE CALLED [PLAYING SCREEN]");
//         if (_podController?.isVideoPlaying ?? false) {
//           _podController?.pause();
//         }
//         return true;
//       },
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * 0.3,
//         width: double.infinity,
//         child: videoLoadFailed
//             ? const Center(
//                 child: Text(
//                   "Oops, something went wrong.. please try again later...",
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             : isYoutube
//                 ? (_podController != null && _podController!.isInitialised)
//                     ? PodVideoPlayer(
//                         controller: _podController!,
//                         podProgressBarConfig: const PodProgressBarConfig(
//                           circleHandlerColor: Color(0xFF813AD5),
//                           bufferedBarColor: Color(0xFF291836),
//                           playingBarColor: Color(0xFF813AD5),
//                           backgroundColor: Color(0xFF291836),
//                           padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
//                         ),
//                         // videoThumbnail: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.cover),
//                       )
//                     : _circularProgressBarWithImg()
//                 : (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
//                     ? AspectRatio(
//                         aspectRatio: _videoController!.value.aspectRatio,
//                         child: Stack(
//                           children: [
//                             Chewie(controller: _chewieController!),
//                           ],
//                         ),
//                       )
//                     : _circularProgressBarWithImg(),
//       ),
//     );
//   }
// }
