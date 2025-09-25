import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/search/bloc/get_all_category/get_all_category_cubit.dart';
import 'package:elite/feature/search/ui/get_all_movie_by_id.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/textwidget.dart';

import '../../../utils/widgets/customcircularprogressbar.dart';

class MovieCategoryScreen extends StatefulWidget {
  const MovieCategoryScreen({super.key});

  @override
  State<MovieCategoryScreen> createState() => _MovieCategoryScreenState();
}

class _MovieCategoryScreenState extends State<MovieCategoryScreen> {
  @override
  void initState() {
    context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.whiteColor,
        ),
        title: const TextWidget(
          text: "Movie Category",
          fontSize: 15,
        ),
      ),
      body: BlocBuilder<GetAllMovieCategoryCubit, GetAllCategoryState>(
        builder: (context, state) {
          if (state is GetAllCategoryErrorState) {
            return const CustomErrorWidget();
          }
          if (state is GetAllCategoryLoadingState) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
          if (state is GetAllCategoryLoadedState) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: state.model.categories?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9, // adjust card size
                ),
                itemBuilder: (context, index) {
                  var data = state.model.categories?[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetAllMovieByIdScreen(
                            categoryId: data?.id ?? "",
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: CustomCachedCard(
                                height: double.infinity,
                                width: double.infinity,
                                imageUrl: data?.img ?? "",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextWidget(
                              text: data?.name ?? "",
                              fontSize: 14,
                              color: AppColor.blackColor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
