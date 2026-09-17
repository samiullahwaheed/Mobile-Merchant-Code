import 'package:get/get.dart';
import 'package:merchent/screen/total_summary_screen/model/checkout_request_model.dart';
import 'package:merchent/screen/total_summary_screen/model/checkout_response_model.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/utils/app_log/app_log.dart';

class CheckoutRepository extends GetxController {
  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool? _isSuccess;
  bool? get isSuccess => _isSuccess;

  Future<CheckoutResponse?> checkout(CheckoutRequestModel model) async {
    try {
      _loading = true;
      _successMessage = null;
      _errorMessage = null;
      _isSuccess = null;
      update();

      final response = await ApiService.postApi(
        AppApiEndPoint.instance.checkout,
        model,
      );

      _loading = false;
      update();

      appLog('Checkout API Response - Status: ${response.statusCode}');
      appLog('Checkout API Response - Message: ${response.message}');
      appLog('Checkout API Response - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success case
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          final checkoutResponse = CheckoutResponse.fromJson(responseBody);
          _isSuccess = checkoutResponse.success;
          _successMessage = checkoutResponse.message;
          return checkoutResponse;
        }
        _isSuccess = true;
        _successMessage = response.message ?? 'Checkout successful';
        return CheckoutResponse(success: true, message: _successMessage!);
      } else {
        // Error case - use response.message which contains the API error message
        _isSuccess = false;
        _errorMessage = response.message ?? 'Checkout failed';

        // Try to parse body if available for more details
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic> &&
            responseBody['message'] != null) {
          _errorMessage = responseBody['message'];
        }

        return CheckoutResponse(success: false, message: _errorMessage!);
      }
    } catch (e) {
      _loading = false;
      _isSuccess = false;
      _errorMessage = e.toString();
      update();
      appLog('Checkout API Error: $e');
      return CheckoutResponse(success: false, message: _errorMessage!);
    }
  }
}
