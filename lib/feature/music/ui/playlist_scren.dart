import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/music/bloc/get_data_by_artist_and_language/get_data_by_artist_and_language_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_audio_player.dart';
import 'package:elite/utils/widgets/custom_back_button.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key, this.artistId, this.languageId, required this.name, required this.coverImg});
  final String? artistId;
  final String name;
  final String coverImg;
  final String? languageId;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with Utility {
  int listener = 0;
  @override
  void initState() {
    context.read<GetDataByArtistAndLanguageCubit>().getAllMusic(
      artistId: widget.artistId,
      languageId: widget.languageId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomCachedCard(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 1,
                    imageUrl: "${AppUrls.baseUrl}/${widget.coverImg}",
                  ),
                  const Positioned(top: 10, left: 10, child: CustomBackButton()),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 9,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: widget.name,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            textDecoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sb15h(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BlocConsumer<GetDataByArtistAndLanguageCubit, GetDataByArtistAndLanguageState>(
                  listener: (context, state) {
                    if (state is GetDataByArtistAndLanguageLoadedState) {
                      listener =
                          state.model.data
                              ?.map((e) => int.tryParse(e.watchedCount?.toString() ?? '') ?? 0)
                              .fold<int>(0, (int sum, int count) => sum + count) ??
                          1;
                    }
                  },
                  builder: (context, state) {
                    if (state is GetDataByArtistAndLanguageLoadingState) {
                      return const Center(child: CustomCircularProgressIndicator());
                    }
                    if (state is GetDataByArtistAndLanguageLoadedState) {
                      return state.model.data?.isEmpty ?? true
                          ? const Center(child: TextWidget(text: "No Playlist Available"))
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      text: "$listener ${listener == 1 ? 'person' : 'people'} listened",
                                      color: AppColor.navColor,
                                      fontSize: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AudioPlayerScreen(playlist: state.model.data ?? [], startIndex: 0),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          color: Color.fromRGBO(77, 197, 253, 1),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow_outlined,
                                          color: AppColor.whiteColor,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                sb20h(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var data = state.model.data?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AudioPlayerScreen(playlist: state.model.data ?? [], startIndex: index),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 70,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: TextWidget(
                                                text: "${index + 1}.",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            sb10w(),
                                            CustomCachedCard(
                                              height: 60,
                                              width: 60,
                                              imageUrl: "${AppUrls.baseUrl}/${data?.coverImg ?? ""}",
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextWidget(text: data?.songTitle, fontWeight: FontWeight.w700),
                                                  TextWidget(
                                                    text: data?.artist?.artistName ?? "",
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.navColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: state.model.data?.length,
                                ),
                              ],
                            );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
