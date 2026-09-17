import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/screen/sell_details_screen/model/sell_details_model.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/utils/app_log/app_log.dart';
import 'package:merchent/widget/app_log/app_print.dart';

class SellDetailsRepository extends GetxController {
  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool? _isSuccess;
  bool? get isSuccess => _isSuccess;

  Future<SellDetailsResponse?> getSellDetails({
    int? page,
    int? limit,
    String? period,
    String? searchTerm,
  }) async {
    try {
      _loading = true;
      _successMessage = null;
      _errorMessage = null;
      _isSuccess = null;
      update();

      final Map<String, dynamic> params = {};
      if (page != null) {
        params['page'] = page;
      }
      if (limit != null) {
        params['limit'] = limit;
      }
      if (period != null) {
        params['period'] = period;
      }
      if (searchTerm != null && searchTerm.isNotEmpty) {
        params['searchTerm'] = searchTerm;
      }

      final response = await ApiService.getApi(
        AppApiEndPoint.instance.sellDetailsEndPoint,
        queryParams: params,
      );

      AppPrint.apiResponse(params, title: "params");

      _loading = false;
      update();

      appLog('Sell Details API Response - Status: ${response.statusCode}');
      appLog('Sell Details API Response - Message: ${response.message}');
      appLog('Sell Details API Response - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success case
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          final sellDetailsResponse = SellDetailsResponse.fromJson(
            responseBody,
          );
          AppPrint.apiResponse(period);
          AppPrint.appPrint(
            sellDetailsResponse.toJson(),
            title: "sellDetailsResponse",
          );

          _isSuccess = sellDetailsResponse.success;
          _successMessage = response.message.isNotEmpty
              ? response.message
              : 'Data fetched successfully';
          return sellDetailsResponse;
        }
        _isSuccess = true;
        _successMessage = response.message.isNotEmpty
            ? response.message
            : 'Data fetched successfully';
        return null;
      } else {
        // Error case
        _isSuccess = false;
        _errorMessage = response.message.isNotEmpty
            ? response.message
            : 'Failed to fetch data';

        // Try to parse body if available for more details
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic> &&
            responseBody['message'] != null) {
          _errorMessage = responseBody['message'];
        }

        return null;
      }
    } catch (e) {
      _loading = false;
      _isSuccess = false;
      _errorMessage = e.toString();
      update();
      appLog('Sell Details API Error: $e');
      return null;
    }
  }
}
