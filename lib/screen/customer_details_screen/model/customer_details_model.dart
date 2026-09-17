class CustomerDetailsModel {
  bool? success;
  List<CustomerData>? data;
  Pagination? pagination;

  CustomerDetailsModel({this.success, this.data, this.pagination});

  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CustomerData>[];
      json['data'].forEach((v) {
        data!.add(CustomerData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class CustomerData {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? profile;
  String? country;
  String? customUserId;
  int? totalTransactions;
  double? totalPointsEarned;
  double? totalPointsRedeemed;
  double? totalBilled;
  double? finalBilled;
  String? cardIds;
  double? availablePoints;
  String? salesRep;
  double? rating;
  String? ratingComment;
  String? status;

  CustomerData({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.country,
    this.customUserId,
    this.totalTransactions,
    this.totalPointsEarned,
    this.totalPointsRedeemed,
    this.totalBilled,
    this.finalBilled,
    this.cardIds,
    this.availablePoints,
    this.salesRep,
    this.rating,
    this.ratingComment,
    this.status,
  });

  CustomerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profile = json['profile'];
    country = json['country'];
    customUserId = json['customUserId'];
    totalTransactions = (json['totalTransactions'] as num?)?.toInt();
    totalPointsEarned = (json['totalPointsEarned'] as num?)?.toDouble();
    totalPointsRedeemed = (json['totalPointsRedeemed'] as num?)?.toDouble();
    totalBilled = (json['totalBilled'] as num?)?.toDouble();
    finalBilled = (json['finalBilled'] as num?)?.toDouble();
    cardIds = json['cardIds'];
    availablePoints = (json['availablePoints'] as num?)?.toDouble();
    salesRep = json['salesRep'];
    rating = (json['rating'] as num?)?.toDouble();
    ratingComment = json['ratingComment'];
    status = json['status'];
  }
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }
}
