class SignUpModel {
  final String name;
  final String email;
  final String number;
  final String password;
  final String role;

  SignUpModel({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": name,
      "email": email,
      "phone": number,
      "password": password,
      "role": role,
    };
  }
}
