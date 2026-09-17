class RedeemRequestModel {
  final String digitalCardCode;
  final List<String> promotionIds;
  final double totalBill;
  final double? pointRedeemed;

  RedeemRequestModel({
    required this.digitalCardCode,
    required this.promotionIds,
    required this.totalBill,
    this.pointRedeemed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> body = {
      "digitalCardCode": digitalCardCode,
      "promotionId": promotionIds,
      "totalBill": totalBill,
    };

    if (pointRedeemed != null) {
      body["pointRedeemed"] = pointRedeemed;
    }

    return body;
  }
}

