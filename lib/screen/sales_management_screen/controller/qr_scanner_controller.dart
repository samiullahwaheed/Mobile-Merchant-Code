import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController extends GetxController {
  late MobileScannerController scannerController;

  final RxBool isFlashOn = false.obs;
  final RxBool isFrontCamera = false.obs;
  final RxBool isScanning = true.obs;
  final RxString scannedCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  /// Toggle flash on/off
  void toggleFlash() {
    scannerController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  /// Switch between front and back camera
  void switchCamera() {
    scannerController.switchCamera();
    isFrontCamera.value = !isFrontCamera.value;
  }

  /// Handle barcode detection
  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      isScanning.value = false;
      scannedCode.value = code;

      debugPrint('QR Code Scanned: $code');

      // Navigate back with the scanned code
      Get.back(result: code);
    }
  }

  /// Resume scanning
  void resumeScanning() {
    isScanning.value = true;
    scannedCode.value = '';
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
