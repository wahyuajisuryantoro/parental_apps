import 'package:get/get.dart';
import 'package:parental_apps/app/routes/app_pages.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  final List<String> routes = [
    Routes.DASHBOARD,
    Routes.ABSENSI,
    Routes.LOGIN,
    Routes.PROFILE,
  ];

  void changePage(int index, {int? idSiswa}) {
    currentIndex.value = index;
    if (index == 1 && idSiswa != null) {
      Get.offNamed(routes[index], arguments: {'id_siswa': idSiswa});
    } else {
      Get.offNamed(routes[index]);
    }
  }
}
