import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/screen/customer_details_screen/model/customer_details_model.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/utils/app_log/app_log.dart';

class CustomerDetailsRepository {
  Future<CustomerDetailsModel?> getCustomerDetails({
    int? page,
    int? limit,
    String? period,
    String? searchTerm,
  }) async {
    try {
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
        AppApiEndPoint.instance.customerDetailsEndPoint,
        queryParams: params,
      );

      appLog('Customer Details API Response - Status: ${response.statusCode}');
      appLog('Customer Details API Response - Message: ${response.message}');
      appLog('Customer Details API Response - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          return CustomerDetailsModel.fromJson(responseBody);
        }
      }
      return null;
    } catch (e) {
      appLog('Customer Details API Error: $e');
      return null;
    }
  }
}
