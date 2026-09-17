import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/new_transaction_screen/model/digital_card_model.dart';
import 'package:merchent/screen/new_transaction_screen/model/apply_gift_card_model.dart';
import 'package:merchent/service/repository/promotion_repository/promotion_repository.dart';
import 'package:merchent/service/repository/apply_gift_card_repository.dart';
import 'package:merchent/utils/app_log/app_log.dart';
import 'package:merchent/routes/app_routes.dart';

class NewTransactionController extends GetxController {
  final PromotionRepository _promotionRepository = PromotionRepository();
  final RedeemRepository _redeemRepository = RedeemRepository();

  // Text Controllers
  final TextEditingController cardIdController = TextEditingController();
  final TextEditingController availablePointController =
      TextEditingController();
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController pointRedeemController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isApplyingGiftCard = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<DigitalCard> digitalCard = Rxn<DigitalCard>();
  final RxBool isCardFound = false.obs;
  final RxList<Promotion> selectedPromotions = <Promotion>[].obs;
  final RxDouble grossPoint = 0.0.obs;

  final RxBool isPCcard = false.obs;
  final RxBool isPCcardAndSelectPromotion = false.obs;

  void checkIsPCcard() {
    String text = cardIdController.text.trim().toUpperCase();

    if (text.startsWith('PC')) {
      isPCcard.value = true;
    } else {
      isPCcard.value = false;
    }
  }

  // Additional Controller for Gross Point Display
  final TextEditingController grossPointController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Set default values
    availablePointController.text = '0.00';
    grossPointController.text = '0.00';
    billAmountController.text = '';
    pointRedeemController.text = '';

