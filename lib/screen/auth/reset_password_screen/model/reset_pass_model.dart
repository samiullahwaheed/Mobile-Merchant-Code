class ResetPasswordModel {
  final String? newPassword;
  final String? confirmPassword;
  final String? oldPassword;

  ResetPasswordModel(
      { this.newPassword,  this.confirmPassword,  this.oldPassword});

  Map<String, dynamic> toJson() {
    return {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "currentPassword": oldPassword,
    };
  }
}
