import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite/feature/auth/bloc/get_profile/get_profile_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_highlighted/highlighted_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_series/get_all_series_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_continue_watching/get_continue_watching_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_highlighted_content/get_highlighted_content_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite/feature/home_screen/bloc/get_most_viewed/get_most_viewed_cubit.dart';
import 'package:elite/feature/music/bloc/get_all_music/get_all_music_cubit.dart';
import 'package:elite/feature/profile/bloc/get_setting/get_setting_cubit.dart';
import 'package:elite/feature/profile/bloc/get_subscription/get_subscription_cubit.dart';
import 'package:elite/feature/splash_screen/onboarding_screen.dart';
import 'package:elite/firebase_options.dart';
import 'package:elite/main.dart';
import 'package:elite/model/castcrew.dart';
import 'package:elite/model/episode.dart';
import 'package:elite/model/genre.dart';
import 'package:elite/model/movie.dart';
import 'package:elite/model/rating.dart';
import 'package:elite/model/short_film.dart';
import 'package:elite/utils/app_init.dart';
import 'package:elite/utils/storage/storage.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custom_no_network.dart';

import '../dashboard/dashboard.dart';
import '../music/bloc/get_all_music_category/get_all_music_category_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with Utility, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      initHive();
      final hasInternet = await checkInternetConnection();
      if (!hasInternet) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoInternetScreen(
                onRetry: () async {
                  try {
                    await LocalStorageUtils.init();
                    userId = LocalStorageUtils.userId;
                    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                      await Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      );
                    } else if (kIsWeb) {
                      // await Firebase.initializeApp(
                      //   options: DefaultFirebaseOptions.web,
                      // );
                    }
                    await AppInit.init();
                    initHive();
                    context.read<HighlightedMovieCubit>().getHighLightedMovie();
                    context.read<GetAllMovieCubit>().getAllMovie();
                    context.read<GetMostViewedCubit>().getMostViewedMovie();
                    context.read<GetProfileCubit>().getProfile();
                    context.read<GetHighlightedContentCubit>().getHighlightedContent();
                    context.read<GetSettingCubit>().getSetting();
                    context.read<GetAllMusicCategoryCubit>().getAllMusic();
                    context.read<GetAllMusicCubit>().getAllMusic();
                    context.read<GetLiveTvCubit>().getAllLiveCategory();
                    context.read<GetContinueWatchingCubit>().getContinueWatching();
                    context.read<GetAllSeriesCubit>().getAllSeries();
                    context.read<GetAllShortFilmCubit>().getAllShortFilm();
                    context.read<GetAllTvShowSeriesCubit>().getAllSeries();
                    context.read<GetSubscriptionCubit>().getAllSub();
                  } catch (e) {
                    log("Retry : $e");
                  }
                },
              ),
            ),
          );
        }
        return;
      }
      try {
        initHive();
        await LocalStorageUtils.init();
        userId = LocalStorageUtils.userId;
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } else if (kIsWeb) {
          // await Firebase.initializeApp(
          //   options: DefaultFirebaseOptions.web,
          // );
        }
        await AppInit.init();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => userId != null
                  ? DashboardScreen(
                      key: dashboardGlobalKey,
                    )
                  : const OnBoardingScreen(),
            ),
          );
        }
      } catch (e) {}
    } catch (e, stk) {
      debugPrint("Init error: $e $stk");
    }
  }

  bool _hiveInitialized = false;

  initHive() async {
    if (_hiveInitialized) return;
    if (!_hiveInitialized) {
      await Hive.initFlutter();
      Hive.registerAdapter(MovieAdapter());
      Hive.registerAdapter(GenreAdapter());
      Hive.registerAdapter(CastCrewAdapter());
      Hive.registerAdapter(RatingAdapter());
      Hive.registerAdapter(ShortFilmAdapter());
      Hive.registerAdapter(EpisodeAdapter());
      await Hive.openBox<Movie>('movies');
      await Hive.openBox<ShortFilm>('shortFilm');
      await Hive.openBox<Episode>('episode');
      _hiveInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              "asset/image/logo.png",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
