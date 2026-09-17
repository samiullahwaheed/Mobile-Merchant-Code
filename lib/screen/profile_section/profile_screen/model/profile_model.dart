class UserProfile {
  final String id;
  final String firstName;
  final String referenceId;
  final String role;
  final String email;
  final String phone;
  final String profile;
  final bool verified;
  final String status;
  final String userReport;
  final String subscription;
  final String about;
  final String businessName;
  /// Street / line address from API (separate from city & country).
  final String address;
  final String city;
  final String country;
  final String service;
  final String website;
  final int totalSubscriptions;

  final LocationModel? location;
  final AccountInformation? accountInformation;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.referenceId,
    required this.role,
    required this.email,
    required this.phone,
    required this.profile,
    required this.verified,
    required this.status,
    required this.userReport,
    required this.subscription,
    required this.about,
    required this.businessName,
    required this.address,
    required this.city,
    required this.country,
    required this.service,
    required this.website,
    required this.totalSubscriptions,
    this.location,
    this.accountInformation,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["_id"] is String ? json["_id"] : "",
      firstName: json["firstName"] is String ? json["firstName"] : "",
      referenceId: json["referenceId"] is String ? json["referenceId"] : "",
      role: json["role"] is String ? json["role"] : "",
      email: json["email"] is String ? json["email"] : "",
      phone: json["phone"] is String ? json["phone"] : "",
      profile: json["profile"] is String ? json["profile"] : "",
      verified: json["verified"] is bool ? json["verified"] : false,
      status: json["status"] is String ? json["status"] : "",
      userReport: json["userReport"] is String ? json["userReport"] : "",
      subscription: json["subscription"] is String ? json["subscription"] : "",
      about: json["about"] is String ? json["about"] : "",
      businessName:
      json["businessName"] is String ? json["businessName"] : "",
      address: json["address"] is String ? json["address"] : "",
      city: json["city"] is String ? json["city"] : "",
      country: json["country"] is String ? json["country"] : "",
      service: json["service"] is String ? json["service"] : "",
      website: json["website"] is String ? json["website"] : "",
      totalSubscriptions:
      json["totalSubscriptions"] is int ? json["totalSubscriptions"] : 0,
      location: json["location"] != null
          ? LocationModel.fromJson(json["location"])
          : null,
      accountInformation: json["accountInformation"] != null
          ? AccountInformation.fromJson(json["accountInformation"])
          : null,
    );
  }
}

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json["type"] is String ? json["type"] : "",
      coordinates: json["coordinates"] is List
          ? List<double>.from(
          json["coordinates"].map((e) => e is num ? e.toDouble() : 0.0))
          : [],
    );
  }
}

class AccountInformation {
  final bool status;

  AccountInformation({required this.status});

  factory AccountInformation.fromJson(Map<String, dynamic> json) {
    return AccountInformation(
      status: json["status"] is bool ? json["status"] : false,
    );
  }
}
