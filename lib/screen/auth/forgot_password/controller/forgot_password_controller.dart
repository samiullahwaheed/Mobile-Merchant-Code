import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/forgot_pass_repository.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';

class ForgotPasswordOnTapButtonController extends GetxController {
  final phoneNumberController = TextEditingController();

  final ForgotPassRepository _forgotPassRepository = Get.put(ForgotPassRepository());
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    phoneNumberController.dispose();
    super.onClose();
  }


 

  //validate number
  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Number";
    } else if (value.length < 9) {
      return "Enter a valid Number";
    }
    return null;
  }

/// on Tap button

  Future<void> onTapSentPhoneOtpButton() async {

    if ( phoneNumberController.text.isNotEmpty) {
      final bool isSuccess = await _forgotPassRepository.forgotPass(
         phoneNumber:  phoneNumberController.text.trim());

      _forgotPassRepository.inProgress == true;

      if (isSuccess) {
        _forgotPassRepository.inProgress == false;

        AppSnackBar.success(_forgotPassRepository.successfullyMessage ??
            'Verification Code Sent!');
        appLog('success message => ${_forgotPassRepository.errorMessage}');
        Get.toNamed(
          AppRoutes.forgotPassVerifyOtpScreen,
          arguments: {'phone': phoneNumberController.text,
           'successRoute':  AppRoutes.resetPasswordScreen
          },
        );
      } else {
        _forgotPassRepository.inProgress == false;
        // error message
        AppSnackBar.message('${_forgotPassRepository.errorMessage}');
        appLog(
            'error message => ${_forgotPassRepository.errorMessage}');
      }
    } else {
      AppSnackBar.error("Please enter your phone number.");
    }
  }

}
