import 'package:get/get.dart';
import 'package:merchent/screen/new_transaction_screen/model/apply_gift_card_model.dart';
import '../../../service/api_service/api_services.dart';
import '../../../constant/app_api_end_point.dart';

class RedeemRepository extends GetxController {
  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  // Response data fields
  Map<String, dynamic>? _responseData;
  Map<String, dynamic>? get responseData => _responseData;

  Future<bool> redeemPoints(RedeemRequestModel model) async {
    try {
      _loading = true;
      _successMessage = null;
      _errorMessage = null;
      _responseData = null;
      update();

      final response = await ApiService.postApi(
        AppApiEndPoint.instance.giftCardApply,
        model,
      );

      _loading = false;
      update();

      if (response.statusCode == 200) {
        // Parse response to get message and data
        try {
          final responseData = response.data;
          if (responseData is Map<String, dynamic>) {
            _successMessage =
                responseData['message'] ?? 'Gift card applied successfully';
            // Store the data object for navigation
            if (responseData['data'] != null) {
              _responseData = responseData['data'] as Map<String, dynamic>;
            }
          } else {
            _successMessage = 'Gift card applied successfully';
          }
        } catch (e) {
          _successMessage = 'Gift card applied successfully';
        }
        return true;
      } else {
        // Get error message from API response
        try {
          final responseData = response.data;
          if (responseData is Map<String, dynamic>) {
            _errorMessage = responseData['message'] ?? response.message;
          } else {
            _errorMessage = response.message;
          }
        } catch (e) {
          _errorMessage = response.message;
        }
        return false;
      }
    } catch (e) {
      _loading = false;
      _errorMessage = e.toString();
      update();
      return false;
    }
  }
}
