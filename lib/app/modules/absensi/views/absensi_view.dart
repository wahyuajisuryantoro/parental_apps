import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';
import 'package:intl/intl.dart';
import '../controllers/absensi_controller.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusedDay = DateTime.now().obs;

    return Scaffold(
      backgroundColor: AppColors.blueLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Data Absensi Siswa',
          style: AppTextStyle.heading2.copyWith(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppResponsive.width(context, 8)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppResponsive.width(context, 8)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Calendar Widget
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.width(context, 4),
                          vertical: AppResponsive.height(context, 2),
                        ),
                        child: TableCalendar(
                          locale: 'id_ID',
                          firstDay: DateTime.utc(2024, 1, 1),
                          lastDay: DateTime.utc(2024, 12, 31),
                          focusedDay: focusedDay.value,
                          currentDay: DateTime.now(),
                          calendarFormat: CalendarFormat.month,

                          // Header Styling
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: AppTextStyle.blackHeading2,
                            leftChevronIcon: const Icon(Icons.chevron_left,
                                color: AppColors.blueLight),
                            rightChevronIcon: const Icon(Icons.chevron_right,
                                color: AppColors.blueLight),
                          ),

                          // Calendar Style
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: AppTextStyle.caption
                                .copyWith(color: AppColors.redLight),
                            holidayTextStyle: AppTextStyle.caption
                                .copyWith(color: AppColors.redLight),
                            todayDecoration: BoxDecoration(
                              color: AppColors.orange.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: AppColors.blueLight,
                              shape: BoxShape.circle,
                            ),
                          ),

                          // Days of Week Style
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: AppTextStyle.caption.copyWith(
                              fontSize: AppResponsive.width(context, 3.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.blueLight,
                            ),
                            weekendStyle: AppTextStyle.caption.copyWith(
                              fontSize: AppResponsive.width(context, 3.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.redLight,
                            ),
                          ),

                          // Calendar Builders
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              return Obx(() {
                                DateTime normalizedDay =
                                    DateTime(day.year, day.month, day.day);
                                AttendanceStatus? status =
                                    controller.attendanceData[normalizedDay];
                                print(
                                    'Checking day $normalizedDay, status: ${controller.attendanceData[normalizedDay]}');

                                if (status != null) {
                                  return _buildAttendanceMarker(
                                      context, day, status);
                                }

                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: day.weekday >= 6
                                          ? AppColors.redLight
                                          : Colors.black87,
                                      fontSize: AppResponsive.width(context, 4),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),

                          // Calendar Callbacks
                          onPageChanged: (newFocusedDay) {
                            focusedDay.value = newFocusedDay;
                          },
                          selectedDayPredicate: (day) =>
                              isSameDay(day, focusedDay.value),
                          onDaySelected: (selectedDay, newFocusedDay) {
                            focusedDay.value = newFocusedDay;
                          },
                        ),
                      ),

                      // Legend Section
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppResponsive.width(context, 4),
                          vertical: AppResponsive.height(context, 2),
                        ),
                        padding:
                            EdgeInsets.all(AppResponsive.width(context, 4)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                              AppResponsive.width(context, 4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keterangan',
                              style: AppTextStyle.heading2.copyWith(
                                fontSize: AppResponsive.width(context, 4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppResponsive.height(context, 2)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildLegendItem(
                                    context, AppColors.greenLight, "Hadir"),
                                _buildLegendItem(
                                    context, AppColors.yellowLight, "Izin"),
                                _buildLegendItem(
                                    context, AppColors.redLight, "Sakit"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Summary Section
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppResponsive.width(context, 4),
                          vertical: AppResponsive.height(context, 1),
                        ),
                        padding:
                            EdgeInsets.all(AppResponsive.width(context, 4)),
                        decoration: BoxDecoration(
                          color: AppColors.blueLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              AppResponsive.width(context, 4)),
                        ),
                        child: Obx(() {
                          int totalHadir = controller.attendanceData.values
                              .where(
                                  (status) => status == AttendanceStatus.hadir)
                              .length;
                          int totalIzin = controller.attendanceData.values
                              .where(
                                  (status) => status == AttendanceStatus.izin)
                              .length;
                          int totalSakit = controller.attendanceData.values
                              .where(
                                  (status) => status == AttendanceStatus.sakit)
                              .length;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ringkasan Bulan Ini',
                                style: AppTextStyle.heading2.copyWith(
                                  fontSize: AppResponsive.width(context, 4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  height: AppResponsive.height(context, 2)),
                              _buildSummaryItem(context, 'Hadir', totalHadir,
                                  AppColors.greenLight),
                              _buildSummaryItem(context, 'Izin', totalIzin,
                                  AppColors.yellowLight),
                              _buildSummaryItem(context, 'Sakit', totalSakit,
                                  AppColors.redLight),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceMarker(
      BuildContext context, DateTime day, AttendanceStatus status) {
    Color markerColor;
    switch (status) {
      case AttendanceStatus.hadir:
        markerColor = AppColors.greenLight;
        break;
      case AttendanceStatus.izin:
        markerColor = AppColors.yellowLight;
        break;
      case AttendanceStatus.sakit:
        markerColor = AppColors.redLight;
        break;
    }

    return Container(
      margin: EdgeInsets.all(AppResponsive.width(context, 1)),
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: markerColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppResponsive.width(context, 4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: AppResponsive.width(context, 4),
          height: AppResponsive.width(context, 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(width: AppResponsive.width(context, 2)),
        Text(
          label,
          style: AppTextStyle.caption.copyWith(
            fontSize: AppResponsive.width(context, 3.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.height(context, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: AppResponsive.width(context, 3),
                height: AppResponsive.width(context, 3),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppResponsive.width(context, 2)),
              Text(
                label,
                style: AppTextStyle.caption.copyWith(
                  fontSize: AppResponsive.width(context, 3.5),
                ),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: AppTextStyle.caption.copyWith(
              fontSize: AppResponsive.width(context, 3.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
