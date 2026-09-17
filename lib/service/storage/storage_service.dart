import 'package:get/get.dart';
import 'package:http/http.dart' as box;
import 'package:merchent/service/api_service/cookie_service.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/app_color/theme_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_log/app_log.dart';

class LocalStorage {
  static String token = "";
  static String cookie = "";
  static String refreshToken = "";
  static String resetToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myRole = "";
  static bool isBusiness = false;
  static bool isLocation = false;
  // Create Local Storage Instance
  static SharedPreferences? preferences;

  /// Get SharedPreferences Instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  static String getToken() {
    return preferences?.getString(LocalStorageKeys.token) ?? token;
  }

  static String getRefreshToken() {
    return preferences?.getString(LocalStorageKeys.refreshToken) ??
        refreshToken;
  }

  /// Get All Data From SharedPreferences
  static Future<void> getAllPrefData() async {
    final localStorage = await _getStorage();

    token = localStorage.getString(LocalStorageKeys.token) ?? "";
    cookie = localStorage.getString(LocalStorageKeys.cookie) ?? "";
    refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
    resetToken = localStorage.getString(LocalStorageKeys.resetToken) ?? "";
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    isBusiness = localStorage.getBool(LocalStorageKeys.isBusiness) ?? false;
    isLocation = localStorage.getBool(LocalStorageKeys.isLocation) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";
    myRole = localStorage.getString(LocalStorageKeys.myRole) ?? "";
    appLog(userId, source: "Local Storage");
  }

  /// Remove All Data From SharedPreferences
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    try {
      await CookieService.instance.cookieJar.deleteAll();
    } catch (_) {}
    await ThemeController.resetThemeOnLogout();
    Get.offAllNamed(AppRoutes.authenticationsScreen);
    // await getAllPrefData();
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    final localStorage = preferences!;
    localStorage.setString(LocalStorageKeys.token, "");
    localStorage.setString(LocalStorageKeys.cookie, "");
    localStorage.setString(LocalStorageKeys.refreshToken, "");
    localStorage.setString(LocalStorageKeys.resetToken, "");
    localStorage.setString(LocalStorageKeys.userId, "");
    localStorage.setString(LocalStorageKeys.myImage, "");
    localStorage.setString(LocalStorageKeys.myName, "");
    localStorage.setString(LocalStorageKeys.myEmail, "");
    localStorage.setString(LocalStorageKeys.myRole, "");
    localStorage.setBool(LocalStorageKeys.isLogIn, false);
    localStorage.setBool(LocalStorageKeys.isBusiness, false);
    localStorage.setBool(LocalStorageKeys.isLocation, false);
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }
}
