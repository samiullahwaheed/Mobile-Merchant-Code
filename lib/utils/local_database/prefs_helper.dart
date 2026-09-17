import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_log/app_log.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static String accessToken = "";
  static String forgetToken = "";
  static String businessId = "";
  static bool isLogIn = false;
  static bool isCreateBusiness = false;
  static bool businessLogIn = false;
  static bool isNotifications = true;
  static String refreshToken = "";
  static String userId = "";
  static String signUpToken = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myRole = "";
  static String mySubscription = "";
  static String localizationLanguageCode = 'en';
  static String localizationCountryCode = 'PK';

  ///<<<======================== Get All Data Form Shared Preference ==============>

  static Future<void> getAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString("accessToken") ?? "";
    userId = preferences.getString("userId") ?? "";
    signUpToken = preferences.getString("signUpToken") ?? "";
    myImage = preferences.getString("myImage") ?? "";
    myName = preferences.getString("myName") ?? "";
    myEmail = preferences.getString("myEmail") ?? "";
    myRole = preferences.getString("myRole") ?? "";
    isLogIn = preferences.getBool("isLogIn") ?? false;
    isCreateBusiness = preferences.getBool("isCreateBusiness") ?? false;
    businessLogIn = preferences.getBool("businessLogIn") ?? false;
    isNotifications = preferences.getBool("isNotifications") ?? true;
    mySubscription = preferences.getString("mySubscription") ?? "shopping";
    localizationCountryCode =
        preferences.getString("localizationCountryCode") ?? "PK";
    localizationLanguageCode =
        preferences.getString("localizationLanguageCode") ?? "en";

    if (kDebugMode) {
      appLog('accessToken =-==-==-=>> $accessToken');
      appLog(isLogIn);
    }
  }

  ///<<<======================== Get All Data Form Shared Preference ============>
  static Future<void> removeAllPrefData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await preferences.setString("token", "");
    await preferences.setString("businessId", "");
    await preferences.setString("userId", "");
    await preferences.setString("signUpToken", "");
    await preferences.setString("myImage", "");
    await preferences.setString("myName", "");
    await preferences.setString("myEmail", "");
    await preferences.setString("myRole", "");
    await preferences.setBool("isLogIn", false);
    await preferences.setBool("isCreateBusiness", false);
    await preferences.setBool("businessLogIn", false);
    await preferences.setBool("isNotifications", true);
    await preferences.setString("mySubscription", "shopping");

    //Get.offAllNamed(AppRoutes.signInScreen);
    getAllPrefData();
  }

  ///<<<======================== Get Data Form Shared Preference ==============>

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? (-1);
  }

  ///<<<=====================Save Data To Shared Preference=====================>

  static Future setString(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  static Future setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(key, value);
  }

  ///<<<==========================Remove Value==================================>

  static Future remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
