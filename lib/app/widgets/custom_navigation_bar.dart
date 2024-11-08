import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.iconSize = 24.0,
  });

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
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
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
              icon: EvaIcons.calendarOutline,
              label: "Absensi",
              index: 1,
            ),
            _buildNavItem(
              context,
              icon: EvaIcons.messageCircleOutline,
              label: "Obrolan",
              index: 2,
            ),
            _buildNavItem(
              context,
              icon: EvaIcons.personOutline,
              label: "Profil",
              index: 3,
            ),
          ],
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
      icon: currentIndex == index
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
