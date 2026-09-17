class VerifyOtpModel {
  String phone;
  String otp;

  VerifyOtpModel({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "identifier": phone,
      "oneTimeCode": otp,
    };
  }
}
