import '../../constant/app_api_end_point.dart';
import '../../screen/terms_condition_screen/model/policy_model.dart';
import '../../widget/app_snack_bar/app_snack_bar.dart';
import '../api_service/api_services.dart';
import '../api_service/service_model/service_model.dart';

class CommonRepository {



  Future<TermsAndConditionsResponse?> fetchDisclaimerData({required String type}) async {
    try {
      final ApiResponseModel response =
          await ApiService.getApi(AppApiEndPoint.instance.disclaimer(type: type));

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          return TermsAndConditionsResponse.fromJson(body);
        }
        AppSnackBar.error("Invalid response format received.");
        return null;
      }

      AppSnackBar.error(response.message);
      return null;
    } catch (e) {
      AppSnackBar.error("Error fetching terms and conditions: ${e.toString()}");
      return null;
    }
  }

}