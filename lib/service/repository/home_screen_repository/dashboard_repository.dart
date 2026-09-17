import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/screen/home_screen/model/dashboard_model.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/service/api_service/service_model/service_model.dart';

// import '../../../widget/app_snack_bar/app_snack_bar.dart';

class MerchantReportRepository extends GetxController {
  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<MerchantReportModel?> fetchMerchantReport({String? range}) async {
    try {
      _loading = true;
      _errorMessage = null;
      update();

      String endpoint = AppApiEndPoint.instance.staticsdashboard;
      if (range != null && range.isNotEmpty) {
        endpoint = '$endpoint?range=$range';
      }

      final ApiResponseModel response = await ApiService.getApi(endpoint);

      _loading = false;
      update();

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          return MerchantReportModel.fromJson(body);
        }
        _errorMessage = "Invalid response format received.";
        return null;
      }

      _errorMessage = response.message;
      // AppSnackBar.error(response.message);
      return null;
    } catch (e) {
      _loading = false;
      _errorMessage = "Error fetching merchant report: ${e.toString()}";
      update();
      // AppSnackBar.error(_errorMessage!);
      return null;
    }
  }
}
