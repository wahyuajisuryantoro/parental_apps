import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/model/model_orang_tua.dart';
import 'package:parental_apps/app/model/model_presensi.dart';

class ApiService {
  static const String baseUrl = 'http://mi-paremono.presensimu.com/api';

  // Fungsi untuk login
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal login');
    }
  }

  // Fungsi untuk mendapatkan data orang tua
  static Future<OrangTua> fetchOrangTua(int orangTuaId) async {
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

  // Fungsi untuk mendapatkan data anak
  static Future<List<Anak>> fetchAnak(int orangTuaId) async {
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

  // Fungsi untuk mendapatkan data presensi berdasarkan orang tua
  static Future<List<Presensi>> fetchPresensiByOrangTua(int orangTuaId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_presensi_orang_tua'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'orang_tua_id': orangTuaId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> presensiJson = data['data'];
        return presensiJson.map((json) => Presensi.fromJson(json)).toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal mengambil data presensi');
    }
  }
}
