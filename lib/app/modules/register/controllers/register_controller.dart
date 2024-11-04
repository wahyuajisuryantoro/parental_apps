import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:parental_apps/app/utils/app_global_alerts.dart';
import 'dart:convert';
import 'package:parental_apps/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode noKKFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noKKController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  Future<void> register() async {
    final url = Uri.parse("http://mi-paremono.presensimu.com/api/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nameController.text,
        "email": emailController.text,
        "no_kk": noKKController.text,
        "telepon": phoneController.text,
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        GlobalAlerts.showSuccessAlert(
          title: "Berhasil",
          message: "Pendaftaran berhasil!",
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        GlobalAlerts.showErrorAlert(
          title: "Error",
          message: result['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        );
      }
    } else {
      GlobalAlerts.showErrorAlert(
        title: "Error",
        message: "Gagal mendaftar. Silakan coba lagi.",
      );
    }
  }
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    noKKController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    noKKFocusNode.dispose();
    phoneFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
