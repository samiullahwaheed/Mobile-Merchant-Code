import 'package:get/get.dart';
import 'package:merchent/screen/home_screen/model/dashboard_model.dart';

import '../../../service/repository/home_screen_repository/dashboard_repository.dart';

class SalesManagementController extends GetxController {
  // Observed variable for selected sort option
  final RxString selectedOption = "All Time".obs;

  final MerchantReportRepository _merchantReportRepository =
      MerchantReportRepository();

  final RxBool isMerchantReportLoading = false.obs;
  final RxString merchantReportError = ''.obs;
  final Rxn<ReportData> merchantReportData = Rxn<ReportData>();

  String _getApiRangeFromFilter(String filterType) {
    switch (filterType) {
      case 'Today':
        return 'today';
      case 'Last 7 days':
        return '7d';
      case 'Last 30 days':
        return '1m';
      case 'All Time':
        return 'all';
      default:
        return 'day';
    }
  }

  // Method to update the selected option
  void updateSortOption(String value) {
    selectedOption.value = value;
    loadMerchantReport();
  }

  Future<void> loadMerchantReport() async {
    try {
      isMerchantReportLoading.value = true;
      merchantReportError.value = '';

      final String range = _getApiRangeFromFilter(selectedOption.value);
      final MerchantReportModel? response = await _merchantReportRepository
          .fetchMerchantReport(range: range);

      if (response != null) {
        merchantReportData.value = response.data;
      } else {
        merchantReportData.value = null;
        merchantReportError.value =
            _merchantReportRepository.errorMessage ??
            'Failed to load merchant report';
      }
    } catch (e) {
      merchantReportData.value = null;
      merchantReportError.value = e.toString();
    } finally {
      isMerchantReportLoading.value = false;
    }
  }

  @override
  void onInit() {
    loadMerchantReport();
    super.onInit();
  }
}
