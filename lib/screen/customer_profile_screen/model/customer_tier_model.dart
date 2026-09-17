class CustomerTierModel {
  bool? success;
  String? message;
  TierData? data;

  CustomerTierModel({this.success, this.message, this.data});

  CustomerTierModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new TierData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TierData {
  num? availablePoints;
  String? tierName;

  TierData({this.availablePoints, this.tierName});

  TierData.fromJson(Map<String, dynamic> json) {
    availablePoints = json['availablePoints'];
    tierName = json['tierName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availablePoints'] = this.availablePoints;
    data['tierName'] = this.tierName;
    return data;
  }
}
