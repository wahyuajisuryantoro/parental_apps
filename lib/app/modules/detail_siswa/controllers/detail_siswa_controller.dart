import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:parental_apps/app/model/model_anak.dart';

class DetailSiswaController extends GetxController {
  var siswa = Rx<Anak?>(null);
  var isLoading = true.obs;

  Future<void> getSiswaDetail(String id) async {
    isLoading.value = true;
    final url = 'http://mi-paremono.presensimu.com/api/get_siswa_detail/$id';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          siswa.value = Anak.fromJson(data['data']);
        } else {
          Get.snackbar('Error', 'Data siswa tidak ditemukan');
        }
      } else {
        Get.snackbar('Error', 'Gagal mengambil data siswa');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
