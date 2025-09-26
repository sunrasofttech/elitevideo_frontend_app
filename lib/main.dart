import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:elite/constant/app_string.dart';
import 'package:elite/feature/dashboard/dashboard.dart';
import 'package:elite/feature/music/ui/music_screen.dart';
import 'package:elite/feature/search/ui/search_screen.dart';
import 'package:elite/feature/splash_screen/splash_screen.dart';
import 'package:elite/repo.dart';
import 'package:elite/utils/bloc_provider/providers.dart';
import 'package:elite/utils/theme.dart';

String? userId;
String? token;
bool isUserSubscribed = false;
bool showAds = true;
String? appVersion;

final GlobalKey<MusicScreenState> musicScreenState = GlobalKey<MusicScreenState>();
final GlobalKey<DashboardScreenState> dashboardGlobalKey = GlobalKey<DashboardScreenState>();
final GlobalKey<SearchScreenState> searchScreenState = GlobalKey<SearchScreenState>();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await JustAudioBackground.init(
      androidNotificationChannelId: "com.ryanheise.bg_demo.channel.audio",
      androidNotificationChannelName: "Audio playback",
      androidNotificationOngoing: true,
      notificationColor: Colors.red,
    );
  } catch (e) {
    log("$e");
  }
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('hi', 'US'), Locale('mr', 'IN')],
      path: 'asset/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

Repository repository = Repository();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        title: AppString.appName,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const SplashScreen(),
      ),
    );
  }
}



//  private val CHANNEL = "orientation_helper"
//     private val EVENT_CHANNEL = "orientation_helper/stream"

//     private var observer: ContentObserver? = null

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         // One-time check (like before)
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             if (call.method == "isAutoRotateOn") {
//                 val isAutoRotate = getAutoRotate()
//                 result.success(isAutoRotate)
//             } else {
//                 result.notImplemented()
//             }
//         }

//        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
//     object : EventChannel.StreamHandler {
//         override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//             observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
//                 override fun onChange(selfChange: Boolean, uri: Uri?) {
//                     val isAutoRotate = getAutoRotate()
//                     events?.success(isAutoRotate)
//                 }
//             }
//             contentResolver.registerContentObserver(
//                 Settings.System.getUriFor(Settings.System.ACCELEROMETER_ROTATION),
//                 false,
//                 observer!!
//             )

//             events?.success(getAutoRotate())
//         }

//         override fun onCancel(arguments: Any?) {
//             observer?.let { contentResolver.unregisterContentObserver(it) }
//         }
//     }
// )
//     }

//     private fun getAutoRotate(): Boolean {
//         return try {
//             Settings.System.getInt(contentResolver, Settings.System.ACCELEROMETER_ROTATION, 0) == 1
//         } catch (e: Exception) {
//             false
//         }
//     }