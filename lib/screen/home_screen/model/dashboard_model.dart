class MerchantReportModel {
  final bool success;
  final String message;
  final ReportData data;

  MerchantReportModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MerchantReportModel.fromJson(Map<String, dynamic> json) {
    return MerchantReportModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: ReportData.fromJson(json["data"] ?? {}),
    );
  }
}

class ReportData {
  final String range;
  final double totalSales;
  final double totalMembers;
  final double totalPointsIssued;
  final double rewardsRedeemed;

  ReportData({
    required this.range,
    required this.totalSales,
    required this.totalMembers,
    required this.totalPointsIssued,
    required this.rewardsRedeemed,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      range: json["range"] ?? "",
      totalSales: (json["totalSales"] ?? 0).toDouble(),
      totalMembers: (json["totalMembers"] ?? 0).toDouble(),
      totalPointsIssued: (json["totalPointsIssued"] ?? 0).toDouble(),
      rewardsRedeemed: (json["rewardsRedeemed"] ?? 0).toDouble(),
    );
  }
}
