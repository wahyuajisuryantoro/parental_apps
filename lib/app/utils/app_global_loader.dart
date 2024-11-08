import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/utils/app_text.dart';

class GlobalLoader {
  static bool _isShowing = false;

  static void showLoading(){
    if (!_isShowing) {
      _isShowing = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(AppResponsive.width(Get.context!, 5)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppResponsive.width(Get.context!, 2)),
              ),
              width: AppResponsive.width(Get.context!, 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.blueLight,
                  ),
                  SizedBox(height: AppResponsive.height(Get.context!, 2)),

                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hideLoading() {
    if (_isShowing) {
      _isShowing = false;
      Get.back();
    }
  }
}
