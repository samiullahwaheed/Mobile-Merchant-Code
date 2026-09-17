import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/app_log/app_print.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDark');

    if (savedTheme != null) {
      isDark.value = savedTheme;
      Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    } else {
      isDark.value = Get.isPlatformDarkMode;
    }
  }

  void changeTheme() async {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    AppPrint.appPrint(isDark);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark.value);
  }

  Future<void> resetTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isDark');
    isDark.value = Get.isPlatformDarkMode;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  static Future<void> resetThemeOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isDark');
    final isPlatformDark = Get.isPlatformDarkMode;
    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().isDark.value = isPlatformDark;
    }
    Get.changeThemeMode(isPlatformDark ? ThemeMode.dark : ThemeMode.light);
  }
}
