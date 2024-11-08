import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:parental_apps/app/model/model_presensi.dart';

enum AttendanceStatus { hadir, izin, sakit }

class AbsensiController extends GetxController {
  var attendanceData = RxMap<DateTime, AttendanceStatus>();
  final idSiswa = 0.obs;

  final String baseUrl = 'http://mi-paremono.presensimu.com/api/get_presensi_siswa';

  @override
  void onInit() {
    super.onInit();
    idSiswa.value = Get.arguments?['id_siswa'] ?? 0;
    print('Received id_siswa: ${idSiswa.value}'); // Debug to confirm id_siswa
    if (idSiswa.value != 0) {
      fetchPresensiByIdSiswa(idSiswa.value);
    } else {
      print('Error: id_siswa is 0');
    }
  }

  DateTime normalizeDateTime(String dateStr) {
    List<String> parts = dateStr.split(' / ');
    if (parts.length != 3) {
      print('Invalid date format: $dateStr');
      return DateTime.now();
    }
    try {
      int day = int.parse(parts[0].trim());
      int month = int.parse(parts[1].trim());
      int year = 2000 + int.parse(parts[2].trim());
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date components: $e');
      return DateTime.now();
    }
  }

  Future<void> fetchPresensiByIdSiswa(int idSiswa) async {
    final url = Uri.parse(baseUrl);
    try {
      // Mengirimkan request POST dengan id_siswa di body
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_siswa': idSiswa}),
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          List<dynamic> data = jsonResponse['data'];
          print('Found ${data.length} attendance records');

          attendanceData.clear();

          for (var item in data) {
            try {
              DateTime date = normalizeDateTime(item['tanggal']);
              String keterangan = item['keterangan'].toString().toLowerCase().trim();

              print('Processing date: $date, keterangan: $keterangan');

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
                print('Stored attendance for $date: $status');
              } else {
                print('Invalid keterangan: $keterangan');
              }
            } catch (e) {
              print('Error processing record: $e');
              print('Record: $item');
            }
          }

          print('Final attendance data:');
          attendanceData.forEach((key, value) {
            print('Date: $key, Status: $value');
          });

          attendanceData.refresh();
          update();
        } else {
          print('API returned error status: ${jsonResponse['status']}');
          print('API error message: ${jsonResponse['message']}');
          Get.snackbar('Error', jsonResponse['message'] ?? 'Unknown error');
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Network or parsing error: $e');
    }
  }
}
