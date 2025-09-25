import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomLocalPlayer extends StatefulWidget {
  final String audioUrl; // Path to local file

  const CustomLocalPlayer({super.key, required this.audioUrl});

  @override
  CustomLocalPlayerState createState() => CustomLocalPlayerState();
}

class CustomLocalPlayerState extends State<CustomLocalPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(
      File(widget.audioUrl),
    )..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: true,
      allowMuting: true,
      allowFullScreen: true,
      aspectRatio: 16 / 9,
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null && _videoPlayerController!.value.isInitialized
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator());
  }
}
