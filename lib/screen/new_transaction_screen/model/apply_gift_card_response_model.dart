class ApplyGiftCardResponse {
  final bool success;
  final String message;
  final ApplyGiftCardData? data;

  ApplyGiftCardResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApplyGiftCardResponse.fromJson(Map<String, dynamic> json) {
    return ApplyGiftCardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ApplyGiftCardData.fromJson(json['data'])
          : null,
    );
  }
}

class ApplyGiftCardData {
  final String merchantId;
  final String userId;
  final String digitalCardId;
  final String promotionId;
  final int totalBill;
  final int discountedBill;
  final int pointRedeemed;
  final int pointDiscount;
  final int finalBill;
  final int pointsEarned;

  ApplyGiftCardData({
    required this.merchantId,
    required this.userId,
    required this.digitalCardId,
    required this.promotionId,
    required this.totalBill,
    required this.discountedBill,
    required this.pointRedeemed,
    required this.pointDiscount,
    required this.finalBill,
    required this.pointsEarned,
  });

  factory ApplyGiftCardData.fromJson(Map<String, dynamic> json) {
    return ApplyGiftCardData(
      merchantId: json['merchantId'] ?? '',
      userId: json['userId'] ?? '',
      digitalCardId: json['digitalCardId'] ?? '',
      promotionId: json['promotionId'] ?? '',
      totalBill: json['totalBill'] ?? 0,
      discountedBill: json['discountedBill'] ?? 0,
      pointRedeemed: json['pointRedeemed'] ?? 0,
      pointDiscount: json['pointDiscount'] ?? 0,
      finalBill: json['finalBill'] ?? 0,
      pointsEarned: json['pointsEarned'] ?? 0,
    );
  }
}
