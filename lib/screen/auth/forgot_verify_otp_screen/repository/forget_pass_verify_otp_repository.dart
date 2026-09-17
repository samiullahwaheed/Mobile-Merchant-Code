import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/non_auth_api_service.dart';
import 'package:merchent/utils/app_log/error_log.dart';
import 'package:merchent/widget/app_snack_bar/app_snack_bar.dart';

class ForgetPassVerifyOtpRepository {
  ForgetPassVerifyOtpRepository._();
  static final ForgetPassVerifyOtpRepository _instance =
      ForgetPassVerifyOtpRepository._();
  static ForgetPassVerifyOtpRepository get instance => _instance;

  Future<dynamic> verifyOtp({
    required String otp,
    required String email,
  }) async {
    try {
      Map<String, dynamic> body = {"oneTimeCode": otp, "identifier": email};
      final response = await NonAuthApiService.postApi(
        AppApiEndPoint.instance.verifyPhoneNumber,
        body,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 400) {
        AppSnackBar.message(response.body['message']);
        return null;
      }
    } catch (e) {
      errorLog(e);
    }
    return false;
  }
}
