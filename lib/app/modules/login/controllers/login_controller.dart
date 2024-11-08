import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parental_apps/app/utils/app_global_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parental_apps/app/routes/app_pages.dart';
import 'package:parental_apps/app/utils/app_global_alerts.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Simpan sesi saat login berhasil
  Future<void> saveSession(String? token, Map<String, dynamic> userInfo) async {
    if (token == null || token.isEmpty) return;

    SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = int.tryParse(userInfo['id'].toString()) ?? 0;
    await pref.setString('token', token);
    await pref.setInt('user_id', userId);
    await pref.setString('username', userInfo['username']);
    await pref.setString('email', userInfo['email']);
    await pref.setString('nama', userInfo['nama']);
  }

  // Fungsi untuk mendapatkan sesi dan halaman terakhir yang dikunjungi
  Future<void> checkSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(
          Routes.DASHBOARD);
    } else {
      Get.offAllNamed(
          Routes.LOGIN);
    }
  }

  // Fungsi Login
  Future<void> login() async {
    final url = Uri.parse("http://mi-paremono.presensimu.com/api/login");

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      GlobalAlerts.showErrorAlert(
          title: "Error", message: "Kolom harus diisi semua");
      return;
    }

    GlobalLoader.showLoading();
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "username": usernameController.text.trim(),
          "password": passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success' && result['data'] != null) {
          final token = result['data']['token'];
          if (token != null && token.isNotEmpty) {
            await saveSession(token, result['data']);
            await saveLastVisitedPage(Routes.DASHBOARD);
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            GlobalAlerts.showErrorAlert(
                title: "Error",
                message: "Token tidak ditemukan dalam response.");
          }
        } else {
          GlobalAlerts.showErrorAlert(
              title: "Login Gagal",
              message: result['message'] ?? 'Username atau password salah.');
        }
      } else {
        GlobalAlerts.showErrorAlert(
            title: "Error",
            message:
                "Gagal terhubung ke server. Status code: ${response.statusCode}");
      }
    } catch (e) {
      GlobalAlerts.showErrorAlert(
          title: "Error", message: "Terjadi kesalahan. Silakan coba lagi.");
    } finally {
      GlobalLoader.hideLoading();
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  // Fungsi untuk menyimpan halaman terakhir yang dikunjungi
  Future<void> saveLastVisitedPage(String route) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('last_visited_page', route);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
