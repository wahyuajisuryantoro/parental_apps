import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_text.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: AppColors.textSecondary,
      items: [
        
        BottomNavigationBarItem(
          icon: Icon(
            EvaIcons.homeOutline,
            size: iconSize,
          ),
          label: "Beranda",
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            EvaIcons.calendarOutline,
            size: iconSize,
          ),
          label: "Absensi",
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            EvaIcons.bellOutline,
            size: iconSize,
          ),
          label: "Pengumuman",
        ),
        
        BottomNavigationBarItem(
          icon: Icon(
            EvaIcons.personOutline,
            size: iconSize,
          ),
          label: "Profil",
        ),
      ],
      selectedLabelStyle: AppTextStyle.caption,
      unselectedLabelStyle: AppTextStyle.caption,
      type: BottomNavigationBarType.fixed,
    );
  }
}
