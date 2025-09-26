import 'dart:async';
import 'dart:developer';
import 'package:chewie/chewie.dart'; //network
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_pod_player/last_pod_player.dart'; //youtube
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/widgets/custom_svg.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:video_player/video_player.dart';
import '../../custom_model/movie_model.dart';

class AdSlot {
  final Duration time;
  final VideoAd ad;
  bool played;

  AdSlot({required this.time, required this.ad, this.played = false});
}

class CustomVideoPlayer extends StatefulWidget {
  final String audioUrl;
  final Function(int watchTime, {bool isWatched}) handleOnChanged;
  final List<MovieAd>? ads;
  final int? lastPosition;
  final bool isLive;
  const CustomVideoPlayer({
    super.key,
    required this.audioUrl,
    required this.handleOnChanged,
    this.ads,
    this.isLive = false,
    this.lastPosition,
  });

  @override
  CustomVideoPlayerState createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> with WidgetsBindingObserver {
  ChewieController? _controller;
  VideoPlayerController? _videoPlayerController;
  PodPlayerController? _podController;
  final List<AdSlot> _scheduledAds = [];
  bool _isAd = false;
  bool _showSkipButton = false;
  int _skipCountdown = 0;
  Timer? _skipCountdownTimer;
  Duration _videoDuration = Duration.zero;
  Duration _lastMainVideoPosition = Duration.zero;
  int? _lastLoggedSecond;
  bool _hasCompletedVideo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastMainVideoPosition = Duration(seconds: widget.lastPosition ?? 0);
    if (_isYouTubeUrl(widget.audioUrl)) {
      _setupYouTubePlayer();
    } else {
      _playMainVideo();
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  String _getYouTubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    } else if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  String cleanYouTubeUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (uri.host.contains('youtu.be')) {
      final videoId = uri.pathSegments.first;
      return 'https://www.youtube.com/watch?v=$videoId';
    }

    if (uri.host.contains('youtube.com')) {
      final videoId = uri.queryParameters['v'];
      if (videoId != null) {
        return 'https://www.youtube.com/watch?v=$videoId';
      }
    }

    return url;
  }

