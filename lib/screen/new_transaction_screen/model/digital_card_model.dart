/// Model for the Digital Card with Promotions response
/// API: GET /add-promotion/find?cardCode=XXX
class DigitalCardResponse {
  final bool success;
  final String message;
  final DigitalCardData? data;

  DigitalCardResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DigitalCardResponse.fromJson(Map<String, dynamic> json) {
    return DigitalCardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? DigitalCardData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class DigitalCardData {
  final DigitalCard? digitalCard;

  DigitalCardData({this.digitalCard});

  factory DigitalCardData.fromJson(Map<String, dynamic> json) {
    return DigitalCardData(
      digitalCard: json['digitalCard'] != null
          ? DigitalCard.fromJson(json['digitalCard'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'digitalCard': digitalCard?.toJson()};
  }
}

class DigitalCard {
  final String id;
  final String userId;
  final String merchantId;
  final String cardCode;
  final List<Promotion> promotions;
  final String createdAt;
  final String updatedAt;
  final double availablePoints;

  DigitalCard({
    required this.id,
    required this.userId,
    required this.merchantId,
    required this.cardCode,
    required this.promotions,
    required this.createdAt,
    required this.updatedAt,
    required this.availablePoints,
  });

  factory DigitalCard.fromJson(Map<String, dynamic> json) {
    return DigitalCard(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      merchantId: json['merchantId'] ?? '',
      cardCode: json['cardCode'] ?? '',
      promotions:
          (json['promotions'] as List<dynamic>?)
              ?.map((e) => Promotion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      availablePoints: (json['availablePoints'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'merchantId': merchantId,
      'cardCode': cardCode,
      'promotions': promotions.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'availablePoints': availablePoints,
    };
  }
}

class Promotion {
  final String id;
  final String name;
  final String status;
  final String? usedAt;
  final double discountPercentage;
  final String promotionType;
  final String startDate;
  final String endDate;
  final String? image;
  final double? grossValue;

  Promotion({
    required this.id,
    required this.name,
    required this.status,
    this.usedAt,
    required this.discountPercentage,
    required this.promotionType,
    required this.startDate,
    required this.endDate,
    this.image,
    this.grossValue,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      usedAt: json['usedAt'],
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      promotionType: json['promotionType'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      image: json['image'],
      grossValue: (json['grossValue'] ?? 0).toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'usedAt': usedAt,
      'discountPercentage': discountPercentage,
      'promotionType': promotionType,
      'startDate': startDate,
      'endDate': endDate,
      'image': image,
      'grossValue': grossValue,
    };
  }

  /// Check if promotion is active
  bool get isActive => status == 'active';
}
