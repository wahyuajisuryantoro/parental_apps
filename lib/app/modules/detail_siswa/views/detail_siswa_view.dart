import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import '../controllers/detail_siswa_controller.dart';

class DetailSiswaView extends GetView<DetailSiswaController> {
  const DetailSiswaView({super.key});

  @override
  Widget build(BuildContext context) {
    final int siswaId = Get.arguments['id'];
    controller.getSiswaDetail(siswaId.toString());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Detail Siswa", style: AppTextStyle.heading2),
        backgroundColor: AppColors.blueLight,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final siswa = controller.siswa.value;
        if (siswa == null) {
          return Center(child: Text("Data siswa tidak ditemukan."));
        }
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: AppResponsive.height(context, 13),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(85),
                      bottomRight: Radius.circular(85),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -AppResponsive.height(context, 7),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(siswa.fotoUrl),
                    radius: AppResponsive.width(context, 15),
                    backgroundColor: AppColors.grayLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.height(context, 8)),
            Center(
              child: Column(
                children: [
                  Text(
                    siswa.namaSiswa,
                    style: AppTextStyle.heading1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppResponsive.height(context, 1)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppResponsive.height(context, 1),
                      horizontal: AppResponsive.width(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Kelas: ${siswa.kelas}",
                      style: AppTextStyle.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppResponsive.height(context, 3)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.width(context, 4)),
                children: [
                  _buildInfoCard(
                    context,
                    "Informasi Pribadi",
                    [
                      _buildInfoRow(
                        icon: EvaIcons.personOutline,
                        label: "NISN",
                        value: siswa.nisn,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.calendarOutline,
                        label: "Tanggal Lahir",
                        value: siswa.tanggalLahir,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.pinOutline,
                        label: "Alamat",
                        value: siswa.alamat,
                        context: context,
                      ),
                    ],
                  ),
                  _buildInfoCard(
                    context,
                    "Informasi Orang Tua",
                    [
                      _buildInfoRow(
                        icon: EvaIcons.peopleOutline,
                        label: "Nama Ayah",
                        value: siswa.namaAyah,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.briefcaseOutline,
                        label: "Pekerjaan Ayah",
                        value: siswa.pekerjaanAyah,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.peopleOutline,
                        label: "Nama Ibu",
                        value: siswa.namaIbu,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.briefcaseOutline,
                        label: "Pekerjaan Ibu",
                        value: siswa.pekerjaanIbu,
                        context: context,
                      ),
                    ],
                  ),
                  _buildInfoCard(
                    context,
                    "Info Lainnya",
                    [
                      _buildInfoRow(
                        icon: EvaIcons.heartOutline,
                        label: "Tempat Lahir",
                        value: siswa.tempatLahir,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.gridOutline,
                        label: "RFID",
                        value: siswa.rfid,
                        context: context,
                      ),
                      _buildInfoRow(
                        icon: EvaIcons.archiveOutline,
                        label: "No. KK",
                        value: siswa.noKk,
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppResponsive.height(context, 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppResponsive.width(context, 1)),
            decoration: BoxDecoration(
              color: AppColors.blueLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.blueLight, size: 20),
          ),
          SizedBox(width: AppResponsive.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$label:", style: AppTextStyle.bodyTextBlack),
                SizedBox(height: AppResponsive.height(context, 0.5)),
                Text(
                  value,
                  style: AppTextStyle.bodyTextBlack,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.visible, 
                  softWrap:
                      true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> infoRows) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppResponsive.height(context, 1)),
      child: Card(
        color: AppColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(0.15),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(AppResponsive.width(context, 3)),
              child: Text(
                title,
                style: AppTextStyle.blackHeading2,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.height(context, 1),
                horizontal: AppResponsive.width(context, 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: infoRows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
