class WeeklySellReportResponse {
  final bool success;
  final String message;
  final WeeklySellData data;

  WeeklySellReportResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WeeklySellReportResponse.fromJson(Map<String, dynamic> json) {
    return WeeklySellReportResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: WeeklySellData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class WeeklySellData {
  final num totalSell;
  final List<WeeklyReportItem> weeklyReport;

  WeeklySellData({
    required this.totalSell,
    required this.weeklyReport,
  });

  factory WeeklySellData.fromJson(Map<String, dynamic> json) {
    final reportList = (json['weeklyReport'] as List<dynamic>? ?? [])
        .map((item) => WeeklyReportItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return WeeklySellData(
      totalSell: json['totalSell'] as num? ?? 0,
      weeklyReport: reportList,
    );
  }
}

class WeeklyReportItem {
  final String day;
  final num totalSell;
  final num totalOrders;
  final num percentage;

  WeeklyReportItem({
    required this.day,
    required this.totalSell,
    required this.totalOrders,
    required this.percentage,
  });

  factory WeeklyReportItem.fromJson(Map<String, dynamic> json) {
    return WeeklyReportItem(
      day: json['day'] as String? ?? '',
      totalSell: json['totalSell'] as num? ?? 0,
      totalOrders: json['totalOrders'] as num? ?? 0,
      percentage: json['percentage'] as num? ?? 0,
    );
  }
}
