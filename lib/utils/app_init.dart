import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/app_messaging.dart';
import 'package:elite/utils/storage/noti.dart';

class AppInit {
  static Future<void> init() async {
    try {
      AppMessaging.init();
      await FirebaseMessaging.instance.subscribeToTopic('all');
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        await NotificationPreference.setEnabled(false);
        log("🔴 User denied notification permissions.");
      } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await NotificationPreference.setEnabled(true);
        log("✅ Notifications authorized!");
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log("⚠️ Provisional notifications granted.");
      }
      await FirebaseMessaging.instance
          .subscribeToTopic(RegExp(r'^[a-zA-Z0-9-_.~%]{1,900}$').hasMatch("$token").toString());
      FirebaseMessaging.instance.setAutoInitEnabled(true);

      FirebaseMessaging.onBackgroundMessage(AppMessaging.backgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();

        if (message.notification != null) {
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            AppMessaging.createNotification(
                message.notification!.title.toString(), message.notification!.body.toString());
          }
        }
      });
      token = await FirebaseMessaging.instance.getToken();
      log("Token $token");
    } catch (e) {
      log("message fialed to message");
    }
  }
}
