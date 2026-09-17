class ContactUsModel {
  final String name;
  final String email;
  final String subject;
  final String message;

  ContactUsModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "subject": subject,
      "message": message,
    };
  }
}
// class ContactUsModel {
//   final String name;
//   final String email;
//   final String subject;
//   final String message;

//   ContactUsModel({
//     required this.name,
//     required this.email,
//     required this.subject,
//     required this.message,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "email": email,
//       "subject": subject,
//       "message": message,
//     };
//   }
// }
