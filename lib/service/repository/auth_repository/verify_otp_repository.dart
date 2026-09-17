import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../screen/auth/verify_otp_screen/model/verify_otp_model.dart';
import '../../api_service/non_auth_api_service.dart';
import '../../repository/auth_repository/refresh_token_repository.dart';
import '../../storage/storage_key.dart';
import '../../storage/storage_service.dart';

class VerifyOtpRepository extends GetxController {
  late bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;

  String? get successfullyMessage => _successfullyMessage;

  verifyOtp({required VerifyOtpModel verifyOtpModel, required url}) async {
    _inProgress = true;
    _errorMessage = null;
    _successfullyMessage = null;
    update();

    var response = await NonAuthApiService.postApi(url, verifyOtpModel);
    debugPrint("response == $response");
    debugPrint('url => $url');

    _inProgress = false;

    if (response.statusCode == 200) {
      final data = response.body['data'] as Map<String, dynamic>? ?? {};
      await RefreshTokenRepository.instance.saveAuthTokens(data);
      LocalStorage.myRole = data['role']?.toString() ?? '';
      await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
      appLog('success message => ${response.message}');

      appLog('accessToken verify Otp=> ${LocalStorage.token}');
      appLog('role verify otp == => ${LocalStorage.myRole}');

      appLog('message => ${response.body}');

      _successfullyMessage = response.message;

      appLog('Success message ===> ${response.message} <===');

      update();
      appLog("response ${response.statusCode}");
      return response.body;
    } else {
      appLog('Error message ===> ${response.message} <===');
      _errorMessage = response.message;

      update();
      return false;
    }
  }
}
