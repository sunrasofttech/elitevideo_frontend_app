import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/home_screen/bloc/get_movie_by_category_id/get_movie_by_category_id_cubit.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custom_empty.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class GetAllMovieByIdScreen extends StatefulWidget {
  const GetAllMovieByIdScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<GetAllMovieByIdScreen> createState() => _GetAllMovieByIdScreenState();
}

class _GetAllMovieByIdScreenState extends State<GetAllMovieByIdScreen> {
  @override
  void initState() {
    context.read<GetMovieByCategoryIdCubit>().getAllMovie(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: AppColor.whiteColor,
          ),
        ),
        body: BlocBuilder<GetMovieByCategoryIdCubit, GetMovieByCategoryIdState>(
          builder: (context, state) {
            if (state is GetMovieByCategoryIdLoadingState) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            if (state is GetMovieByCategoryIdErrorState) {
              return const CustomErrorWidget();
            }

            if (state is GetMovieByCategoryIdLoadedState) {
              final movies = state.model.data?.movies ?? [];

              return movies.isEmpty
                  ? const Center(
                      child: CustomEmptyWidget(),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  id: movie.id ?? "",
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomCachedCard(
                                    imageUrl:"${AppUrls.baseUrl}/${movie.coverImg ?? ""}",
                                    width: double.infinity,
                                    height: 100,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextWidget(
                                text: movie.movieName ?? "",
                                maxlines: 1,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
