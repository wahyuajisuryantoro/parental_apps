import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:parental_apps/app/routes/app_pages.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/widgets/bottom_navigation_bar/controller/navigation_controller.dart';
import 'package:parental_apps/app/widgets/bottom_navigation_bar/custom_navigation_bar.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyle.blackHeading2,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () {
            final navigationController = Get.find<NavigationController>();
            navigationController.currentIndex.value = 0;
            Get.offAllNamed(Routes.DASHBOARD);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'ProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
