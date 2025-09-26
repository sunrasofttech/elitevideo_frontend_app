import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/downloads/ui/local_player.dart';
import 'package:elite/main.dart';
import 'package:elite/model/episode.dart';
import 'package:elite/model/movie.dart';
import 'package:elite/utils/storage/hive_db.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../model/short_film.dart';
import '../../auth/bloc/get_profile/get_profile_cubit.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> with Utility {
  late final Box<Movie> movieBox;
  late final Box<ShortFilm> shortFilmBox;
  late final Box<Episode> episodeBox;

  @override
  void initState() {
    super.initState();
    movieBox = Hive.box<Movie>('movies');
    shortFilmBox = Hive.box<ShortFilm>('shortFilm');
    episodeBox = Hive.box<Episode>('episode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Downloads'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<GetProfileCubit, GetProfileState>(
            builder: (context, state) {
              if (state is GetProfileLoadedState) {
                const assetProfile = "asset/test/default.png";
                String image = "${AppUrls.baseUrl}/${state.model.user?.profilePicture}";
                return GestureDetector(
                  onTap: () {
                    log("message = = = = ${dashboardGlobalKey.currentState}");
                    dashboardGlobalKey.currentState?.switchTab(5);
                  },
                  child: Container(
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
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: state.model.user?.profilePicture == null
                            ? Image.asset(
                                assetProfile,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: image,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                                errorWidget: (context, url, error) => Image.asset(
                                  assetProfile,
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          sb10w(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          children: [
            sb10h(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: movieBox.listenable(),
                builder: (context, Box<Movie> mBox, _) {
                  return ValueListenableBuilder(
                    valueListenable: shortFilmBox.listenable(),
                    builder: (context, Box<ShortFilm> sBox, _) {
                      return ValueListenableBuilder(
                        valueListenable: episodeBox.listenable(),
                        builder: (context, Box<Episode> eBox, _) {
                          final allItems = [
                            ...mBox.keys.map((key) => {'type': 'movie', 'key': key, 'data': mBox.get(key)}),
                            ...sBox.keys.map((key) => {'type': 'shortFilm', 'key': key, 'data': sBox.get(key)}),
                            ...eBox.keys.map((key) => {'type': 'episode', 'key': key, 'data': eBox.get(key)}),
                          ];

                          if (allItems.isEmpty) {
                            return const Center(
                              child: TextWidget(text: "No Downloads Available"),
                            );
                          }

                          return ListView.builder(
                            itemCount: allItems.length,
                            itemBuilder: (context, index) {
                              final item = allItems[index];
                              final type = item['type'];
                              final data = item['data'];
                              final key = item['key'];

                              switch (type) {
                                case 'movie':
                                  return buildMovieTile(data as Movie, key);
                                case 'shortFilm':
                                  return buildShortFilmTile(data as ShortFilm, key);
                                case 'episode':
                                  return buildEpisodeTile(data as Episode, key);
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMovieTile(Movie movie, int index) => Slidable(
        key: const ValueKey("deleted"),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HiveDb.deleteVideo(index);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocalPlayer(
                  description: movie.description ?? "",
                  localVideoPath: movie.localVideoPath ?? "",
                  movieName: movie.movieName ?? "",
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(movie.localImagePath ?? ""),
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 70,
                        width: 100,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const TextWidget(text: "No Img"),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: movie.movieName ?? "",
                      ),
                      const SizedBox(height: 4),
                      TextWidget(
                        text: movie.movieTime ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      // Uncomment if needed
                      // TextWidget(text: movie.releasedDate ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildShortFilmTile(ShortFilm film, int index) => Slidable(
        key: const ValueKey("deleted"),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HiveDb.deleteShortFilmVideo(index);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocalPlayer(
                    description: film.description ?? "",
                    localVideoPath: film.localVideoPath ?? "",
                    movieName: film.shortFilmTitle ?? "",
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(film.localImagePath ?? ""),
                      height: 100,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 70,
                          width: 100,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const TextWidget(text: "No Img"),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: film.shortFilmTitle ?? "",
                        ),
                        const SizedBox(height: 6),
                        TextWidget(
                          text: film.movieTime ?? "",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );

  Widget buildEpisodeTile(Episode episode, int index) => Slidable(
        key: const ValueKey("deleted"),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HiveDb.deleteEpisodeVideo(index);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocalPlayer(
                  description: "",
                  localVideoPath: episode.localVideoPath ?? "",
                  movieName: episode.episodeName ?? "",
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(episode.localImagePath ?? ""),
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 120,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const TextWidget(text: "No Img"),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: episode.episodeName ?? "",
                      ),
                      const SizedBox(height: 6),
                      if (episode.releasedDate != null)
                        TextWidget(
                          text: episode.releasedDate!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
