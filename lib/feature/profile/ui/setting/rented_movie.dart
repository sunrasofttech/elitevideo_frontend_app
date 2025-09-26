import 'package:easy_localization/easy_localization.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/feature/home_screen/ui/movie/movie_detail.dart';
import 'package:elite/feature/home_screen/ui/short_film/short_film_detail.dart';
import 'package:elite/feature/home_screen/ui/web_series/web_series_details.dart';
import 'package:elite/feature/profile/bloc/get_rental_by_userid/get_rental_by_userid_cubit.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_auth_design.dart';
import 'package:elite/utils/widgets/custom_empty.dart';
import 'package:elite/utils/widgets/custom_error.dart';
import 'package:elite/utils/widgets/skeloton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class RentedMovie extends StatefulWidget {
  const RentedMovie({super.key});

  @override
  State<RentedMovie> createState() => _RentedMovieState();
}

class _RentedMovieState extends State<RentedMovie> with SingleTickerProviderStateMixin, Utility {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAuthDesignScreen(
        center: false,
        data: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.backgroundGreyColor,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextWidget(
                    text: "Rented Movie".tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppColor.whiteColor,
                unselectedLabelColor: AppColor.whiteColor,
                indicatorColor: Theme.of(context).primaryColor,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Movie'),
                  Tab(text: 'Series/Tvshow'),
                  Tab(text: 'Shortfilm'),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    MovieTab(),
                    SeriesTab(),
                    ShortFilmTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieTab extends StatefulWidget {
  const MovieTab({super.key});

  @override
  State<MovieTab> createState() => _MovieTabState();
}

class _MovieTabState extends State<MovieTab> with Utility {
  @override
  void initState() {
    context.read<GetRentalByUseridCubit>().getSRentalByUserId(type: "movie");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRentalByUseridCubit, GetRentalByUseridState>(
      builder: (context, state) {
        if (state is GetRentalByUseridLoadingState) {
          return const SkelotonWidget(loading: true);
        }

        if (state is GetRentalByUseridErrorState) {
          return const CustomErrorWidget();
        }

        if (state is GetRentalByUseridLoadedState) {
          return state.model.data?.rentals?.isEmpty ?? true
              ? const CustomEmptyWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.model.data?.rentals?.length,
                  itemBuilder: (context, index) {
                    var movie = state.model.data?.rentals?[index].movie;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              id: movie?.id ?? "",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage("${AppUrls.baseUrl}/${movie?.posterImg}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          sb5h(),
                          SizedBox(
                            width: 200,
                            child: TextWidget(
                              text: movie?.movieName ?? "",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              maxlines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }
        return Container();
      },
    );
  }
}

class SeriesTab extends StatefulWidget {
  const SeriesTab({super.key});

  @override
  State<SeriesTab> createState() => _SeriesTabState();
}

class _SeriesTabState extends State<SeriesTab> with Utility {
  @override
  void initState() {
    context.read<GetRentalByUseridCubit>().getSRentalByUserId(type: "series");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRentalByUseridCubit, GetRentalByUseridState>(
      builder: (context, state) {
        if (state is GetRentalByUseridLoadingState) {
          return const SkelotonWidget(loading: true);
        }

        if (state is GetRentalByUseridErrorState) {
          return const CustomErrorWidget();
        }

        if (state is GetRentalByUseridLoadedState) {
          return state.model.data?.rentals?.isEmpty ?? true
              ? const CustomEmptyWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.model.data?.rentals?.length,
                  itemBuilder: (context, index) {
                    var data = state.model.data?.rentals?[index].series;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebSeriesDetails(
                              type: ContentType.series,
                              isFromRental: true,
                              id: data?.id ?? "",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage("${AppUrls.baseUrl}/${data?.posterImg}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          sb5h(),
                          SizedBox(
                            width: 200,
                            child: TextWidget(
                              text: data?.seriesName ?? "",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              maxlines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }
        return Container();
      },
    );
  }
}

class ShortFilmTab extends StatefulWidget {
  const ShortFilmTab({super.key});

  @override
  State<ShortFilmTab> createState() => _ShortFilmTabState();
}

class _ShortFilmTabState extends State<ShortFilmTab> with Utility {
  @override
  void initState() {
    context.read<GetRentalByUseridCubit>().getSRentalByUserId(type: "shortfilm");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRentalByUseridCubit, GetRentalByUseridState>(
      builder: (context, state) {
        if (state is GetRentalByUseridLoadingState) {
          return const SkelotonWidget(loading: true);
        }

        if (state is GetRentalByUseridErrorState) {
          return const CustomErrorWidget();
        }

        if (state is GetRentalByUseridLoadedState) {
          return state.model.data?.rentals?.isEmpty ?? true
              ? const CustomEmptyWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.model.data?.rentals?.length,
                  itemBuilder: (context, index) {
                    var data = state.model.data?.rentals?[index].shortfilm;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShortFilmDetailScreen(
                              id: data?.id ?? "",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage("${AppUrls.baseUrl}/${data?.posterImg}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          sb5h(),
                          SizedBox(
                            width: 200,
                            child: TextWidget(
                              text: data?.shortFilmTitle ?? "",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              maxlines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }
        return Container();
      },
    );
  }
}
