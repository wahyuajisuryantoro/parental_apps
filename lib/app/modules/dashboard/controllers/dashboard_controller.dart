import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/model/model_orang_tua.dart';
import 'package:parental_apps/app/model/model_presensi.dart';

class DashboardController extends GetxController {
  var orangTuaNama = ''.obs;
  var anakList = <Anak>[].obs;
  var isLoading = true.obs;
  var currentDate = ''.obs; // Observable untuk tanggal
  var greeting = ''.obs; // Observable untuk sapaan
  var scales = <RxDouble>[].obs; 

  static const String baseUrl = 'http://mi-paremono.presensimu.com/api';

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    updateDateAndGreeting();
    scales.addAll(List.generate(anakList.length, (_) => 1.0.obs));
  }

  void setScaleDown(int index, bool isDown) {
    if (index < scales.length) {
      scales[index].value = isDown ? 0.95 : 1.0;
    }
  }

  double getScale(int index) {
    return index < scales.length ? scales[index].value : 1.0;
  }

  void updateDateAndGreeting() {
    currentDate.value = getCurrentDate();
    greeting.value = getGreeting();
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM', 'id');
    return formatter.format(now);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  void saveOrangTuaId(int orangTuaId) {
    final storage = GetStorage();
    storage.write('orangTuaId', orangTuaId);
  }

  void fetchDashboardData() async {
    try {
      final storage = GetStorage();
      final orangTuaIdString = storage.read('orang_tua_id')?.toString();
      final orangTuaId = int.tryParse(orangTuaIdString ?? '');

      if (orangTuaId != null) {
        final orangTua = await fetchOrangTua(orangTuaId);
        orangTuaNama.value = orangTua.nama;

        final anakData = await fetchAnak(orangTuaId);
        anakList.assignAll(anakData);
        for (var child in anakList) {
          await updatePresensiStatus(child);
        }
      } else {
        Get.snackbar('Error', 'Orang Tua ID tidak valid');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengambil data orang tua
  Future<OrangTua> fetchOrangTua(int orangTuaId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_orang_tua'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'orang_tua_id': orangTuaId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return OrangTua.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal mengambil data orang tua');
    }
  }

  // Fungsi untuk mengambil data anak berdasarkan orang tua
  Future<List<Anak>> fetchAnak(int orangTuaId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_anak'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'orang_tua_id': orangTuaId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> anakJson = data['data'];
        return anakJson.map((json) => Anak.fromJson(json)).toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal mengambil data anak');
    }
  }

  Future<void> updatePresensiStatus(Anak child) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_presensi_siswa'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_siswa': child.id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> presensiData = data['data'];
        int hadir = 0, izin = 0, sakit = 0;
        List<Presensi> presensiList =
            presensiData.map((entry) => Presensi.fromJson(entry)).toList();

        // Hitung kehadiran per bulan
        for (var presensi in presensiList) {
          switch (presensi.keterangan) {
            case 'Hadir':
              hadir++;
              break;
            case 'Izin':
              izin++;
              break;
            case 'Sakit':
              sakit++;
              break;
          }
        }

        // Menghitung persentase kehadiran
        int total = hadir + izin + sakit;
        child.attendance = total > 0 ? ((hadir / total) * 100).round() : 0;
        child.status = presensiList.isNotEmpty
            ? presensiList.last.keterangan
            : 'Tidak Diketahui';

        // Menghitung waktu terakhir presensi
        if (presensiList.isNotEmpty) {
          child.lastPresensiTimeAgo = calculateTimeAgo(presensiList.last.waktu);
        } else {
          child.lastPresensiTimeAgo = 'Tidak ada data';
        }

        anakList.refresh();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal mengambil data presensi');
    }
  }

// Fungsi untuk menghitung waktu yang telah berlalu dari waktu presensi
  String calculateTimeAgo(DateTime waktuPresensi) {
    Duration difference = DateTime.now().difference(waktuPresensi);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