  void _setupYouTubePlayer() async {
    try {
      final cleanUrl = widget.isLive ? widget.audioUrl : cleanYouTubeUrl(widget.audioUrl);
      _podController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(
          cleanUrl,
          live: widget.isLive,
        ),
        podPlayerConfig: const PodPlayerConfig(
          videoQualityPriority: [360, 720, 1080],
          autoPlay: true,
        ),
      );

      await _podController?.initialise();

      setState(() {});
    } catch (e, stk) {
      log("YouTube init error: $e\n$stk");
    }
  }

  bool _visible = true;
  Timer? _hideTimer;

  void _resetHideTimer(setS) {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) _visible = false;
      log("111 _resetHideTimer => $_visible");
      if (mounted) setS(() {});
    });
  }

  void _toggleControls(setS) {
    _visible = !_visible;
    log("111 _toggleControls => $_visible");
    if (_visible) _resetHideTimer(setS);
    if (mounted) setS(() {});
  }

  final ValueNotifier<bool> _isBuffering = ValueNotifier(false);

  void _addBufferListener() {
    _videoPlayerController?.addListener(() {
      _isBuffering.value = _videoPlayerController?.value.isBuffering ?? false;
    });
  }

  final ValueNotifier<Duration> _positionNotifier = ValueNotifier(Duration.zero);

  void _playMainVideo() {
    _disposeController();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.audioUrl))
      ..initialize().then((_) {
        _videoDuration = _videoPlayerController!.value.duration;
        _addBufferListener();
        if (showAds) {
        //  _scheduleAds(_videoDuration);
        }

        if ((widget.lastPosition ?? 0) > 0) {
          _videoPlayerController!.seekTo(Duration(seconds: widget.lastPosition!));
        }
        _controller = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
          showControls: true,
          showControlsOnInitialize: true,
          hideControlsTimer: const Duration(seconds: 3),
          allowFullScreen: true,
          allowMuting: true,
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ],
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
          ],
          systemOverlaysAfterFullScreen: SystemUiOverlay.values,
          aspectRatio: _videoPlayerController?.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            backgroundColor: Colors.white,
            bufferedColor: Colors.grey,
          ),
          customControls: StatefulBuilder(
            builder: (context, setS) {
              String formatDuration(Duration duration) {
                String twoDigits(int n) => n.toString().padLeft(2, '0');
                final hours = duration.inHours;
                final minutes = duration.inMinutes.remainder(60);
                final seconds = duration.inSeconds.remainder(60);
                if (hours > 0) {
                  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
                } else {
                  return '${twoDigits(minutes)}:${twoDigits(seconds)}';
                }
              }

              log("--------------====>${_videoPlayerController!.value} ${widget.audioUrl}");
              _videoPlayerController!.addListener(() {
                if (_videoPlayerController!.value.isInitialized) {
                  _positionNotifier.value = _videoPlayerController!.value.position;
                }
              });
              if (_visible) _resetHideTimer(setS);
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _toggleControls(setS);
                    setS(() {});
                    log("Tapped 1");
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {
                          _toggleControls(setS);
                          setS(() {});
                          log("Tapped 2");
                        },
                        child: SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: GestureDetector(
                            onTap: () {
                              _toggleControls(setS);
                              setS(() {});
                              log("Tapped 3");
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_visible)
                                  IconButton(
                                    iconSize: 60,
                                    color: Colors.white,
                                    icon: Icon(
                                      _videoPlayerController?.value.isPlaying ?? false
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                    ),
                                    onPressed: () {
                                      _videoPlayerController?.value.isPlaying ?? false
                                          ? _videoPlayerController?.pause()
                                          : _videoPlayerController?.play();
                                      _resetHideTimer(setS);
                                      setS(() {});
                                    },
                                  ),
                                if (_visible)
                                  Positioned(
                                    left: 40,
                                    child: GestureDetector(
                                      onTap: () {
                                        final pos = _videoPlayerController?.value.position;
                                        _videoPlayerController?.seekTo(pos! - const Duration(seconds: 10));
                                        _resetHideTimer(setS);
                                        setS(() {});
                                      },
                                      child: const CustomSvgImage(
                                        imageUrl: "asset/video/backward-10-seconds.svg",
                                      ),
                                    ),
                                  ),
                                if (_visible)
                                  Positioned(
                                    right: 40,
                                    child: GestureDetector(
                                      onTap: () {
                                        final pos = _videoPlayerController?.value.position;
                                        _videoPlayerController?.seekTo(pos! + const Duration(seconds: 10));
                                        _resetHideTimer(setS);
                                        setS(() {});
                                      },
                                      child: const CustomSvgImage(
                                        imageUrl: "asset/video/forward-10-seconds.svg",
                                      ),
                                    ),
                                  ),

                                // Top bar
                                if (_visible)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.black87,
                                              builder: (context) {
                                                return SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          "Playback Speed",
                                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        ...[0.5, 1.0, 1.5, 2.0].map((speed) {
                                                          return ListTile(
                                                            title: Text(
                                                              "${speed}x",
                                                              style: const TextStyle(color: Colors.white),
                                                            ),
                                                            onTap: () {
                                                              _videoPlayerController?.setPlaybackSpeed(speed);
                                                              _resetHideTimer(setS);
                                                              setS(() {});
                                                              Navigator.pop(context);
                                                            },
                                                          );
                                                        }).toList(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const CustomSvgImage(
                                            imageUrl: "asset/video/setting.svg",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Bottom bar
                                if (_visible)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: VideoProgressIndicator(
                                                _videoPlayerController!,
                                                allowScrubbing: true,
                                                colors: const VideoProgressColors(
                                                  playedColor: Colors.white,
                                                  bufferedColor: Colors.white54,
                                                  backgroundColor: Colors.white24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (_controller?.isFullScreen ?? false) {
                                                  _controller?.exitFullScreen();
                                                } else {
                                                  _controller?.enterFullScreen();
                                                }
                                              },
                                              child: const CustomSvgImage(
                                                imageUrl: "asset/video/screen-rotate.svg",
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              ValueListenableBuilder<Duration>(
                                                valueListenable: _positionNotifier,
                                                builder: (context, position, _) {
                                                  return Text(
                                                    formatDuration(position),
                                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                                  );
                                                },
                                              ),
                                              const Text(
                                                " / ",
                                                style: TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                              Text(
                                                formatDuration(_videoPlayerController!.value.duration),
                                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );

        _addProgressListener();
        setState(() {});
      });
  }

  void _addProgressListener() {
    _videoPlayerController!.addListener(() {
      final current = _videoPlayerController!.value.position;
      widget.handleOnChanged(current.inSeconds, isWatched: false);

      if (_lastLoggedSecond != current.inSeconds) {
        _lastLoggedSecond = current.inSeconds;
      }

      for (final adSlot in List<AdSlot>.from(_scheduledAds)) {
        final diff = current.inSeconds - adSlot.time.inSeconds;
        if (!adSlot.played && diff >= 0 && diff <= 1) {
          adSlot.played = true;
          _playAd(adSlot.ad, current);
          break;
        }
      }

      if (_videoPlayerController!.value.position >= _videoDuration && !_isAd && !_hasCompletedVideo) {
        _hasCompletedVideo = true;
        widget.handleOnChanged(_videoDuration.inSeconds, isWatched: true);
      }
    });
  }

  void _scheduleAds(Duration videoDuration) {
    final ads = widget.ads ?? [];
    if (ads.isEmpty) return;

    for (int i = 0; i < ads.length; i++) {
      final slotTime =
          i == 0 ? const Duration(seconds: 0) : Duration(seconds: (videoDuration.inSeconds * i ~/ ads.length));
      final videoAd = ads[i].videoAd ?? VideoAd();
      _scheduledAds.add(AdSlot(time: slotTime, ad: videoAd));
    }
  }

  void _playAd(VideoAd ad, Duration mainVideoPosition) {
    _videoPlayerController?.pause();
    _disposeController();

    setState(() {
      _isAd = true;
      _showSkipButton = true;
      _skipCountdown = _parseDuration(ad.skipTime ?? "").inSeconds;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      ad.adVideo?.contains("https") ?? true ? "${ad.adVideo}" : "https://${ad.adVideo}",
    ))
      ..initialize().then((_) {
        _controller = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showControls: false,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          allowedScreenSleep: false,
          isLive: widget.isLive,
          placeholder: const Center(
            child: CustomCircularProgressIndicator(),
          ),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: TextWidget(text: "Error to Init Vide $errorMessage"),
            );
          },
          customControls: StatefulBuilder(
            builder: (context, setS) {
              String formatDuration(Duration duration) {
                String twoDigits(int n) => n.toString().padLeft(2, '0');
                final hours = duration.inHours;
                final minutes = duration.inMinutes.remainder(60);
                final seconds = duration.inSeconds.remainder(60);
                if (hours > 0) {
                  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
                } else {
                  return '${twoDigits(minutes)}:${twoDigits(seconds)}';
                }
              }

              log("--------------====>${_videoPlayerController!.value} ${widget.audioUrl}");
              _videoPlayerController!.addListener(() {
                if (_videoPlayerController!.value.isInitialized) {
                  _positionNotifier.value = _videoPlayerController!.value.position;
                }
              });
              if (_visible) _resetHideTimer(setS);
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _toggleControls(setS);
                    setS(() {});
                    log("Tapped 1");
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {
                          _toggleControls(setS);
                          setS(() {});
                          log("Tapped 2");
                        },
                        child: SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: GestureDetector(
                            onTap: () {
                              _toggleControls(setS);
                              setS(() {});
                              log("Tapped 3");
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_visible)
                                  IconButton(
                                    iconSize: 60,
                                    color: Colors.white,
                                    icon: Icon(
                                      _videoPlayerController?.value.isPlaying ?? false
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                    ),
                                    onPressed: () {
                                      _videoPlayerController?.value.isPlaying ?? false
                                          ? _videoPlayerController?.pause()
                                          : _videoPlayerController?.play();
                                      _resetHideTimer(setS);
                                      setS(() {});
                                    },
                                  ),
                                if (_visible)
                                  Positioned(
                                    left: 40,
                                    child: GestureDetector(
                                      onTap: () {
                                        final pos = _videoPlayerController?.value.position;
                                        _videoPlayerController?.seekTo(pos! - const Duration(seconds: 10));
                                        _resetHideTimer(setS);
                                        setS(() {});
                                      },
                                      child: const CustomSvgImage(
                                        imageUrl: "asset/video/backward-10-seconds.svg",
                                      ),
                                    ),
                                  ),
                                if (_visible)
                                  Positioned(
                                    right: 40,
                                    child: GestureDetector(
                                      onTap: () {
                                        final pos = _videoPlayerController?.value.position;
                                        _videoPlayerController?.seekTo(pos! + const Duration(seconds: 10));
                                        _resetHideTimer(setS);
                                        setS(() {});
                                      },
                                      child: const CustomSvgImage(
                                        imageUrl: "asset/video/forward-10-seconds.svg",
                                      ),
                                    ),
                                  ),

                                // Top bar
                                if (_visible)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.black87,
                                              builder: (context) {
                                                return SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          "Playback Speed",
                                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        ...[0.5, 1.0, 1.5, 2.0].map((speed) {
                                                          return ListTile(
                                                            title: Text(
                                                              "${speed}x",
                                                              style: const TextStyle(color: Colors.white),
                                                            ),
                                                            onTap: () {
                                                              _videoPlayerController?.setPlaybackSpeed(speed);
                                                              _resetHideTimer(setS);
                                                              setS(() {});
                                                              Navigator.pop(context);
                                                            },
                                                          );
                                                        }).toList(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const CustomSvgImage(
                                            imageUrl: "asset/video/setting.svg",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Bottom bar
                                if (_visible)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: VideoProgressIndicator(
                                                _videoPlayerController!,
                                                allowScrubbing: true,
                                                colors: const VideoProgressColors(
                                                  playedColor: Colors.white,
                                                  bufferedColor: Colors.white54,
                                                  backgroundColor: Colors.white24,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (_controller?.isFullScreen ?? false) {
                                                  _controller?.exitFullScreen();
                                                } else {
                                                  _controller?.enterFullScreen();
                                                }
                                              },
                                              child: const CustomSvgImage(
                                                imageUrl: "asset/video/screen-rotate.svg",
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              ValueListenableBuilder<Duration>(
                                                valueListenable: _positionNotifier,
                                                builder: (context, position, _) {
                                                  return Text(
                                                    formatDuration(position),
                                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                                  );
                                                },
                                              ),
                                              const Text(
                                                " / ",
                                                style: TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                              Text(
                                                formatDuration(_videoPlayerController!.value.duration),
                                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
         
        );
        _startSkipCountdown();

        _videoPlayerController!.addListener(() {
          if (_videoPlayerController!.value.position >= _videoPlayerController!.value.duration) {
            _skipCountdownTimer?.cancel();
            _resumeMainVideo(_lastMainVideoPosition);
          }
        });

        setState(() {});
      });
  }

  void _resumeMainVideo(Duration resumeFrom) {
    log("called resume main video 1");
    _disposeController();

    setState(() {
      _isAd = false;
      _showSkipButton = false;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.audioUrl))
      ..initialize().then((e) {
        log("called resume main video == 2");
        _videoPlayerController!.seekTo(resumeFrom).then((e) {
          log("called resume main video == 3 $resumeFrom");
          _controller = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: false,
            looping: false,
          );
          log("called resume main video == 4 ${_videoPlayerController?.position}");
          _addProgressListener();
          setState(() {});
        });
      });
  }

  void _startSkipCountdown() {
    _skipCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_skipCountdown > 1) {
        setState(() {
          _skipCountdown--;
        });
      } else {
        setState(() {
          _skipCountdown = 0;
        });
        timer.cancel();
      }
    });
  }

  void _skipAd() {
    _skipCountdownTimer?.cancel();
    _resumeMainVideo(_lastMainVideoPosition);
  }

  Duration _parseDuration(String time) {
    try {
      final parts = time.split(":");
      return Duration(
        minutes: int.parse(parts[0]),
        seconds: int.parse(parts[1]),
      );
    } catch (_) {
      return const Duration(seconds: 5);
    }
  }

  void _disposeController() {
    try {
      _podController?.pause();
      _podController?.dispose();
      _videoPlayerController?.pause();
      _controller?.dispose();
      _controller = null;

      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    } catch (e, stk) {
      log("e=e=e=e=e>>> $e $stk");
    }
  }

  @override
  void deactivate() {
    context.read<GetContinueWatchingCubit>().getContinueWatching();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    final position = _videoPlayerController?.value.position.inSeconds ?? 0;
    if (_hasCompletedVideo) {
      widget.handleOnChanged(position, isWatched: true);
    } else {
      widget.handleOnChanged(position, isWatched: false);
    }
    _disposeController();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _skipCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientationReader(
      builder: (context) {
        final nativeOrientation = NativeDeviceOrientationReader.orientation(context);
        log("Physical orientation 1 : $nativeOrientation");
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   //Todo: check auto roataion if true then only run the below code
        //   if (nativeOrientation == NativeDeviceOrientation.landscapeLeft ||
        //       nativeOrientation == NativeDeviceOrientation.landscapeRight) {
        //     if (!(_controller?.isFullScreen ?? false)) {
        //       // _controller?.aspectRatio = 16/9;
        //       _controller?.enterFullScreen();
        //     }
        //   } else if (nativeOrientation == NativeDeviceOrientation.portraitUp ||
        //       nativeOrientation == NativeDeviceOrientation.portraitDown) {
        //     if (_controller?.isFullScreen ?? false) {
        //       _controller?.exitFullScreen();
        //     }
        //   }
        // });

        if (_isYouTubeUrl(widget.audioUrl)) {
          if (_podController == null || !_podController!.isInitialised) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
          return PodVideoPlayer(
            controller: _podController!,
            videoAspectRatio: 16 / 9,
          );
        }
        if (_videoPlayerController == null || !_videoPlayerController!.value.isInitialized) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }

        return AspectRatio(
          aspectRatio: _videoPlayerController?.value.aspectRatio ?? 16 / 9,
          child: Stack(
            children: [
              if (_controller != null) Chewie(controller: _controller!) else const SizedBox(),
              ValueListenableBuilder<bool>(
                valueListenable: _isBuffering,
                builder: (context, isBuffering, child) {
                  if (!isBuffering) return const SizedBox.shrink();
                  return Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (_isAd && _showSkipButton)
                Positioned(
                  top: 20,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: _skipCountdown == 0 ? _skipAd : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                    child: Text(
                      _skipCountdown == 0 ? "Skip Ad" : "Skip in $_skipCountdown",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Widget _buildCustomProgressBar() {
//   if (_videoDuration.inSeconds == 0) return const SizedBox();

//   final progressPercent = _controller?.videoPlayerController?.value.position.inMilliseconds.toDouble() ?? 0;
//   final totalMillis = _videoDuration.inMilliseconds.toDouble();

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     child: Stack(
//       children: [
//         Container(
//           height: 6,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         Container(
//           height: 6,
//           width: (progressPercent / totalMillis) * MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             color: Colors.redAccent,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         ..._scheduledAds.map((adSlot) {
//           final positionPercent = adSlot.time.inMilliseconds / totalMillis;
//           return Positioned(
//             left: positionPercent * MediaQuery.of(context).size.width,
//             child: Container(
//               width: 4,
//               height: 6,
//               color: Colors.yellow,
//             ),
//           );
//         }),
//       ],
//     ),
//   );
// }

//   class AdSlot {
//   final Duration time;
//   final VideoAd ad;
//   bool played;

//   AdSlot({required this.time, required this.ad, this.played = false});
// }

// class CustomVideoPlayer extends StatefulWidget {
//   final String audioUrl;
//   final Function(int watchTime, {bool isWatched}) handleOnChanged;
//   final List<MovieAd>? ads;
//   final int? lastPosition;

//   const CustomVideoPlayer({
//     super.key,
//     required this.audioUrl,
//     required this.handleOnChanged,
//     this.ads,
//     this.lastPosition,
//   });

//   @override
//   CustomVideoPlayerState createState() => CustomVideoPlayerState();
// }

// class CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   BetterPlayerController? _controller;
//   final List<AdSlot> _scheduledAds = [];
//   YoutubePlayerController? _youtubeController;
//   bool _isAd = false;
//   bool _showSkipButton = false;
//   int _skipCountdown = 0;
//   Timer? _skipCountdownTimer;
//   Duration _videoDuration = Duration.zero;
//   Duration _lastMainVideoPosition = Duration.zero;
//   int? _lastLoggedSecond;
//   bool _hasCompletedVideo = false;

//   @override
//   void initState() {
//     super.initState();
//     if (_isYouTubeUrl(widget.audioUrl)) {
//       _setupYouTubePlayer();
//     } else {
//       _playMainVideo();
//     }
//   }

//   void _setupYouTubePlayer() {
//     final videoId = _getYouTubeVideoId(widget.audioUrl);
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         startAt: widget.lastPosition ?? 0,
//       ),
//     );
//   }

//   bool _isYouTubeUrl(String url) {
//     log("_isYouTubeUrl => $url");
//     return url.contains("youtube.com") || url.contains("youtu.be");
//   }

//   String _getYouTubeVideoId(String url) {
//     final uri = Uri.parse(url);
//     if (uri.host.contains('youtu.be')) {
//       return uri.pathSegments.first;
//     } else if (uri.host.contains('youtube.com')) {
//       return uri.queryParameters['v'] ?? '';
//     }
//     return '';
//   }

//   void _playMainVideo() {
//     try {
//       _disposeController();
//       _controller = BetterPlayerController(
//         const BetterPlayerConfiguration(
//           autoPlay: true,
//           looping: false,
//           aspectRatio: 16 / 9,
//           controlsConfiguration: BetterPlayerControlsConfiguration(),
//         ),
//       );

//       _controller!.setupDataSource(
//         BetterPlayerDataSource(
//           BetterPlayerDataSourceType.network,
//           widget.audioUrl,
//         ),
//       );

//       _addProgressListener();
//     } catch (e, st) {
//       debugPrint("❌ _playMainVideo: $e\n$st");
//     }
//   }

//   void _addProgressListener() {
//     _controller!.addEventsListener((event) async {
//       if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
//         _videoDuration = _controller!.videoPlayerController!.value.duration ?? Duration.zero;
//         _scheduleAds(_videoDuration);

//         if ((widget.lastPosition ?? 0) > 0) {
//           await Future.delayed(const Duration(milliseconds: 300));
//           await _controller!.seekTo(Duration(seconds: widget.lastPosition!));
//           _controller!.play();
//         }
//       }

//       if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
//         final current = _controller!.videoPlayerController!.value.position;
//         widget.handleOnChanged(current.inSeconds, isWatched: false);

//         if (_lastLoggedSecond != current.inSeconds) {
//           _lastLoggedSecond = current.inSeconds;
//           debugPrint("🎯 Current Time: ${current.inSeconds}s");
//         }

//         for (final adSlot in List<AdSlot>.from(_scheduledAds)) {
//           final diff = current.inSeconds - adSlot.time.inSeconds;
//           if (!adSlot.played && diff >= 0 && diff <= 1) {
//             adSlot.played = true;
//             debugPrint("🎬 Playing Ad at ${current.inSeconds}s: ${adSlot.ad.adVideo}");
//             _playAd(adSlot.ad, current);
//             break;
//           }
//         }
//       }

//       if (event.betterPlayerEventType == BetterPlayerEventType.finished && !_isAd) {
//         _hasCompletedVideo = true;
//         widget.handleOnChanged(_videoDuration.inSeconds, isWatched: true);
//       }
//     });
//   }

//   void _scheduleAds(Duration videoDuration) {
//     try {
//       final ads = widget.ads ?? [];
//       if (ads.isEmpty) return;

//       int adCount = ads.length;
//       for (int i = 0; i < adCount; i++) {
//         Duration slotTime =
//             i == 0 ? const Duration(seconds: 0) : Duration(seconds: (videoDuration.inSeconds * i ~/ adCount));

//         final videoAd = ads[i].videoAd ?? VideoAd();
//         _scheduledAds.add(AdSlot(time: slotTime, ad: videoAd));
//         debugPrint("🗓️ Ad Scheduled at: ${slotTime.inSeconds}s for ${AppUrls.baseUrl}${videoAd.adVideo}");
//       }
//     } catch (e, st) {
//       debugPrint("❌ _scheduleAds: $e\n$st");
//     }
//   }

//   void _playAd(VideoAd ad, Duration mainVideoPosition) async {
//     try {
//       _lastMainVideoPosition = mainVideoPosition;

//       _controller!.pause();
//       _disposeController();

//       setState(() {
//         _isAd = true;
//         _showSkipButton = true;
//         _skipCountdown = _parseDuration(ad.skipTime ?? "").inSeconds;
//       });

//       _controller = BetterPlayerController(
//         const BetterPlayerConfiguration(
//           autoPlay: true,
//           looping: false,
//           aspectRatio: 16 / 9,
//           controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
//         ),
//       );

//       _controller!.setupDataSource(
//         BetterPlayerDataSource(
//           BetterPlayerDataSourceType.network,
//           "${AppUrls.baseUrl}${ad.adVideo}",
//         ),
//       );

//       _startSkipCountdown();

//       _controller!.addEventsListener((event) {
//         if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
//           debugPrint("✅ Ad finished, resuming main video at ${_lastMainVideoPosition.inSeconds}s");
//           _skipCountdownTimer?.cancel();
//           _resumeMainVideo(_lastMainVideoPosition);
//         }
//       });
//     } catch (e, st) {
//       debugPrint("❌ _playAd: $e\n$st");
//     }
//   }

//   void _resumeMainVideo(Duration resumeFrom) async {
//     _disposeController();

//     setState(() {
//       _isAd = false;
//       _showSkipButton = false;
//     });

//     try {
//       _controller = BetterPlayerController(
//         const BetterPlayerConfiguration(
//           autoPlay: true,
//           looping: false,
//           aspectRatio: 16 / 9,
//           controlsConfiguration: BetterPlayerControlsConfiguration(),
//         ),
//       );

//       await _controller!.setupDataSource(
//         BetterPlayerDataSource(
//           BetterPlayerDataSourceType.network,
//           widget.audioUrl,
//         ),
//       );
//       await Future.delayed(const Duration(milliseconds: 300));
//       await _controller!.seekTo(resumeFrom);
//       _controller!.play();

//       _addProgressListener();
//     } catch (e, st) {
//       debugPrint("❌ Error resuming main video: $e\n$st");
//     }
//   }

//   void _startSkipCountdown() {
//     try {
//       _skipCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_skipCountdown > 1) {
//           setState(() {
//             _skipCountdown--;
//           });
//         } else {
//           setState(() {
//             _skipCountdown = 0;
//           });
//           timer.cancel();
//         }
//       });
//     } catch (e, st) {
//       debugPrint("❌ _startSkipCountdown: $e\n$st");
//     }
//   }

//   void _skipAd() {
//     _skipCountdownTimer?.cancel();
//     debugPrint("⏭️ Ad skipped, resuming main video at ${_lastMainVideoPosition.inSeconds}s");
//     _resumeMainVideo(_lastMainVideoPosition);
//   }

//   void _disposeController() {
//     _controller?.dispose();
//     _controller = null;
//   }

//   Duration _parseDuration(String time) {
//     try {
//       final parts = time.split(":");
//       return Duration(
//         minutes: int.parse(parts[0]),
//         seconds: int.parse(parts[1]),
//       );
//     } catch (_) {
//       return const Duration(seconds: 5);
//     }
//   }

//   @override
//   void dispose() {
//     final position = _controller?.videoPlayerController?.value.position.inSeconds ??
//         _youtubeController?.value.position.inSeconds ??
//         0;
//     if (_hasCompletedVideo) {
//       widget.handleOnChanged(position, isWatched: true);
//     } else {
//       widget.handleOnChanged(position, isWatched: false);
//     }
//     _youtubeController?.pause();
//     _youtubeController?.dispose();
//     _controller?.pause();
//     _controller?.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     _skipCountdownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isYouTubeUrl(widget.audioUrl)) {
//       return YoutubePlayer(
//         controller: _youtubeController!,
//         showVideoProgressIndicator: true,
//         aspectRatio: 16 / 9,
//       );
//     }
//     return Stack(
//       children: [
//         AspectRatio(
//           aspectRatio: 16 / 9,
//           child: _controller != null ? BetterPlayer(controller: _controller!) : const SizedBox(),
//         ),
//         if (_isAd && _showSkipButton)
//           Positioned(
//             top: 10,
//             right: 10,
//             child: ElevatedButton(
//               onPressed: _skipCountdown == 0 ? _skipAd : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black.withOpacity(0.7),
//               ),
//               child: Text(
//                 _skipCountdown == 0 ? "Skip Ad" : "Skip in $_skipCountdown",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
