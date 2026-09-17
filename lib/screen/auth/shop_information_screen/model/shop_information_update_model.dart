import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:merchent/utils/app_log/app_log.dart';

Future<void> updateBusiness({
  required String url,
  String? businessName,
  String? website,
  String? country,
  String? city,
  String? service,
  String? about,
  File? imageFile,
}) async {
  var request = http.MultipartRequest('PATCH', Uri.parse(url));

  // 🔹 Fields add
  if (businessName != null) request.fields['businessName'] = businessName;
  if (website != null) request.fields['website'] = website;
  if (country != null) request.fields['country'] = country;
  if (city != null) request.fields['city'] = city;
  if (service != null) request.fields['service'] = service;
  if (about != null) request.fields['about'] = about;

  // 🔹 File add
  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath('profile', imageFile.path),
    );
  }

  // 🔹 Send request
  var response = await request.send();

  if (response.statusCode == 200 || response.statusCode == 201) {
    appLog('Success!');
  } else {
    appLog('Failed: ${response.statusCode}');
  }
}
