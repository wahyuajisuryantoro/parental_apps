import 'package:get/get.dart';

import '../controllers/pengajuan_absensi_controller.dart';

class PengajuanAbsensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengajuanAbsensiController>(
      () => PengajuanAbsensiController(),
    );
  }
}
