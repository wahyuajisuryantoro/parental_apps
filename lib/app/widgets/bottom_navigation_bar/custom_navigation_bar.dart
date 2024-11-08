import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/widgets/bottom_navigation_bar/controller/navigation_controller.dart';
import 'package:parental_apps/app/modules/dashboard/controllers/dashboard_controller.dart';

class CustomNavigationBar extends StatelessWidget {
  // Dapatkan instance dari NavigationController
  final NavigationController navigationController = Get.find();
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppResponsive.width(context, 3),
        right: AppResponsive.width(context, 3),
        bottom: AppResponsive.height(context, 2),
      ),
      child: Container(
        padding: EdgeInsets.all(AppResponsive.width(context, 3)),
        decoration: BoxDecoration(
          color: AppColors.blueLight,
          borderRadius: BorderRadius.circular(AppResponsive.width(context, 8)),
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: (index) {
              if (index == 1) {
                // Kirim `id_siswa` dari dashboard saat membuka halaman absensi
                int? idSiswa = dashboardController.anakList.isNotEmpty 
                    ? dashboardController.anakList[0].id // Pilih ID anak pertama atau logika lain
                    : null;
                navigationController.changePage(index, idSiswa: idSiswa);
              } else {
                navigationController.changePage(index);
              }
            },
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.grayLight,
            showUnselectedLabels: true,
            selectedLabelStyle:
                AppTextStyle.caption.copyWith(color: AppColors.white),
            unselectedLabelStyle: AppTextStyle.caption,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              _buildNavItem(
                context,
                icon: EvaIcons.homeOutline,
                label: "Beranda",             
                index: 0,
              ),
              _buildNavItem(
                context,
                icon: EvaIcons.bookOutline,     
                label: "Absensi",               
                index: 1,
              ),
              _buildNavItem(
                context,
                icon: EvaIcons.personOutline,
                label: "Profil",
                index: 2,
              ),
              _buildNavItem(
                context,
                icon: EvaIcons.logInOutline,
                label: "Login",
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: navigationController.currentIndex.value == index
          ? Container(
              padding: EdgeInsets.all(AppResponsive.width(context, 1.5)),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.blueLight,
                size: AppResponsive.width(context, 5),
              ),
            )
          : Icon(
              icon,
              size: AppResponsive.width(context, 5),
            ),
      label: label,
    );
  }
}
