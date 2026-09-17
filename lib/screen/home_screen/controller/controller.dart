import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/widget/app_log/app_print.dart';

import '../../../utils/app_log/app_log.dart';
import '../../notification_screen/controller/notification_controller.dart';
import '../model/dashboard_model.dart';
import '../model/model.dart';
import '../model/customer_chart_model.dart';
import '../../../service/repository/home_screen_repository/dashboard_repository.dart';
import '../../../service/repository/home_screen_repository/home_screen_repository.dart';
import '../../../service/repository/home_screen_repository/customer_chart_pero.dart';

class HomeScreenController extends GetxController {
  final HomeScreenRepository _repository = HomeScreenRepository();
  final MerchantReportRepository _merchantReportRepository =
      MerchantReportRepository();
  final CustomerChartRepository _customerChartRepository =
      CustomerChartRepository();

  RxString userFilterType = "All Time".obs;
  final RxBool isWeeklyReportLoading = false.obs;
  final RxString weeklyReportError = ''.obs;
  final Rxn<WeeklySellData> weeklySellData = Rxn<WeeklySellData>();

  final RxBool isMerchantReportLoading = false.obs;
  final RxString merchantReportError = ''.obs;
  final Rxn<ReportData> merchantReportData = Rxn<ReportData>();

  final RxBool isCustomerChartLoading = false.obs;
  final RxString customerChartError = ''.obs;
  final RxList<CustomerChartData> customerChartData = <CustomerChartData>[].obs;
  final RxInt selectedChartYear = RxInt(DateTime.now().year);

  /// Years available for chart: current year + last 2 years
  List<int> get chartYearOptions {
    final currentYear = DateTime.now().year;
    return [currentYear, currentYear - 1, currentYear - 2];
  }

  /// Monthly data aggregated by month (Jan-Dec) for the selected year
  List<MonthlyChartData> get monthlyChartData {
    final year = selectedChartYear.value;
    final monthlySums = <int, ({double revenue, double discount})>{};
    for (int m = 1; m <= 12; m++) {
      monthlySums[m] = (revenue: 0.0, discount: 0.0);
    }
    for (final item in customerChartData) {
      if (item.date.isEmpty) continue;
      try {
        final dt = DateTime.parse(item.date);
        if (dt.year == year && dt.month >= 1 && dt.month <= 12) {
          final current = monthlySums[dt.month]!;
          monthlySums[dt.month] = (
            revenue: current.revenue + item.revenue.toDouble(),
            discount: current.discount + item.totalDiscount.toDouble(),
          );
        }
      } catch (_) {}
    }
    return List.generate(12, (i) {
      final month = i + 1;
      final s = monthlySums[month]!;
      return MonthlyChartData(
        month: month,
        totalRevenue: s.revenue,
        totalDiscount: s.discount,
      );
    });
  }

  final List<Color> pieColors = [
    //saturday
    Color(0xFF7086FD),
    //sunday
    Color(0xFF6FD195),
    // Colors.blue[400]!,

    //monday
    // Colors.green[400]!,
    Color(0xFFFFAE4C),
    //tuesday
    Color(0xFF07DBFA),
    //wednesday
    Color(0xFF988AFC),
    //thursday
    Color(0xFF1F94FF),
    //friday
    Color(0xFFFF928A),

    // Colors.amber[400]!,
    //friday
  ];

  /// Converts the dropdown filter type to API range parameter
  String _getApiRangeFromFilter(String filterType) {
    switch (filterType) {
      case 'Today':
        return 'today';
      case 'Last 7 days':
        return '7d';
      // return '7d';
      case 'Last 30 days':
        return '1m';
      // return '30d';
      case 'All Time':
        return 'all';
      // return '30d';
      default:
        return 'day';
    }
  }

  void changeUserFilterType(String? newValue) {
    if (newValue != null) {
      userFilterType.value = newValue;
      appLog("User FilterType ===>>${userFilterType.value}");
      // Reload merchant report with new range
      loadMerchantReport();
    }
  }

  Future<void> loadWeeklySellReport() async {
    try {
      isWeeklyReportLoading.value = true;
      weeklyReportError.value = '';

      final response = await _repository.fetchWeeklySellReport();

      if (response.statusCode == 200) {
        final json = response.body as Map<String, dynamic>;
        final data = WeeklySellReportResponse.fromJson(json);
        weeklySellData.value = data.data;
      } else {
        weeklyReportError.value = response.message;
        weeklySellData.value = null;
      }
    } catch (e) {
      weeklyReportError.value = e.toString();
      weeklySellData.value = null;
    } finally {
      isWeeklyReportLoading.value = false;
    }
  }

  Future<void> loadMerchantReport() async {
    try {
      isMerchantReportLoading.value = true;
      merchantReportError.value = '';

      final String range = _getApiRangeFromFilter(userFilterType.value);
      final MerchantReportModel? response = await _merchantReportRepository
          .fetchMerchantReport(range: range);

      AppPrint.apiResponse(range, title: "range");

      if (response != null) {
        merchantReportData.value = response.data;
        AppPrint.apiResponse(response.data, title: "response");
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

  void changeChartYear(int? year) {
    if (year != null) {
      selectedChartYear.value = year;
      loadCustomerChart();
    }
  }

  Future<void> loadCustomerChart() async {
    try {
      isCustomerChartLoading.value = true;
      customerChartError.value = '';

      final int year = selectedChartYear.value;
      final DateTime startDate = DateTime(year, 1, 1);
      final DateTime endDate = DateTime(year, 12, 31);

      final response = await _customerChartRepository.fetchCustomerChart(
        startDate: startDate,
        endDate: endDate,
      );

      if (response.statusCode == 200) {
        final json = response.body as Map<String, dynamic>;
        final data = CustomerChartResponse.fromJson(json);
        customerChartData.value = data.data;
      } else {
        customerChartError.value = response.message;
        customerChartData.value = [];
      }
    } catch (e) {
      customerChartError.value = e.toString();
      customerChartData.value = [];
    } finally {
      isCustomerChartLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadWeeklySellReport(),
      loadMerchantReport(),
      loadCustomerChart(),
    ]);
  }

  @override
  void onInit() {
    changeUserFilterType(userFilterType.value);
    loadWeeklySellReport();
    loadMerchantReport();
    loadCustomerChart();
    NotificationController().onAppInitialDataLoad();
    super.onInit();
  }
}
