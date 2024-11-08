import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:parental_apps/app/utils/app_global_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parental_apps/app/utils/app_global_alerts.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanAbsensiController extends GetxController {
  final keteranganController = TextEditingController();
  final tanggalMulaiController = TextEditingController();
  final tanggalSelesaiController = TextEditingController();

  // Variabel untuk menyimpan informasi file
  RxString jenisIzin = ''.obs;
  final List<String> jenisIzinOptions = ['Izin Sakit', 'Izin Pribadi', 'Izin Acara Keluarga'];
  
  // Mengubah deklarasi file variables menjadi Rx
  final Rxn<File> fotoFile = Rxn<File>();
  final Rxn<File> dokumenFile = Rxn<File>();

  String? authToken;

  @override
  void onInit() {
    super.onInit();
    _loadAuthToken();
    jenisIzin.value = '';
    fotoFile.value = null;
    dokumenFile.value = null;
  }

  static const int maxFileSizeKB = 6144;

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token');
  }

  Future<bool> requestGalleryPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        return true;
      } else if (await Permission.photos.request().isGranted) {
        return true;
      }

      if (Platform.isAndroid && Platform.version.compareTo('33') < 0) {
        if (await Permission.storage.isGranted) {
          return true;
        } else {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            return true;
          }
        }
      }
    }

    GlobalAlerts.showErrorAlert(
      title: 'Akses Ditolak',
      message: 'Aplikasi memerlukan izin untuk mengakses galeri.',
    );
    return false;
  }

  Future<bool> requestFilePermission() async {
    if (Platform.isAndroid && await Permission.manageExternalStorage.isGranted) {
      return true;
    } else if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      } else {
        GlobalAlerts.showErrorAlert(
          title: 'Akses Ditolak',
          message: 'Aplikasi memerlukan izin untuk mengakses file manager.',
        );
        return false;
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else {
        GlobalAlerts.showErrorAlert(
          title: 'Akses Ditolak',
          message: 'Aplikasi memerlukan izin untuk mengakses file manager.',
        );
        return false;
      }
    }
  }

   Future<void> pickFoto() async {
    if (await requestGalleryPermission()) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (_validateFile(file, ['jpg', 'jpeg', 'png'])) {
          fotoFile.value = file;  // Menggunakan fotoFile.value untuk mengubah nilai
        }
      }
    }
  }

  Future<void> pickDokumen() async {
    if (await requestFilePermission()) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (_validateFile(file, ['pdf', 'doc', 'docx'])) {
          dokumenFile.value = file;  // Menggunakan dokumenFile.value untuk mengubah nilai
        }
      }
    }
  }

  bool _validateFile(File file, List<String> allowedExtensions) {
    final fileSizeKB = file.lengthSync() / 1024;
    final fileExtension = extension(file.path).toLowerCase().replaceAll('.', '');

    if (fileSizeKB > maxFileSizeKB) {
      GlobalAlerts.showErrorAlert(
        title: 'Error',
        message: 'Ukuran file tidak boleh lebih dari 6 MB',
      );
      return false;
    }

    if (!allowedExtensions.contains(fileExtension)) {
      GlobalAlerts.showErrorAlert(
        title: 'Error',
        message:
            'Format file tidak didukung. Format yang diperbolehkan: ${allowedExtensions.join(', ')}',
      );
      return false;
    }

    return true;
  }

  Future<void> submitPengajuanAbsensi() async {
  if (authToken == null) {
    GlobalAlerts.showErrorAlert(
      title: 'Error',
      message: 'Silahkan login terlebih dahulu',
    );
    return;
  }

  final tanggalMulai = tanggalMulaiController.text;
  final tanggalSelesai = tanggalSelesaiController.text;
  final selectedJenisIzin = jenisIzin.value;

  // Validate input fields
  if (tanggalMulai.isEmpty || tanggalSelesai.isEmpty || selectedJenisIzin.isEmpty) {
    GlobalAlerts.showErrorAlert(
      title: 'Error',
      message: 'Tanggal mulai, tanggal selesai, dan jenis izin harus diisi',
    );
    return;
  }

  try {
    GlobalLoader.showLoading(); // Show loader when starting request

    final uri = Uri.parse('http://mi-paremono.presensimu.com/api/post_pengajuan_absensi');
    final request = http.MultipartRequest('POST', uri);

    // Authorization header
    request.headers['Authorization'] = 'Bearer $authToken';

    // Add fields
    request.fields['keterangan'] = keteranganController.text;
    request.fields['tanggal_mulai'] = tanggalMulai;
    request.fields['tanggal_selesai'] = tanggalSelesai;
    request.fields['jenis_izin'] = selectedJenisIzin;

    // Add photo if selected, otherwise send an empty field
    if (fotoFile.value != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto',
        fotoFile.value!.path,
        filename: basename(fotoFile.value!.path),
      ));
    } else {
      request.fields['foto'] = '';
    }

    // Add document if selected, otherwise send an empty field
    if (dokumenFile.value != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'dokumen',
        dokumenFile.value!.path,
        filename: basename(dokumenFile.value!.path),
      ));
    } else {
      request.fields['dokumen'] = '';
    }

    print("Sending request with data:");
    print("Headers: ${request.headers}");
    print("Fields: ${request.fields}");

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    print("Response status: ${response.statusCode}");
    print("Response body: $responseData");

    final result = json.decode(responseData);

    GlobalLoader.hideLoading(); // Hide loader when request completes

    if (response.statusCode == 401) {
      GlobalAlerts.showErrorAlert(
        title: 'Error',
        message: 'Sesi anda telah berakhir, silahkan login kembali',
      );
      return;
    }

    if (response.statusCode == 200 && result['status'] == 'success') {
      GlobalAlerts.showSuccessAlert(
        title: 'Success',
        message: result['message'] ?? 'Pengajuan absensi berhasil diajukan',
      );
      _resetForm();
    } else {
      GlobalAlerts.showErrorAlert(
        title: 'Error',
        message: result['message'] ?? 'Pengajuan absensi gagal',
      );
    }
  } catch (e) {
    GlobalLoader.hideLoading(); 
    print("Error during submission: $e");
    GlobalAlerts.showErrorAlert(
      title: 'Error',
      message: 'Terjadi kesalahan saat mengirim pengajuan: $e',
    );
  }
}


  // Menambahkan method untuk reset form
  void _resetForm() {
    keteranganController.clear();
    tanggalMulaiController.clear();
    tanggalSelesaiController.clear();
    jenisIzin.value = '';
    fotoFile.value = null;
    dokumenFile.value = null;
  }

  @override
  void onClose() {
    keteranganController.dispose();
    tanggalMulaiController.dispose();
    tanggalSelesaiController.dispose();
    super.onClose();
  }

}
