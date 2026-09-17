import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/service/storage/storage_service.dart';
import 'package:merchent/utils/app_translation/app_static_key.dart';

class NoInternetController extends GetxController {
  final RxBool isChecking = false.obs;

  Future<void> tryAgain() async {
    if (isChecking.value) return;

    isChecking.value = true;
    try {
      final hasInternet = await InternetConnectionChecker.instance.hasConnection;
      if (hasInternet) {
        if (LocalStorage.getToken().isNotEmpty) {
          Get.offAllNamed(AppRoutes.userBottomNav);
        } else {
          Get.offAllNamed(AppRoutes.splashScreen);
        }
      } else {
        Get.snackbar(
          AppStaticKey.noInternetConnection,
          'Please check your connection and try again.',
        );
      }
    } finally {
      isChecking.value = false;
    }
  }
}
