import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/music/bloc/add_song_in_playlist/add_song_in_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/choose_for_you/post_choose_for_you_cubit.dart';
import 'package:elite/feature/music/bloc/delete_playlist/delete_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_model.dart';
import 'package:elite/feature/music/bloc/get_playlist/get_all_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/post_playlist/post_playlist_cubit.dart';
import 'package:elite/feature/music/bloc/update_watched_count/update_watched_count_cubit.dart';
import 'package:elite/utils/widgets/audio_player_singleton.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<MusicModel> playlist;
  final int startIndex;
  const AudioPlayerScreen({super.key, required this.playlist, required this.startIndex});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late ConcatenatingAudioSource _playList;

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    globalAudioPlayer.positionStream,
    globalAudioPlayer.bufferedPositionStream,
    globalAudioPlayer.durationStream,
    (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),
  );

  @override
  void initState() {
    _initPlayer();
    globalAudioPlayer.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < widget.playlist.length) {
        final currentSong = widget.playlist[index];
        context.read<UpdateWatchedCountCubit>().updateWatched(
          count: currentSong.watchedCount ?? 1,
          musicId: currentSong.id ?? "",
        );
        context.read<PostChooseForYouCubit>().postChoose(musicId: currentSong.id ?? "");
      }
    });
    super.initState();
  }

  bool isShuffling = false;
  LoopMode loopMode = LoopMode.all;

  Future<void> _initPlayer() async {
    await globalAudioPlayer.stop();
    _playList = ConcatenatingAudioSource(
      children: widget.playlist.map((music) {
        return AudioSource.uri(
          Uri.parse(
            music.songFile?.contains('https') ?? false
                ? "${AppUrls.baseUrl}/${music.songFile}"
                : "https://${music.songFile}",
          ),
          tag: MediaItem(
            id: music.id ?? "",
            title: music.songTitle ?? "",
            artist: music.artist?.artistName ?? "",
            artUri: Uri.parse("${AppUrls.baseUrl}/${music.coverImg}"),
          ),
        );
      }).toList(),
    );
    if (globalAudioPlayer.sequenceState == null ||
        globalAudioPlayer.sequenceState!.sequence.length != widget.playlist.length) {
      await globalAudioPlayer.setLoopMode(loopMode);
      await globalAudioPlayer.setAudioSource(_playList, initialIndex: widget.startIndex);
      globalAudioPlayer.play();
    } else {
      await globalAudioPlayer.seek(Duration.zero, index: widget.startIndex);
      globalAudioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<SequenceState?>(
                stream: globalAudioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metaData = state!.currentSource!.tag as MediaItem;
                  return MediaMetaData(
                    artist: metaData.artist.toString(),
                    imageUrl: metaData.artUri.toString(),
                    title: metaData.title,
                  );
                },
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      StreamBuilder<SequenceState?>(
                        stream: globalAudioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          if (state?.sequence.isEmpty ?? true) {
                            return const SizedBox();
                          }
                          final metaData = state!.currentSource!.tag as MediaItem;
                          final songId = metaData.id;

                          log("message--------------- $songId");

                          return Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.playlist_add, color: AppColor.whiteColor),
                                onPressed: () async {
                                  context.read<GetAllPlaylistCubit>().getAllPlaylist();
                                  addPlayListPopUp(context, songId);
                                },
                              ),
                              const TextWidget(text: "Add to Playlist"),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: globalAudioPlayer.seek,
                    baseBarColor: const Color.fromARGB(255, 203, 227, 237),
                    thumbGlowColor: AppColor.blueColor,
                    progressBarColor: AppColor.blueColor,
                    thumbColor: AppColor.blueColor,
                    barHeight: 12,
                    timeLabelPadding: 9,
                    timeLabelTextStyle: const TextStyle(color: AppColor.whiteColor),
                  );
                },
              ),
              Controls(
                audioPlayer: globalAudioPlayer,
                isShuffling: isShuffling,
                onToggleShuffle: () async {
                  setState(() {
                    isShuffling = !isShuffling;
                  });
                  await globalAudioPlayer.setShuffleModeEnabled(isShuffling);
                },
                loopMode: loopMode,
                onToggleRepeat: () async {
                  setState(() {
                    if (loopMode == LoopMode.off) {
                      loopMode = LoopMode.all;
                    } else if (loopMode == LoopMode.all) {
                      loopMode = LoopMode.one;
                    } else {
                      loopMode = LoopMode.off;
                    }
                  });
                  await globalAudioPlayer.setLoopMode(loopMode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addPlayListPopUp(BuildContext context, String songId) async {
    final TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocListener<AddSongInPlaylistCubit, AddSongInPlaylistState>(
              listener: (context, state) {
                if (state is AddSongInPlaylistErrorState) {
                  AppToast.showError(context, "Error", "${state.error}.");
                }

                if (state is AddSongInPlaylistLoadedState) {
                  AppToast.showSuccess(context, "Success", "Added to WatchList.");
                  Navigator.pop(context);
                  context.read<GetAllPlaylistCubit>().getAllPlaylist();
                }
              },
              child: BlocListener<DeletePlaylistCubit, DeletePlaylistState>(
                listener: (context, state) {
                  if (state is DeletePlaylistErrorState) {
                    AppToast.showError(context, "Error", "${state.error}.");
                  }
                  if (state is DeletePlaylistLoadedState) {
                    AppToast.showSuccess(context, "Success", "Deleted Successfully.");
                    context.read<GetAllPlaylistCubit>().getAllPlaylist();
                  }
                },
                child: BlocListener<PostPlaylistCubit, PostPlaylistState>(
                  listener: (context, state) {
                    if (state is PostPlaylistErrorState) {
                      AppToast.showError(context, "Error", "${state.error}.");
                    }

                    if (state is PostPlaylistLoadedState) {
                      AppToast.showSuccess(context, "Success", "Created Successfully.");
                      nameController.clear();
                      context.read<GetAllPlaylistCubit>().getAllPlaylist();
                    }
                  },
                  child: BlocBuilder<GetAllPlaylistCubit, GetAllPlaylistState>(
                    builder: (context, state) {
                      if (state is GetAllPlaylistLoadingState) {
                        return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
                      } else if (state is GetAllPlaylistLoadedState) {
                        final playlists = state.model.playlists;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Add to Playlist",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close, color: AppColor.whiteColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (playlists?.isEmpty == true) ...[
                              TextFormField(
                                controller: nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Enter new playlist name",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white12,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    context.read<PostPlaylistCubit>().postPlaylist(name: nameController.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const TextWidget(text: "Create Playlist", color: AppColor.whiteColor),
                              ),
                            ] else ...[
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: playlists?.length,
                                  itemBuilder: (context, index) {
                                    final playlist = playlists?[index];
                                    return ListTile(
                                      title: Text(playlist?.name ?? "", style: const TextStyle(color: Colors.white)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add, color: Colors.white),
                                            onPressed: () {
                                              context.read<AddSongInPlaylistCubit>().addSongInPlaylist(
                                                playlistId: playlist?.id ?? "",
                                                songId: songId,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context.read<DeletePlaylistCubit>().deletePlaylist(
                                                musicId: playlist?.id ?? "",
                                              );
                                            },
                                            icon: const Icon(Icons.delete, color: AppColor.whiteColor),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "New playlist name",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white12,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    context.read<PostPlaylistCubit>().postPlaylist(name: nameController.text.trim());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const TextWidget(text: "Create & Add", color: AppColor.whiteColor),
                              ),
                            ],
                          ],
                        );
                      }

                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text("Something went wrong!", style: TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.isShuffling,
    required this.onToggleShuffle,
    required this.loopMode,
    required this.onToggleRepeat,
  });
  final AudioPlayer audioPlayer;
  final bool isShuffling;
  final VoidCallback onToggleShuffle;
  final LoopMode loopMode;
  final VoidCallback onToggleRepeat;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 34,
          onPressed: onToggleShuffle,
          icon: Icon(Icons.shuffle, color: isShuffling ? AppColor.blueColor : AppColor.whiteColor),
        ),
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          iconSize: 40,
          color: AppColor.whiteColor,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final prcessingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (!(playing ?? false)) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: AppColor.whiteColor,
                ),
                child: IconButton(
                  iconSize: 30,
                  color: AppColor.blackColor,
                  onPressed: audioPlayer.play,
                  icon: const Icon(Icons.play_arrow_outlined),
                ),
              );
            } else if (prcessingState != ProcessingState.completed) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: AppColor.whiteColor,
                ),
                child: IconButton(
                  iconSize: 30,
                  color: AppColor.blackColor,
                  onPressed: audioPlayer.pause,
                  icon: const Icon(Icons.pause_outlined),
                ),
              );
            }
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: AppColor.whiteColor,
              ),
              child: const Icon(Icons.play_arrow_outlined, size: 40, color: AppColor.blackColor),
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToNext,
          iconSize: 40,
          color: AppColor.whiteColor,
          icon: const Icon(Icons.skip_next_outlined),
        ),
        IconButton(
          iconSize: 34,
          onPressed: onToggleRepeat,
          icon: Icon(
            loopMode == LoopMode.off
                ? Icons.repeat
                : loopMode == LoopMode.all
                ? Icons.repeat
                : Icons.repeat_one,
            color: loopMode == LoopMode.off ? AppColor.whiteColor : AppColor.blueColor,
          ),
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class MediaMetaData extends StatelessWidget {
  const MediaMetaData({super.key, required this.artist, required this.imageUrl, required this.title});
  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, progress) {
              return const Center(child: CustomCircularProgressIndicator());
            },
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextWidget(text: title, fontSize: 19, textAlign: TextAlign.center, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextWidget(text: artist),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MusicVisualizer extends StatefulWidget {
  final bool isPlaying;
  const MusicVisualizer({super.key, required this.isPlaying});

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);

    _barAnimations = List.generate(
      5,
      (index) => Tween<double>(
        begin: 10.0,
        end: 50.0 + index * 5,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) {
      _controller.stop();
    } else {
      _controller.repeat(reverse: true);
    }

    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _barAnimations.map((animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                width: 8,
                height: animation.value,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
