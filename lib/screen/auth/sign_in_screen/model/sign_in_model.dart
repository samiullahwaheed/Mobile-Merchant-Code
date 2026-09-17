class SignInModel {
  final String email;
  final String password;
  final String deviceId;
  SignInModel({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "identifier": email,
      "password": password,
      "device": deviceId,
    };
  }
}
