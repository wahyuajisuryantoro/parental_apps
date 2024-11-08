import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parental_apps/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:parental_apps/app/widgets/bottom_navigation_bar/controller/navigation_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/login/controllers/login_controller.dart';

void main() async {
  Get.put(NavigationController());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      home: InitialScreen(),
      getPages: AppPages.routes,
    );
  }
}

class InitialScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginController.checkSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan"));
        } else {
          return Container();
        }
      },
    );
  }
}
