class CustomerTransactionModel {
  bool? success;
  String? message;
  List<TransactionData>? data;

  CustomerTransactionModel({this.success, this.message, this.data});

  CustomerTransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(new TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  String? sId;
  MerchantId? merchantId;
  UserId? userId;
  DigitalCardId? digitalCardId;
  String? promotionId;
  num? totalBill;
  num? discountedBill;
  num? pointsEarned;
  num? pointRedeemed;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TransactionData({
    this.sId,
    this.merchantId,
    this.userId,
    this.digitalCardId,
    this.promotionId,
    this.totalBill,
    this.discountedBill,
    this.pointsEarned,
    this.pointRedeemed,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    merchantId = json['merchantId'] != null
        ? new MerchantId.fromJson(json['merchantId'])
        : null;
    userId = json['userId'] != null
        ? new UserId.fromJson(json['userId'])
        : null;
    digitalCardId = json['digitalCardId'] != null
        ? new DigitalCardId.fromJson(json['digitalCardId'])
        : null;
    promotionId = json['promotionId'];
    totalBill = json['totalBill'];
    discountedBill = json['discountedBill'];
    pointsEarned = json['pointsEarned'];
    pointRedeemed = json['pointRedeemed'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.merchantId != null) {
      data['merchantId'] = this.merchantId!.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    if (this.digitalCardId != null) {
      data['digitalCardId'] = this.digitalCardId!.toJson();
    }
    data['promotionId'] = this.promotionId;
    data['totalBill'] = this.totalBill;
    data['discountedBill'] = this.discountedBill;
    data['pointsEarned'] = this.pointsEarned;
    data['pointRedeemed'] = this.pointRedeemed;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class MerchantId {
  String? sId;
  String? businessName;

  MerchantId({this.sId, this.businessName});

  MerchantId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    businessName = json['businessName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['businessName'] = this.businessName;
    return data;
  }
}

class UserId {
  String? sId;
  String? firstName;
  String? email;
  String? phone;
  String? country;
  String? profile;

  UserId({
    this.sId,
    this.firstName,
    this.email,
    this.phone,
    this.country,
    this.profile,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['profile'] = this.profile;
    return data;
  }
}

class DigitalCardId {
  String? sId;
  String? cardCode;
  num? availablePoints;

  DigitalCardId({this.sId, this.cardCode, this.availablePoints});

  DigitalCardId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cardCode = json['cardCode'];
    availablePoints = json['availablePoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['cardCode'] = this.cardCode;
    data['availablePoints'] = this.availablePoints;
    return data;
  }
}
