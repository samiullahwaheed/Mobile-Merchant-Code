import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/service/storage/storage_service.dart';

class NetworkController extends GetxController {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  static const _skipRoutes = {
    AppRoutes.splashScreen,
    AppRoutes.noInternetScreen,
    AppRoutes.onBoardingScreen,
  };

  @override
  void onInit() {
    super.onInit();
    _subscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasNetwork = results.any((r) => r != ConnectivityResult.none);
    if (!hasNetwork) {
      _goToNoInternet();
    }
  }

  void _goToNoInternet() {
    final currentRoute = Get.currentRoute;
    if (_skipRoutes.contains(currentRoute)) return;
    if (LocalStorage.getToken().isEmpty) return;
    if (currentRoute == AppRoutes.noInternetScreen) return;

    Get.offAllNamed(AppRoutes.noInternetScreen);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
