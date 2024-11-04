import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parental_apps/app/model/model_anak.dart';
import 'package:parental_apps/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/widgets/custom_navigation_bar.dart';

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
        title: Text("Beranda",
            style: AppTextStyle.heading2.copyWith(color: AppColors.black)),
        centerTitle: true,
        toolbarHeight: AppResponsive.width(context, 16),
        leading: Padding(
          padding: EdgeInsets.only(
            left: AppResponsive.width(context, 2),
            top: AppResponsive.width(context, 2),
            bottom: AppResponsive.width(context, 2),
          ),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/images/avatar1.jpg'),
            radius: AppResponsive.width(context, 20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.black),
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
                          Text("Senin, 12 Sep",
                              style: AppTextStyle.captionWhite),
                          SizedBox(height: AppResponsive.height(context, 1)),
                          Text(
                            "Selamat Pagi, ${controller.orangTuaNama.value}",
                            style: AppTextStyle.smallHeading1,
                          ),
                          SizedBox(height: AppResponsive.height(context, 1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Lihat aktivitas terbaru anak Anda",
                                  style: AppTextStyle.bodyText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Lihat Absensi",
                                  style: AppTextStyle.bodyText
                                      .copyWith(color: AppColors.blueLight),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: AppResponsive.height(context, 3)),
                  Text("Anak Saya", style: AppTextStyle.blackHeading2),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: anakList.length,
                    itemBuilder: (context, index) {
                      final Anak child = anakList[index];
                      final avatarImage = index % 2 == 0
                          ? 'assets/images/avatar2.jpg'
                          : 'assets/images/avatar3.jpg';

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: AppResponsive.height(context, 1)),
                          padding:
                              EdgeInsets.all(AppResponsive.width(context, 4)),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(avatarImage),
                                    radius: AppResponsive.width(context, 8),
                                  ),
                                  SizedBox(
                                      width: AppResponsive.width(context, 4)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.namaSiswa,
                                          style: AppTextStyle.heading2,
                                          // Jangan atur maxLines atau overflow di sini
                                        ),
                                        Text(
                                          "Kelas: ${child.kelas}",
                                          style: AppTextStyle.captionWhite,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: AppResponsive.width(context, 4)),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: AppResponsive.height(context, 2)),
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
                                      width: AppResponsive.width(context, 4)),
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
                      );
                    },
                  ),
                  SizedBox(height: AppResponsive.height(context, 3)),
                  Text("Notifikasi", style: AppTextStyle.blackHeading2),
                  SizedBox(height: AppResponsive.height(context, 2)),
                  Container(
                    padding: EdgeInsets.all(AppResponsive.width(context, 4)),
                    decoration: BoxDecoration(
                      color: AppColors.purpleLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: anakList.map((child) {
                        return ListTile(
                          leading: const Icon(Icons.notifications,
                              color: AppColors.orange),
                          title: Text("Notifikasi untuk ${child.namaSiswa}",
                              style: AppTextStyle.bodyText),
                          subtitle: Text(
                              "Hadir ${child.attendance}% dari kelas bulan ini",
                              style: AppTextStyle.captionWhite),
                          trailing: Text("2 jam lalu",
                              style: AppTextStyle.captionWhite),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
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
}
