import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/pengajuan_absensi_controller.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:parental_apps/app/utils/app_text.dart';

class PengajuanAbsensiView extends GetView<PengajuanAbsensiController> {
  const PengajuanAbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    final PengajuanAbsensiController controller =
        Get.put(PengajuanAbsensiController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Pengajuan Absensi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: AppResponsive.width(context, 5),
            ),
          ),
        ),
        backgroundColor: AppColors.blueLight,
        toolbarHeight: AppResponsive.height(context, 10),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.width(context, 5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(controller.keteranganController, "Keterangan"),
              SizedBox(height: AppResponsive.height(context, 2)),

              // Dropdown for "Jenis Izin" with TextField Display
              Text("Jenis Izin", style: AppTextStyle.caption),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grayLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.jenisIzin.value.isEmpty
                        ? null
                        : controller.jenisIzin.value,
                    hint: Text("Pilih Jenis Izin", style: AppTextStyle.caption),
                    items: controller.jenisIzinOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: AppTextStyle.bodyTextBlack),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.jenisIzin.value = value;
                        print(
                            "Jenis Izin terpilih: ${controller.jenisIzin.value}"); // Debug untuk cek nilai terpilih
                      }
                    },
                    underline: Container(),
                    icon: Icon(EvaIcons.arrowDownOutline,
                        color: AppColors.blueLight),
                  ),
                ),
              ),

              SizedBox(height: AppResponsive.height(context, 2)),

              // Date Picker for "Tanggal Mulai"
              _buildSyncfusionDatePicker(
                context,
                label: "Tanggal Mulai",
                controller: controller.tanggalMulaiController,
              ),
              SizedBox(height: AppResponsive.height(context, 2)),

              // Date Picker for "Tanggal Selesai"
              _buildSyncfusionDatePicker(
                context,
                label: "Tanggal Selesai",
                controller: controller.tanggalSelesaiController,
              ),
              SizedBox(height: AppResponsive.height(context, 4)),

              // File upload instructions
              Text(
                "Unggah foto atau dokumen (ukuran max: 6MB, format: jpg, jpeg, png, pdf, doc, docx)",
                style: AppTextStyle.caption.copyWith(color: AppColors.redLight),
              ),
              SizedBox(height: AppResponsive.height(context, 2)),

              // Photo upload section
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickFoto(),
                  child: Container(
                    width: AppResponsive.width(context, 70),
                    height: AppResponsive.height(context, 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.grayLight, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(EvaIcons.fileAddOutline,
                              color: AppColors.blueLight, size: 40),
                          SizedBox(height: AppResponsive.height(context, 1)),
                          Obx(
                            () => Text(
                              controller.fotoFile.value != null
                                  ? 'Foto: ${basename(controller.fotoFile.value!.path)}'
                                  : 'Upload Foto',
                              style: AppTextStyle.caption
                                  .copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.height(context, 4)),

              // Document upload section
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickDokumen(),
                  child: Container(
                    width: AppResponsive.width(context, 70),
                    height: AppResponsive.height(context, 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.grayLight, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(EvaIcons.fileOutline,
                              color: AppColors.blueLight, size: 30),
                          SizedBox(width: AppResponsive.width(context, 2)),
                          Obx(
                            () => Flexible(
                              child: Text(
                                controller.dokumenFile.value != null
                                    ? 'Dokumen: ${basename(controller.dokumenFile.value!.path)}'
                                    : 'Upload Dokumen',
                                style: AppTextStyle.caption
                                    .copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.height(context, 4)),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () => controller.submitPengajuanAbsensi(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      AppResponsive.width(context, 50),
                      AppResponsive.height(context, 6),
                    ),
                    backgroundColor: AppColors.blueLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Kirim Pengajuan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppResponsive.width(context, 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text field widget
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Syncfusion Date picker field widget in Bottom Sheet
  Widget _buildSyncfusionDatePicker(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(AppResponsive.width(context, 5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pilih $label",
                    style: AppTextStyle.blackHeading2,
                  ),
                  SizedBox(height: AppResponsive.height(context, 2)),
                  SizedBox(
                    height: AppResponsive.height(context, 30),
                    child: SfDateRangePicker(
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        controller.text =
                            DateFormat('yyyy-MM-dd').format(args.value);
                        Get.back();
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: DateTime.now(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon:
                Icon(EvaIcons.calendarOutline, color: AppColors.blueLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
