import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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

  Future<void> saveSession(String? token, Map<String, dynamic> userInfo) async {
    if (token == null || token.isEmpty) {
      print('Token is null or empty. Cannot save token.');
      return;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    int userId = int.tryParse(userInfo['id'].toString()) ?? 0;
    await pref.setString('token', token);
    await pref.setInt('user_id', userId);
    await pref.setString('username', userInfo['username']);
    await pref.setString('email', userInfo['email']);
    await pref.setString('nama', userInfo['nama']);
    print('Token dan informasi pengguna disimpan.');
  }

  // Fungsi Login
  Future<void> login() async {
    final url = Uri.parse("http://mi-paremono.presensimu.com/api/login");

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      GlobalAlerts.showErrorAlert(
        title: "Error",
        message: "Kolom harus diisi semua",
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": usernameController.text.trim(),
          "password": passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['status'] == 'success' && result['data'] != null) {
          final token = result['data']['token'];

          if (token != null && token.isNotEmpty) {
            await saveSession(token, result['data']);
          } else {
            GlobalAlerts.showErrorAlert(
              title: "Error",
              message: "Token tidak ditemukan dalam response.",
            );
            return;
          }
          final storage = GetStorage();
          storage.write('orang_tua_id', int.tryParse(result['data']['id'].toString()) ?? 0);
          storage.write('orang_tua_nama', result['data']['nama'] ?? 'Pengguna');
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          GlobalAlerts.showErrorAlert(
            title: "Login Gagal",
            message: result['message'] ?? 'Username atau password salah.',
          );
        }
      } else {
        GlobalAlerts.showErrorAlert(
          title: "Error",
          message: "Gagal terhubung ke server. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      GlobalAlerts.showErrorAlert(
        title: "Error",
        message: "Terjadi kesalahan. Silakan coba lagi.",
      );
      print('Error: $e');
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
