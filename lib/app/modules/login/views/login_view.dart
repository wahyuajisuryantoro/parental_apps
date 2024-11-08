import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import '../controllers/login_controller.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: AppResponsive.height(context, 10),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.width(context, 5)),
          child: Column(
            children: [
              SizedBox(
                height: AppResponsive.height(context, 10),
              ),
              Image.asset(
                'assets/images/logo-presensimu.png',
                fit: BoxFit.cover,
                height: AppResponsive.height(context, 10),
              ),
              SizedBox(height: AppResponsive.height(context, 5)),
              TextFormField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.height(context, 2)),
              Obx(() => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '****',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          controller.togglePasswordVisibility();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
              SizedBox(
                height: AppResponsive.height(context, 2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        AppResponsive.width(context, 35),
                        AppResponsive.height(context, 6),
                      ),
                      backgroundColor: AppColors.blueLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppResponsive.width(context, 4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppResponsive.width(context, 5),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.login();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        AppResponsive.width(context, 35),
                        AppResponsive.height(context, 6),
                      ),
                      backgroundColor: AppColors.blueLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppResponsive.width(context, 4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
