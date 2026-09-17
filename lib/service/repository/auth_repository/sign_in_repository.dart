import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/service/storage/storage_service.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../api_service/non_auth_api_service.dart';
import '../../repository/auth_repository/refresh_token_repository.dart';

class SignInApiController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successfullyMessage = '';
  String get successfullyMessage => _successfullyMessage;

  // Return status code instead of bool for better handling
  Future<dynamic> signInApiCall({required signInModel, String? email}) async {
    _inProgress = true;
    _errorMessage = '';
    _successfullyMessage = '';
    update();

    try {
      final response = await NonAuthApiService.postApi(
        AppApiEndPoint.instance.authLogin,
        signInModel,
      );

      _inProgress = false;

      if (response.statusCode == 200) {
        final data = response.body['data'] as Map<String, dynamic>? ?? {};
        await RefreshTokenRepository.instance.saveAuthTokens(data);
        LocalStorage.myRole = data['user']?['role']?.toString() ?? '';
        await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);


        _successfullyMessage = response.message ?? "Login successful";
        update();
        return response.body["data"];
      } else if (response.statusCode == 407) {
        _errorMessage = response.message ?? "OTP verification required";
        appLog('OTP verification required');
        update();
        return 407;
      }
      // ৪00 স্ট্যাটাসের জন্য নতুন ব্লক
      else if (response.statusCode == 400) {
        _errorMessage = response.message ?? "Bad request";
        appLog('Bad request: ${response.message}');
        update();
        return 400;
      } else {
        _errorMessage = response.message ?? "Login failed";
        appLog(
          'Login failed - Status: ${response.statusCode}, Message: ${response.message}',
        );
        update();
        return response.statusCode;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('SignIn API Error: $e');
      update();
      return 500;
    }
  }
 
}
