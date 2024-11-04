import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAlerts {
  // Alert sukses
  static void showSuccessAlert({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Alert error
  static void showErrorAlert({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