    // Check if card code was passed from QR scanner
    _checkForScannedCode();
  }

  /// Check for scanned card code from arguments and auto-trigger API
  void _checkForScannedCode() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final String? cardCode = arguments['cardCode'];
      if (cardCode != null && cardCode.isNotEmpty) {
        cardIdController.text = cardCode;
        checkIsPCcard();
        // Auto-trigger the find promotion API
        Future.delayed(const Duration(milliseconds: 300), () {
          findPromotion();
        });
      }
    }
  }

  /// Find promotion by card code
  Future<void> findPromotion() async {
    final String cardCode = cardIdController.text.trim();

    if (cardCode.isEmpty) {
      errorMessage.value = 'Please enter a card ID';
      Get.snackbar(
        'Error',
        'Please enter a card ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      isCardFound.value = false;
      selectedPromotions.clear();
      grossPoint.value = 0.0;
      grossPointController.text = '0.00';

      checkIsPCcard();

      appLog('Finding promotion for card code: $cardCode');

      final DigitalCardResponse? response = await _promotionRepository
          .findPromotionByCardCode(cardCode: cardCode);

      if (response != null &&
          response.success &&
          response.data?.digitalCard != null) {
        digitalCard.value = response.data!.digitalCard;
        isCardFound.value = true;

        // Update available points
        availablePointController.text =
            (digitalCard.value?.availablePoints ?? 0).toStringAsFixed(2);

        appLog('Card found: ${digitalCard.value!.cardCode}');
        appLog('Available Points: ${digitalCard.value!.availablePoints}');
        appLog('Promotions: ${digitalCard.value!.promotions.length}');

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        digitalCard.value = null;
        isCardFound.value = false;
        availablePointController.text = '0.00';
        errorMessage.value =
            _promotionRepository.errorMessage ?? 'Card not found';

        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Error finding promotion: $e');
      errorMessage.value = e.toString();
      digitalCard.value = null;
      isCardFound.value = false;
      availablePointController.text = '0.00';

      Get.snackbar(
        'Error',
        'Failed to find card: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get active promotions from the digital card
  List<Promotion> get activePromotions {
    return digitalCard.value?.promotions
            .where((promo) => promo.isActive)
            .toList() ??
        [];
  }

  /// Toggle selection of a promotion
  void selectPromotion(Promotion promotion) {
    if (selectedPromotions.any((p) => p.id == promotion.id)) {
      selectedPromotions.removeWhere((p) => p.id == promotion.id);
    } else {
      selectedPromotions.add(promotion);
    }

    // Calculate total gross points
    double total = 0.0;
    for (var promo in selectedPromotions) {
      total += (promo.grossValue ?? 0.0);
    }
    grossPoint.value = total;
    grossPointController.text = total.toStringAsFixed(2);
  }


  double? discountAmount;

  Future<void> applyGiftCards() async {
    try {
      // Validate card code
      final String cardCode = cardIdController.text.trim();
      if (cardCode.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter a card code first',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      

      // Validate bill amount
      final String billAmountText = billAmountController.text.trim();
      if (billAmountText.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter bill amount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      double? initialTotalBill = double.tryParse(billAmountText);
      if (initialTotalBill == null || initialTotalBill <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid bill amount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Parse point redeem (optional)
      double? pointRedeemed;
      final String pointRedeemText = pointRedeemController.text.trim();
      if (pointRedeemText.isNotEmpty) {
        pointRedeemed = double.tryParse(pointRedeemText);
        if (pointRedeemed == null || pointRedeemed < 0) {
          Get.snackbar(
            'Error',
            'Please enter a valid point redemption value (minimum 0)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }

        // Validate against available points
        final double availablePoints = digitalCard.value?.availablePoints ?? 0;
        if (pointRedeemed > availablePoints) {
          Get.snackbar(
            'Error',
            'Point redemption value cannot exceed available points (${availablePoints.toStringAsFixed(2)})',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }

        // Validate against total bill
        if (pointRedeemed > initialTotalBill) {
          Get.snackbar(
            'Error',
            'Point redemption value cannot exceed total bill amount (${initialTotalBill.toStringAsFixed(2)})',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
      }

      isApplyingGiftCard.value = true;

      final RedeemRequestModel requestModel = RedeemRequestModel(
        digitalCardCode: cardCode,
        promotionIds: selectedPromotions.map((e) => e.id).toList(),
        totalBill: initialTotalBill,
        pointRedeemed: pointRedeemed,
      );

      final bool success = await _redeemRepository.redeemPoints(requestModel);

      isApplyingGiftCard.value = false;

      if (success) {
        final responseData = _redeemRepository.responseData;
        if (responseData != null) {
          Get.snackbar(
            'Success',
            _redeemRepository.successMessage ??
                'Gift cards applied successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          Get.toNamed(
            AppRoutes.totalSummaryScreen,
            arguments: {
              'totalBill': responseData['totalBill'],
              'totalDiscount': (responseData['totalDiscount'] ?? 0).toDouble(),
              'discountedBill': (responseData['discountedBill'] ?? 0)
                  .toDouble(),
              'finalBill': (responseData['finalBill'] ?? 0).toDouble(),
              'pointRedeemed': (responseData['pointRedeemed'] ?? 0).toDouble(),
              'pointDiscount': (responseData['pointDiscount'] ?? 0).toDouble(),
              'pointsEarned': (responseData['pointsEarned'] ?? 0).toDouble(),
              'digitalCardCode': responseData['digitalCardCode'],
              'promotionIds': responseData['appliedPromotionIds'] ?? [],
              'discountPercentage': responseData['discountPercentage'] ?? 0,
            },
          );
          appLog("Points Earned from server: ${responseData['pointsEarned']}");
        } else {
          Get.snackbar(
            'Error',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          _redeemRepository.errorMessage ?? 'Failed to apply gift cards',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isApplyingGiftCard.value = false;
      appLog('Error applying gift card: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Reset the form
  void resetForm() {
    cardIdController.clear();
    availablePointController.text = '0.00';
    grossPointController.text = '0.00';
    billAmountController.clear();
    pointRedeemController.clear();
    digitalCard.value = null;
    isCardFound.value = false;
    selectedPromotions.clear();
    grossPoint.value = 0.0;
    errorMessage.value = '';
    isPCcard.value = false;
  }

  @override
  void onClose() {
    cardIdController.dispose();
    availablePointController.dispose();
    billAmountController.dispose();
    pointRedeemController.dispose();
    grossPointController.dispose();
    super.onClose();
  }
}
