import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:elite/constant/app_colors.dart';
import 'package:elite/constant/app_image.dart';
import 'package:elite/constant/app_toast.dart';
import 'package:elite/feature/auth/ui/login_screen.dart';
import 'package:elite/feature/profile/bloc/logout/logout_cubit.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/storage/storage.dart';
import 'package:elite/utils/widgets/custombutton.dart';
import 'package:elite/utils/widgets/textwidget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

mixin Utility {
  Widget sb5h() => const SizedBox(height: 5);
  Widget sb10h() => const SizedBox(height: 10);
  Widget sb15h() => const SizedBox(height: 15);
  Widget sb20h() => const SizedBox(height: 20);
  Widget sb30h() => const SizedBox(height: 30);
  Widget sb40h() => const SizedBox(height: 40);

  Widget sb5w() => const SizedBox(width: 5);
  Widget sb10w() => const SizedBox(width: 10);
  Widget sb20w() => const SizedBox(width: 20);
  Widget sb30w() => const SizedBox(width: 30);
  Widget sb40w() => const SizedBox(width: 40);

  Widget sbHeight(double height, double width) => SizedBox(height: height, width: width);

  String getLanguageName(Locale locale) {
    final Map<String, Locale> languageMap = {
      'English': const Locale('en', 'US'),
      'Hindi': const Locale('hi', 'US'),
      'Marathi': const Locale('mr', 'IN'),
    };

    return languageMap.entries
        .firstWhere((entry) => entry.value == locale, orElse: () => const MapEntry('English', Locale('en', 'US')))
        .key;
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout".tr()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppImages.logoutLottie,
                  height: 150,
                  width: 150,
                ),
                sb15h(),
                TextWidget(
                  text: "Are you sure you want to logout?".tr(),
                  color: AppColor.blackColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel".tr()),
            ),
            BlocListener<LogoutCubit, LogoutState>(
              listener: (context, state) {
                if (state is LogoutErrorState) {
                  AppToast.showError(context, "Logout", state.error);
                  return;
                }
                if (state is LogoutLoadedState) {
                  LocalStorageUtils.clear().then((onValue) => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        ),
                      });
                }
              },
              child: TextButton(
                onPressed: () async {
                  final deviceInfoPlugin = DeviceInfoPlugin();
                  String deviceId = "";

                  if (kIsWeb) {
                    final webInfo = await deviceInfoPlugin.webBrowserInfo;
                    deviceId = webInfo.vendor ?? "web_device";
                  } else if (Platform.isAndroid) {
                    final androidInfo = await deviceInfoPlugin.androidInfo;
                    deviceId = androidInfo.id;
                  } else if (Platform.isIOS) {
                    final iosInfo = await deviceInfoPlugin.iosInfo;
                    deviceId = iosInfo.identifierForVendor ?? "";
                  }

                  context.read<LogoutCubit>().logout(
                        userId ?? "",
                        deviceId,
                      );
                },
                child: Text("Logout".tr()),
              ),
            )
          ],
        );
      },
    );
  }

  bool isNewVersionAvailable(String currentVersion, String latestVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (currentParts.length <= i || currentParts[i] < latestParts[i]) {
        return true;
      } else if (currentParts[i] > latestParts[i]) {
        return false;
      }
    }
    return false;
  }

  Future<void> checkVersion(
    String latestVersion,
    String playStoreUrl,
    BuildContext context,
    String requiredVersion,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (isNewVersionAvailable(currentVersion, latestVersion)) {
      final isForceUpdate = isNewVersionAvailable(currentVersion, requiredVersion);
      promptUpdate(context, playStoreUrl, isForceUpdate);
    }
  }

  bool isUpdatePopUpShown = false;

  void promptUpdate(BuildContext context, String url, bool isForceUpdate) {
    if (isUpdatePopUpShown) return;
    isUpdatePopUpShown = true;

    showDialog(
      barrierDismissible: !isForceUpdate,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => !isForceUpdate,
        child: AlertDialog(
          title: const Text('Update Available'),
          content: const Text('A new version of the app is available. Update now?'),
          actions: [
            Row(
              children: [
                if (!isForceUpdate)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          isUpdatePopUpShown = false;
                          Navigator.pop(context);
                        },
                        child: const TextWidget(
                          text: 'Later ..',
                          fontSize: 14,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                if (!isForceUpdate) sb10w(),
                Expanded(
                  child: GradientButton(
                    onTap: () {
                      launchCustomURL(url, context);
                    },
                    text: 'Update',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> launchCustomURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.showError(context, "Url", "Unable to open the URL");
      print('Could not launch the URL: $url');
    }
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Delete".tr()),
        content: Text("Are you sure you want to delete your account? This action cannot be undone.".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              "Delete".tr(),
              style: const TextStyle(color: AppColor.redColor),
            ),
          ),
        ],
      ),
    );
  }

  bool isYouTubeLink(String? url) {
    if (url == null) return false;
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi);
  }
}
