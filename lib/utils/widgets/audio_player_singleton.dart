import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  late final AudioPlayer audioPlayer;

  factory AudioPlayerManager() {
    return _instance;
  }

  AudioPlayerManager._internal() {
    audioPlayer = AudioPlayer();
  }
}

final globalAudioPlayer = AudioPlayerManager().audioPlayer;