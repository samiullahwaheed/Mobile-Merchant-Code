class CustomerChartResponse {
  final bool success;
  final String message;
  final List<CustomerChartData> data;

  CustomerChartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CustomerChartResponse.fromJson(Map<String, dynamic> json) {
    return CustomerChartResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => CustomerChartData.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class CustomerChartData {
  final String date;
  final num revenue;
  final num totalDiscount;

  CustomerChartData({
    required this.date,
    required this.revenue,
    this.totalDiscount = 0,
  });

  factory CustomerChartData.fromJson(Map<String, dynamic> json) {
    return CustomerChartData(
      date: json['date'] as String? ?? '',
      revenue: (json['revenue'] ?? json['totalRevenue'] ?? 0) as num,
      totalDiscount: (json['totalDiscount'] ?? json['discount'] ?? 0) as num,
    );
  }
}

/// Monthly aggregated data for chart (Jan-Dec)
class MonthlyChartData {
  final int month; // 1-12
  final double totalRevenue;
  final double totalDiscount;

  MonthlyChartData({
    required this.month,
    required this.totalRevenue,
    required this.totalDiscount,
  });
}
