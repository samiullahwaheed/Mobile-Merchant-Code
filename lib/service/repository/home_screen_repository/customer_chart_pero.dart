import 'package:intl/intl.dart';
import 'package:merchent/constant/app_api_end_point.dart';

import '../../api_service/api_services.dart';
import '../../api_service/service_model/service_model.dart';

class CustomerChartRepository {
  Future<ApiResponseModel> fetchCustomerChart({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Format dates as yyyy-MM-dd
    final String formattedStartDate = DateFormat(
      'yyyy-MM-dd',
    ).format(startDate);
    final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    // Build URL with query parameters
    final String url =
        '${AppApiEndPoint.instance.customerChartWeek}?startDate=$formattedStartDate&endDate=$formattedEndDate';

    return ApiService.getApi(url);
  }
}
