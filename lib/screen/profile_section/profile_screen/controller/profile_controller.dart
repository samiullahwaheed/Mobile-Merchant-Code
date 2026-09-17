import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:merchent/service/repository/auth_repository/delete_account_repository.dart';
import '../../../../constant/app_image_path.dart';
import '../../../../constant/app_api_end_point.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/profile_get_repository.dart';
import '../../../../service/storage/storage_key.dart';
import '../../../../service/storage/storage_service.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  TextEditingController passwordTEController = TextEditingController();
  final DeleteAccountRepository _deleteAccountRepository =
      DeleteAccountRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  LocalStorage storage = LocalStorage();
  String role = LocalStorage.myRole;

  // Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 8 characters";
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final userProfile = await _profileRepository.fetchProfile();
      profile.value = userProfile;

      // Save userId to LocalStorage
      if (userProfile.id.isNotEmpty) {
        LocalStorage.userId = userProfile.id;
        await LocalStorage.setString(LocalStorageKeys.userId, userProfile.id);
        appLog('userId saved to LocalStorage: ${userProfile.id}');
      }

      // Debug logging
      appLog('Profile fetched successfully');
      appLog('Profile URL from API: "${userProfile.profile}"');
      appLog('Is profile empty: ${userProfile.profile.isEmpty}');
    } catch (e) {
      errorMessage.value = e.toString();
      appLog('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String resolveProfileImage(UserProfile? user) {
    final raw = (user?.profile ?? '').trim();

    appLog('=== RESOLVE PROFILE IMAGE ===');
    appLog('Raw profile value: "$raw"');
    appLog('Is raw empty: ${raw.isEmpty}');

    if (raw.isEmpty) {
      appLog('Profile is empty, returning default: ${AppImagePath.profile}');
      return AppImagePath.profile;
    }

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      appLog('Profile starts with http/https, returning as-is: $raw');
      return raw;
    }

    final base = AppApiEndPoint.domain;
    if (raw.startsWith('/')) {
      final result = '$base$raw';
      appLog('Profile starts with /, returning: $result');
      return result;
    }

    final result = '$base/$raw';
    appLog('Profile relative path, returning: $result');
    return result;
  }

  Future<void> onTapDeleteAccountButton() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    isLoading.value = true;
    update(); // ✅ show loading

    final bool isSuccess = await _deleteAccountRepository.deleteAccount(
      password: passwordTEController.text,
    );

    isLoading.value = false;
    update(); // ✅ hide loading

    if (isSuccess) {
      AppSnackBar.success(
        _deleteAccountRepository.successfullyMessage ?? 'Successful!',
      );
      appLog(
        'success message => ${_deleteAccountRepository.successfullyMessage}',
      );

      passwordTEController.clear();
      formKey.currentState?.reset();

      // Close the dialog then navigate to sign-in
      try {
        Get.back(); // close dialog
      } catch (e) {
        // ignore if the dialog is already closed
      }

      Get.offAllNamed(AppRoutes.signInScreen);
    } else {
      AppSnackBar.message('${_deleteAccountRepository.errorMessage}');
      appLog('error message => ${_deleteAccountRepository.errorMessage}');
    }
  }

  // Log out
  Future<void> logout() async {
    try {
      AppSnackBar.success("Logged out successfully!");
      LocalStorage.userId = '';
      appLog('user screen userId clear===>  ${LocalStorage.userId}');
      await LocalStorage.removeAllPrefData();
    } catch (e) {
      AppSnackBar.error("Failed to log out. Please try again.");
    }
  }
}
