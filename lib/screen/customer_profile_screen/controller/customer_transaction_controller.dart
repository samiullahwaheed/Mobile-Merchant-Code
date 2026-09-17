import 'package:get/get.dart';
import 'package:merchent/service/repository/customer_transaction_repository.dart';
import '../model/customer_tier_model.dart';
import '../model/customer_transaction_model.dart';

class CustomerTransactionController extends GetxController {
  final CustomerTransactionRepository _repository =
      CustomerTransactionRepository();
  var isLoading = false.obs;
  var transactionList = <TransactionData>[].obs;
  var tierData = Rxn<TierData>();

  Future<void> fetchTransactions(String customerId) async {
    isLoading.value = true;
    final response = await _repository.getCustomerTransactions(customerId);
    if (response != null && response.data != null) {
      transactionList.value = response.data!;
    }

    final tierResponse = await _repository.getCustomerTier(customerId);
    if (tierResponse != null && tierResponse.data != null) {
      tierData.value = tierResponse.data;
    }
    isLoading.value = false;
  }
}
