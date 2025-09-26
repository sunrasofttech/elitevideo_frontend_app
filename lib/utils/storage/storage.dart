import 'dart:developer';
import 'package:elite/constant/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async => instance = await SharedPreferences.getInstance();

  static String? get userId => instance.getString(AppString.sharedPrefUserId);
  static String? get getToken => instance.getString(AppString.sharedPrefToken);

  static Future<void>? saveUserId(String id) async {
    await instance.setString(AppString.sharedPrefUserId, id);
    log('User Id Saved to Localstorage $id');
  }

  static Future<void> saveToken(String token) async {
    await instance.setString(AppString.sharedPrefToken, token);
    log("Token Saved! $token");
  }

  static Future<void> clear() async {
    await instance.clear();
  }
}
