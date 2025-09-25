import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/feature/search/bloc/get_live_category/get_live_category_cubit.dart';
import 'package:elite/feature/search/ui/get_all_live_by_id.dart';
import 'package:elite/utils/widgets/custom_cached.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class LiveCategoryScreen extends StatefulWidget {
  const LiveCategoryScreen({super.key});

  @override
  State<LiveCategoryScreen> createState() => _LiveCategoryScreenState();
}

class _LiveCategoryScreenState extends State<LiveCategoryScreen> {
  @override
  void initState() {
    context.read<GetLiveCategoryCubit>().getAllLiveCategory();
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
          text: "Live Category",
          fontSize: 15,
        ),
      ),
      body: BlocBuilder<GetLiveCategoryCubit, GetLiveCategoryState>(
        builder: (context, state) {
          if (state is GetLiveCategoryErrorState) {
            return const CustomErrorWidget();
          }
          if (state is GetLiveCategoryLoadingState) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
          if (state is GetLiveCategoryLoadedState) {
            var categories = state.model.data?.categories ?? [];

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var data = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetAllLiveByIdScreen(categoryId: data.id ?? ""),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomCachedCard(
                            height: double.infinity,
                            width: double.infinity,
                            imageUrl: data.coverImg ?? "",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidget(
                            text: data.name,
                            fontSize: 14,
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
