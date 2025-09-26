import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:elite/utils/widgets/audio_player_singleton.dart';
import 'package:elite/utils/widgets/custom_audio_player.dart';
import 'package:rxdart/rxdart.dart';

import '../../feature/music/bloc/get_all_music/get_all_music_model.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        globalAudioPlayer.positionStream,
        globalAudioPlayer.bufferedPositionStream,
        globalAudioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: globalAudioPlayer.playerStateStream,
      builder: (context, playerSnapshot) {
        final playerState = playerSnapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState;
        if (processingState == ProcessingState.idle) {
          return const SizedBox();
        }
        return StreamBuilder<SequenceState?>(
          stream: globalAudioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) return const SizedBox();

            final metaData = state!.currentSource!.tag as MediaItem;

            return GestureDetector(
              onTap: () {
                final sequence = state.sequence;
                log("------------------------>$sequence");
                final playlist = sequence.map((s) {
                  final item = s.tag as MediaItem;
                  return MusicModel(
                    id: item.id,
                    songTitle: item.title,
                    artist: Artist(artistName: item.artist),
                    coverImg: item.artUri.toString(),
                  );
                }).toList();
                log("------------------------>$playlist");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AudioPlayerScreen(
                      playlist: playlist,
                      startIndex: state.currentIndex,
                    ),
                  ),
                );
              },
              child: Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        metaData.artUri.toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metaData.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            metaData.artist ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              double progress = 0.0;
                              if (positionData != null && positionData.duration.inMilliseconds > 0) {
                                progress = positionData.position.inMilliseconds / positionData.duration.inMilliseconds;
                              }
                              return LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation(Colors.amber),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 32,
                      onPressed: () async {
                        if (globalAudioPlayer.hasPrevious) {
                          await globalAudioPlayer.seekToPrevious();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: Colors.white,
                      ),
                      iconSize: 36,
                      onPressed: () {
                        if (playing) {
                          globalAudioPlayer.pause();
                        } else {
                          globalAudioPlayer.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 32,
                      onPressed: () async {
                        if (globalAudioPlayer.hasNext) {
                          await globalAudioPlayer.seekToNext();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () async {
                        await globalAudioPlayer.stop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
