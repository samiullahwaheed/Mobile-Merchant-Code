import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/screen/new_transaction_screen/model/digital_card_model.dart';

import '../../api_service/api_services.dart';
import '../../api_service/service_model/service_model.dart';

class PromotionRepository {
  String? errorMessage;

  /// Fetches digital card with promotions by card code
  /// API: GET /add-promotion/find?cardCode=XXX
  Future<DigitalCardResponse?> findPromotionByCardCode({
    required String cardCode,
  }) async {
    try {
      final String endpoint = AppApiEndPoint.instance.findPromotionByCardCode(
        cardCode,
      );

      final ApiResponseModel response = await ApiService.getApi(endpoint);

      if (response.statusCode == 200) {
        errorMessage = null;
        final json = response.body as Map<String, dynamic>;
        return DigitalCardResponse.fromJson(json);
      } else {
        errorMessage = response.message;
        return null;
      }
    } catch (e) {
      errorMessage = e.toString();
      return null;
    }
  }
}
