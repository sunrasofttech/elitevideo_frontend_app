import 'package:hive/hive.dart';
import 'package:elite/model/episode.dart';
import 'package:elite/model/short_film.dart';
import '../../model/movie.dart';

class HiveDb {
  //Movie
  static Future<void> saveMovieVideo(Movie video) async {
    final box = Hive.box<Movie>('movies');
    await box.add(video);
  }

  static List<Movie> getAllVideos() {
    final box = Hive.box<Movie>('movies');
    return box.values.toList();
  }

  static Future<void> updateVideo(int index, Movie updatedVideo) async {
    final box = Hive.box<Movie>('movies');
    if (index < box.length) {
      await box.putAt(index, updatedVideo);
    }
  }

  static Future<void> deleteVideo(int index) async {
    final box = Hive.box<Movie>('movies');
    await box.deleteAt(index);
  }

  static bool isMovieDownloaded(String id) {
    final box = Hive.box<Movie>('movies');
    return box.values.any((movie) => movie.id == id);
  }

  //Short Film Video
  static Future<void> saveShortFilVideo(ShortFilm video) async {
    final box = Hive.box<ShortFilm>('shortFilm');
    await box.add(video);
  }

  static List<ShortFilm> getAllShortFilmVideos() {
    final box = Hive.box<ShortFilm>('shortFilm');
    return box.values.toList();
  }

  static Future<void> updateShortFilmVideo(int index, ShortFilm updatedVideo) async {
    final box = Hive.box<ShortFilm>('shortFilm');
    if (index < box.length) {
      await box.putAt(index, updatedVideo);
    }
  }

  static Future<void> deleteShortFilmVideo(int index) async {
    final box = Hive.box<ShortFilm>('shortFilm');
    await box.deleteAt(index);
  }

  static bool isShortFilmDownloaded(String id) {
    final box = Hive.box<ShortFilm>('shortFilm');
    return box.values.any((movie) => movie.id == id);
  }

  //Episode
  static Future<void> saveEpisodeVideo(Episode video) async {
    final box = Hive.box<Episode>('episode');
    await box.add(video);
  }

  static List<Episode> getAllEpisodeVideos() {
    final box = Hive.box<Episode>('episode');
    return box.values.toList();
  }

  static Future<void> updateEpisodeVideo(int index, Episode updatedVideo) async {
    final box = Hive.box<Episode>('episode');
    if (index < box.length) {
      await box.putAt(index, updatedVideo);
    }
  }

  static Future<void> deleteEpisodeVideo(int index) async {
    final box = Hive.box<Episode>('episode');
    await box.deleteAt(index);
  }

  static bool isEpisodeDownloaded(String id) {
    final box = Hive.box<Episode>('episode');
    return box.values.any((movie) => movie.id == id);
  }
}
