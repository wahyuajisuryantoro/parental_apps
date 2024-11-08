import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/model/model_presensi.dart';

enum AttendanceStatus { hadir, izin, sakit }

class AbsensiController extends GetxController {
  var attendanceData = RxMap<DateTime, AttendanceStatus>();
  final idSiswa = 0.obs;
  Rx<Anak?> anak = Rx<Anak?>(null);
  final String baseUrl = 'http://mi-paremono.presensimu.com/api';

  @override
  void onInit() {
    super.onInit();
    // Ambil id_siswa dari Get.arguments yang diterima melalui NavigationController
    idSiswa.value = Get.arguments?['id_siswa'] ?? 0;

    if (idSiswa.value != 0) {
      fetchSiswaDetail(idSiswa.value); // Panggil endpoint detail siswa
      fetchPresensiByIdSiswa(idSiswa.value); // Ambil data presensi siswa
    } else {
      print("Error: id_siswa tidak ditemukan di arguments.");
    }
  }

  // Ambil detail siswa menggunakan endpoint get_siswa_detail
  Future<void> fetchSiswaDetail(int idSiswa) async {
    final url = Uri.parse('$baseUrl/get_siswa_detail/$idSiswa');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          anak.value = Anak.fromJson(data['data']);
          print('Data anak berhasil diambil: ${anak.value?.namaSiswa}');
        } else {
          print("Error fetching siswa detail: ${data['message']}");
        }
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching siswa detail: $e");
    }
  }

  // Ambil data presensi siswa berdasarkan id_siswa
  Future<void> fetchPresensiByIdSiswa(int idSiswa) async {
    final url = Uri.parse('$baseUrl/get_presensi_siswa');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_siswa': idSiswa}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          List<dynamic> data = jsonResponse['data'];
          attendanceData.clear();
          for (var item in data) {
            DateTime date = DateFormat('dd / MM / yy').parse(item['tanggal']);
            String keterangan = item['keterangan'].toString().toLowerCase().trim();
            AttendanceStatus? status;
            if (keterangan == 'hadir') {
              status = AttendanceStatus.hadir;
            } else if (keterangan == 'izin') {
              status = AttendanceStatus.izin;
            } else if (keterangan == 'sakit') {
              status = AttendanceStatus.sakit;
            }
            if (status != null) {
              attendanceData[date] = status;
            }
          }
          attendanceData.refresh();
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching presensi: $e');
    }
  }
}
