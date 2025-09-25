import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_audio_player.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../bloc/get_all_music/get_all_music_model.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key, required this.data, required this.color, required this.text});
  final List<MusicModel>? data;
  final List<Color> color;
  final String text;

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> with Utility {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: widget.color),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: widget.text,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: CustomBackButton(),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              playlist: widget.data ?? [],
                              startIndex: 0,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColor.blackColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColor.whiteColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = widget.data?[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioPlayerScreen(
                            playlist: widget.data ?? [],
                            startIndex: index,
                          ),
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
                            imageUrl: data?.coverImg ?? "",
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: data?.songTitle,
                                  fontWeight: FontWeight.w700,
                                ),
                                TextWidget(
                                  text: data?.artist?.artistName ?? "",
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.navColor,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioPlayerScreen(
                                    playlist: widget.data ?? [],
                                    startIndex: index,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: widget.data?.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
