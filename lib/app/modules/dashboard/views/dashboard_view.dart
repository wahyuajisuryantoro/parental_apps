import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/widgets/bottom_navigation_bar/custom_navigation_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo-presensimu.png',
          height: AppResponsive.width(context, 13),
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        toolbarHeight: AppResponsive.width(context, 16),
        leading: Padding(
          padding: EdgeInsets.only(
            left: AppResponsive.width(context, 2),
            top: AppResponsive.width(context, 2),
            bottom: AppResponsive.width(context, 2),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.bellOutline, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppResponsive.width(context, 5)),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final anakList = controller.anakList;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppResponsive.height(context, 2.5)),
                  Container(
                    padding: EdgeInsets.all(AppResponsive.width(context, 4)),
                    decoration: BoxDecoration(
                      color: AppColors.blueLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(EvaIcons.calendarOutline,
                                color: AppColors.white),
                            SizedBox(width: AppResponsive.width(context, 2)),
                            Obx(() => Text(
                                  controller.currentDate.value,
                                  style: AppTextStyle.captionWhite,
                                )),
                          ],
                        ),
                        SizedBox(height: AppResponsive.height(context, 1.5)),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assalamualaikum,",
                                style: AppTextStyle.heading2,
                              ),
                              SizedBox(
                                  height: AppResponsive.height(context, 0.5)),
                              Text(
                                "${controller.orangTuaNama.value}",
                                style: AppTextStyle.smallHeading1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppResponsive.height(context, 1.5)),
                        const Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: AppColors.grayLight, thickness: 1)),
                            Icon(EvaIcons.sunOutline,
                                color: AppColors.yellow, size: 16),
                            Expanded(
                                child: Divider(
                                    color: AppColors.grayLight, thickness: 1)),
                          ],
                        ),
                        SizedBox(height: AppResponsive.height(context, 2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed('/pengajuan-absensi'); 
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppResponsive.width(context, 4),
                                  vertical: AppResponsive.height(context, 1.5),
                                ),
                              ),
                              icon: const Icon(EvaIcons.plusCircleOutline,
                                  color: AppColors.blueLight),
                              label: Text(
                                "Pengajuan Absensi",
                                style: AppTextStyle.bodyText
                                    .copyWith(color: AppColors.blueLight),
                              ),
                            ),
                            Column(
                              children: [
                                const Icon(EvaIcons.infoOutline,
                                    color: AppColors.blueLight, size: 30),
                                SizedBox(
                                    height: AppResponsive.height(context, 0.5)),
                                Text(
                                  "Info Terkini",
                                  style: AppTextStyle.captionWhite
                                      .copyWith(color: AppColors.blueLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.height(context, 2)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.height(context, 2)),
                    child: Text(
                      "Menu Utama",
                      style: AppTextStyle.blackHeading2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuIcon(
                        icon: EvaIcons.fileText,
                        label: "Nilai & Raport",
                        onTap: () {
                          // Navigate to Nilai & Raport page
                        },
                      ),
                      _buildMenuIcon(
                        icon: EvaIcons.checkmarkCircle2,
                        label: "Presensi",
                        onTap: () {
                          // Navigate to Presensi page
                        },
                      ),
                      _buildMenuIcon(
                        icon: EvaIcons.clipboard,
                        label: "Catatan",
                        onTap: () {
                          // Navigate to Catatan page
                        },
                      ),
                      _buildMenuIcon(
                        icon: EvaIcons.creditCard,
                        label: "SPP",
                        onTap: () {
                          // Navigate to SPP page
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.height(context, 3)),
                  Text(
                    "Anak Saya",
                    style: AppTextStyle.blackHeading2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueLight,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: anakList.length,
                    itemBuilder: (context, index) {
                      final Anak child = anakList[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/detail-siswa',
                              arguments: {'id': child.id});
                        },
                        onTapDown: (details) =>
                            controller.setScaleDown(index, true),
                        onTapUp: (details) =>
                            controller.setScaleDown(index, false),
                        onTapCancel: () =>
                            controller.setScaleDown(index, false),
                        child: Obx(() => AnimatedScale(
                              scale: controller.getScale(index),
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: AppResponsive.height(context, 1)),
                                padding: EdgeInsets.all(
                                    AppResponsive.width(context, 4)),
                                decoration: BoxDecoration(
                                  color: AppColors.greenLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(child.fotoUrl),
                                          radius:
                                              AppResponsive.width(context, 8),
                                          onBackgroundImageError:
                                              (error, stackTrace) {
                                            const AssetImage(
                                                'assets/images/avatar_placeholder.jpg');
                                          },
                                        ),
                                        SizedBox(
                                            width: AppResponsive.width(
                                                context, 4)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                child.namaSiswa,
                                                style: AppTextStyle.heading2,
                                              ),
                                              Text(
                                                "Kelas: ${child.kelas}",
                                                style:
                                                    AppTextStyle.captionWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: AppResponsive.width(
                                                context, 4)),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: AppColors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            AppResponsive.height(context, 2)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: _buildQuickInfo(
                                              "${child.attendance}% Hadir",
                                              Icons.check_circle,
                                              context,
                                              child.attendance),
                                        ),
                                        SizedBox(
                                            width: AppResponsive.width(
                                                context, 4)),
                                        Expanded(
                                          child: _buildQuickInfo(
                                              "Status: ${child.status}",
                                              Icons.info,
                                              context,
                                              child.attendance),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                  SizedBox(height: AppResponsive.height(context, 3)),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }

  Widget _buildQuickInfo(
      String text, IconData icon, BuildContext context, int attendance) {
    Color backgroundColor;
    Color textColor;

    if (attendance >= 80) {
      backgroundColor = AppColors.blueLight;
      textColor = AppColors.text;
    } else if (attendance >= 50) {
      backgroundColor = AppColors.yellowLight;
      textColor = AppColors.text;
    } else {
      backgroundColor = AppColors.redLight;
      textColor = AppColors.text;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.height(context, 1),
        horizontal: AppResponsive.width(context, 3),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: backgroundColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white),
          SizedBox(width: AppResponsive.width(context, 2)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.captionWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.blueLight, size: 28),
          onPressed: onTap,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
