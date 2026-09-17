import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../constant/app_api_end_point.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/reset_paa_repository.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/reset_pass_model.dart';

class ResetPasswordController extends GetxController {
  final UserResetPasswordRepository _userResetPasswordRepository =
      Get.put(UserResetPasswordRepository());
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  late String token;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      token = Get.arguments['token'] ?? '';
      appLog(token);
    } else {
      token = '';
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }





  // Validate New Password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter New Password";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least 1 uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least 1 lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 number";
    }

    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must contain at least 1 special character";
    }

    return null;
  }

// Validate Confirm Password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm your Password";
    } else if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }



  Future<void> onTapResetButton() async {
    appLog(newPasswordController.text);
    appLog(confirmPasswordController.text);
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      AppSnackBar.error("Please fill in all required fields.");
      return;
    }

    var resetToken = {"Authorization": token};

    ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,

    );

    final bool isSuccess =
        await _userResetPasswordRepository.resetPasswordApiCaller(
          url: AppApiEndPoint.instance.forgotPassword,
            resetPasswordModel: resetPasswordModel, resetToken: resetToken);

    if (isSuccess) {
      AppSnackBar.success(
          '${_userResetPasswordRepository.successfullyMessage}');

      appLog(
          'success message ===> ${_userResetPasswordRepository.successfullyMessage} <===');

      Get.offAllNamed(AppRoutes.signInScreen);
    } else {
      AppSnackBar.message('${_userResetPasswordRepository.errorMessage}');
      appLog('error message => ${_userResetPasswordRepository.errorMessage}');
    }
  }


}
