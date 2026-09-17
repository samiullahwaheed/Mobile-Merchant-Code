import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:merchent/service/repository/profile_get_repository.dart';
import 'package:merchent/service/storage/get_storage_services.dart';
import 'package:merchent/widget/app_log/app_print.dart';
import '../../../routes/app_routes.dart';
import '../../../service/storage/storage_service.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../utils/app_log/error_log.dart';
import '../../../service/repository/update_profile_repository.dart';

class SplashController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final UpdateProfileRepository _updateProfileRepository =
      UpdateProfileRepository();

  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  final GetStorageServices getStorageServices = GetStorageServices.instance;

  @override
  void onInit() {
    super.onInit();
    goToNextScreen();
    //
  }

  /// ===============================
  /// PROFILE FETCH
  /// ===============================
  Future<void> fetchProfile() async {
    try {
      final userProfile = await _profileRepository.fetchProfile();

      profile.value = userProfile;

      // /// ---------- Location Check ----------
      final coordinates = userProfile.location?.coordinates ?? <double>[];

      /// ---------- Business Name Check ----------
      final businessName = userProfile.businessName?.trim() ?? "";
    } catch (e) {
      AppPrint.appError(e.toString(), title: "Error fetching profile");
    }
  }

  /// ===============================
  /// SPLASH NAVIGATION LOGIC
  /// ===============================
  void goToNextScreen() async {
    await LocalStorage.getAllPrefData();

    final accessToken = LocalStorage.token;

    appLog("Access Token => $accessToken");

    /// Minimum splash duration, applies to every navigation path below
    /// (previously only ran on the logged-in branch, so it had no effect
    /// for first-time/logged-out users).
    await Future.delayed(const Duration(milliseconds: 1000));

    /// ---------- Login Check ----------
    if (accessToken.isEmpty) {
      if (getStorageServices.getIsUserFirstTime() == true) {
        _navigateTo(AppRoutes.authenticationsScreen);
      } else {
        _navigateTo(AppRoutes.onBoardingScreen);
      }
      return;
    }

    /// ---------- Fetch Profile ----------
    await fetchProfile();
    await getFCMToken();

    final bool isBusiness = LocalStorage.isBusiness;
    final bool isLocation = LocalStorage.isLocation;

    appLog("isBusiness => $isBusiness");
    appLog("isLocation => $isLocation");

    /// ---------- Navigation Decision ----------
    if (!isLocation) {
      _navigateTo(AppRoutes.locationScreen);
      return;
    }

    if (!isBusiness) {
      _navigateTo(AppRoutes.shopInformationScreen);
      return;
    }

    _navigateTo(AppRoutes.userBottomNav);
  }

  /// Removes the native splash screen (kept alive since app launch) right
  /// before handing off to the resolved first screen, so only one splash
  /// is ever visible to the user.
  void _navigateTo(String route) {
    FlutterNativeSplash.remove();
    Get.offAllNamed(route);
  }

  /// ===============================
  /// FCM TOKEN SYNC
  /// ===============================
  Future<void> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      appLog("FCM TOKEN: $token");

      if (token != null) {
        await _updateProfileRepository.syncFCMToken(token);
      }
    } catch (e) {
      errorLog("Failed to get FCM token: $e");
    }
  }

  @override
  void onClose() {
    appLog("SplashController disposed");
    super.onClose();
  }
}
