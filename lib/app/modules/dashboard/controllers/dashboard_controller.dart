import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/service/api_service.dart';

class DashboardController extends GetxController {
  var orangTuaNama = ''.obs;
  var anakList = <Anak>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    try {
      final storage = GetStorage();
      final orangTuaIdString = storage.read('orang_tua_id')?.toString();

      // Tambahkan konversi tipe data
      final orangTuaId = int.tryParse(orangTuaIdString ?? '');

      if (orangTuaId != null) {
        // Ambil data orang tua
        final orangTua = await ApiService.fetchOrangTua(orangTuaId);
        orangTuaNama.value = orangTua.nama;

        // Ambil data anak
        final anakData = await ApiService.fetchAnak(orangTuaId);
        anakList.assignAll(anakData);
      } else {
        // Tangani jika orangTuaId tidak valid
        Get.snackbar('Error', 'Orang Tua ID tidak valid');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
