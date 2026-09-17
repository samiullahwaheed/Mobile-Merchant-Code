class ChangePasswordModel {
  final String newPassword;
  final String confirmPassword;
  final String oldPassword;

  ChangePasswordModel(
      {required this.newPassword, required this.confirmPassword, required this.oldPassword});

  Map<String, dynamic> toJson() {
    return {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "currentPassword": oldPassword,
    };
  }
}
