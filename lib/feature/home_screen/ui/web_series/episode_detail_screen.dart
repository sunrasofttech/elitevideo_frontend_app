import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/home_screen/bloc/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite/feature/home_screen/ui/web_series/video_descrption.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class EpisodeDetailScreen extends StatefulWidget {
  const EpisodeDetailScreen({super.key, required this.seasonId});
  final String seasonId;

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> with Utility {
  @override
  void initState() {
    context.read<GetAllEpisodeCubit>().getAllEpisode(seasonId: widget.seasonId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        automaticallyImplyLeading: true,
        title: const TextWidget(
          text: "Episode",
        ),
      ),
      body: BlocBuilder<GetAllEpisodeCubit, GetAllEpisodeState>(
        builder: (context, state) {
          if (state is GetAllEpisodeLoadingState) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
          if (state is GetAllEpisodeLoadedState) {
            return state.model.data?.isEmpty ?? true
                ? const Center(
                    child: TextWidget(
                      text: "No Episode Uploaded",
                      fontSize: 15,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var episode = state.model.data?[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            if ((episode?.videoLink == null || episode!.videoLink!.isEmpty) &&
                                (episode?.video == null || episode!.video!.isEmpty)) {
                              AppToast.showError(context, "No Episode Uploaded","");
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EpisodeDescScreen(
                                  episode: episode,
                                ),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.all(16),
                          leading: CustomCachedCard(
                            height: 140,
                            width: 100,
                            imageUrl: "${episode?.coverImg}",
                          ),
                          title: TextWidget(
                            text: "Episode ${episode?.episodeNo ?? 'N/A'}: ${episode?.episodeName ?? 'N/A'}",
                            fontSize: 18,
                            maxlines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: TextWidget(
                            text: "Released: ${_formatDate(episode?.releasedDate.toString())}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            iconSize: 35,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EpisodeDescScreen(
                                    episode: episode,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.model.data?.length ?? 0,
                  );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return 'Invalid date';
    }
  }
}
