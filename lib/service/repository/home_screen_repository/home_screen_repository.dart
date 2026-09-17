import 'package:merchent/constant/app_api_end_point.dart';

import '../../api_service/api_services.dart';
import '../../api_service/service_model/service_model.dart';

class HomeScreenRepository {
  Future<ApiResponseModel> fetchWeeklySellReport() {
    return ApiService.getApi(AppApiEndPoint.instance.weeklySellReport);
  }
}
