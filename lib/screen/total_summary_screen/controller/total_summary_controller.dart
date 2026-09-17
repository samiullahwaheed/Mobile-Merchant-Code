import 'package:get/get.dart';
import 'package:merchent/screen/total_summary_screen/model/checkout_request_model.dart';
import 'package:merchent/screen/total_summary_screen/model/checkout_response_model.dart';
import 'package:merchent/service/repository/checkout_repository.dart';
import 'package:merchent/utils/app_log/app_log.dart';

class TotalSummaryController extends GetxController {
  final CheckoutRepository _checkoutRepository = CheckoutRepository();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final RxString responseMessage = ''.obs;

  // Arguments from navigation
  String digitalCardCode = '';
  int totalBill = 0;
  double pointRedeemed = 0;
  List<String> promotionId = [];

  @override
  void onInit() {
    super.onInit();
    _extractArguments();
  }

  void _extractArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    digitalCardCode = args['digitalCardCode'] ?? '';
    totalBill = (args['totalBill'] ?? 0).toInt();
    pointRedeemed = (args['pointRedeemed'] ?? 0).toDouble();
    promotionId = List<String>.from(args['promotionIds'] ?? []);

    appLog('TotalSummaryController initialized');
    appLog('digitalCardCode: $digitalCardCode');
    appLog('totalBill: $totalBill');
    appLog('promotionId: $promotionId');
  }

  /// Call checkout API
  Future<void> checkout({List<String>? promotionId}) async {
    try {
      isLoading.value = true;
      responseMessage.value = '';

      final List<String> finalPromotionIds = promotionId ?? this.promotionId;

      appLog('Calling checkout API...');
      appLog('digitalCardCode: $digitalCardCode');
      appLog('totalBill: $totalBill');
      appLog('promotionId: $finalPromotionIds');

      final requestModel = CheckoutRequestModel(
        digitalCardCode: digitalCardCode,
        totalBill: totalBill,
        promotionId: finalPromotionIds,
        pointRedeemed: pointRedeemed,
      );

      final CheckoutResponse? response = await _checkoutRepository.checkout(
        requestModel,
      );

      isLoading.value = false;

      if (response != null) {
        isSuccess.value = response.success;
        responseMessage.value = response.message;
        appLog(
          'Checkout response - success: ${response.success}, message: ${response.message}',
        );
      } else {
        isSuccess.value = false;
        responseMessage.value = 'Checkout failed';
        appLog('Checkout response is null');
      }
    } catch (e) {
      isLoading.value = false;
      isSuccess.value = false;
      responseMessage.value = e.toString();
      appLog('Error during checkout: $e');
    }
  }
}
