import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/utils/app_log/app_log.dart';

import '../../screen/customer_profile_screen/model/customer_tier_model.dart';
import '../../screen/customer_profile_screen/model/customer_transaction_model.dart';

class CustomerTransactionRepository {
  Future<CustomerTransactionModel?> getCustomerTransactions(String id) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.customerTransactions(id),
      );

      appLog(
        'Customer Transactions API Response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          return CustomerTransactionModel.fromJson(responseBody);
        }
      }
      return null;
    } catch (e) {
      appLog('Customer Transactions API Error: $e');
      return null;
    }
  }

  Future<CustomerTierModel?> getCustomerTier(String id) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.customerTier(id),
      );

      appLog('Customer Tier API Response - Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          return CustomerTierModel.fromJson(responseBody);
        }
      }
      return null;
    } catch (e) {
      appLog('Customer Tier API Error: $e');
      return null;
    }
  }
}
