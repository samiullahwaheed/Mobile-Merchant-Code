
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';

import '../../../screen/auth/reset_password_screen/model/reset_pass_model.dart';
import '../../../utils/app_log/app_log.dart';
import '../../api_service/non_auth_api_service.dart';

class UserResetPasswordRepository extends GetxController {
  late bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;

  String? get successfullyMessage => _successfullyMessage;

  resetPasswordApiCaller(
      {required ResetPasswordModel resetPasswordModel,
        required String url,
        required var resetToken}) async {
    _inProgress = true;
    _errorMessage = null;
    _successfullyMessage = null;
    update();

    final response = await NonAuthApiService.postApi(

      url,
      resetPasswordModel,
      header: resetToken,
    );

    _inProgress = false;

    if (response.statusCode == 200) {
      appLog('response message => ${response.message}');

      _successfullyMessage = response.message;

      appLog(
          'Success message *==> ${_successfullyMessage = response.message} <===*');
      debugPrint('_successfullyMessage ==> $_successfullyMessage');
      debugPrint('SrrorMessage ==> $successfullyMessage <==');

      update();
      return true;
    } else {
      appLog('Error message => ${response.message}');
      _errorMessage = response.message;
      update();
      return false;
    }
  }
}
