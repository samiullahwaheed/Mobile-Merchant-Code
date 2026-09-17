class CheckoutRequestModel {
  final String digitalCardCode;
  final int totalBill;
  final List<String> promotionId;
  final double? pointRedeemed;

  CheckoutRequestModel({
    required this.digitalCardCode,
    required this.totalBill,
    required this.promotionId,
    this.pointRedeemed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'digitalCardCode': digitalCardCode,
      'totalBill': totalBill,
      'promotionId': promotionId,
      'pointRedeemed': pointRedeemed,
    };
    return data;
  }
}
