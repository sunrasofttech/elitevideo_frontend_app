import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreference {
  static const String _key = 'push_notifications_enabled';

  static Future<void> setEnabled(bool value) async {
    log("message $value");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }
}
