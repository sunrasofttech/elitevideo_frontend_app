import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/downloads/ui/download.dart';
import 'package:elite/feature/splash_screen/splash_screen.dart';
import 'package:elite/utils/utility.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> with Utility {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Hive.initFlutter();
    //   Hive.registerAdapter(MovieAdapter());
    //   Hive.registerAdapter(GenreAdapter());
    //   Hive.registerAdapter(CastCrewAdapter());
    //   Hive.registerAdapter(RatingAdapter());
    //   Hive.registerAdapter(ShortFilmAdapter());
    //   Hive.registerAdapter(EpisodeAdapter());
    //   await Hive.openBox<Movie>('movies');
    //   await Hive.openBox<ShortFilm>('shortFilm');
    //   await Hive.openBox<Episode>('episode');
    // });
  }

  Future<void> _handleRetry() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      AppToast.showError(context, "Network", "No internet connection available.");
      return;
    }

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      AppToast.showSuccess(context, "Network", "You're on mobile data");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sb20h(),
            Lottie.asset(AppImages.noInternetLottie, height: MediaQuery.of(context).size.height * 0.4),
            sb20h(),
            const TextWidget(
              text: 'No Internet Connection',
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            const TextWidget(
              text: 'Please check your internet and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Go to Downloads',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DownloadScreen(
                              // currentIndex: 3,
                              //   key: dashboardGlobalKey,
                              ),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
                sb10w(),
                Expanded(
                  child: GradientButton(
                    text: 'Retry',
                    onTap: _handleRetry,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
