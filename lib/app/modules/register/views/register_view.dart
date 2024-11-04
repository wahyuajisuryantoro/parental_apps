import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parental_apps/app/utils/app_text.dart';
import '../controllers/register_controller.dart';
import 'package:parental_apps/app/utils/app_colors.dart';
import 'package:parental_apps/app/utils/app_responsive.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Halaman Register',
          style: AppTextStyle.blackHeading2,
        ),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppResponsive.width(context, 8)),
          child: Column(
            children: [
              SizedBox(height: AppResponsive.height(context, 5)),
              _buildTextField(
                "Nama",
                controller.nameController,
                controller.nameFocusNode,
                Icons.person,
                context,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Email",
                controller.emailController,
                controller.emailFocusNode,
                Icons.email,
                context,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "No KK",
                controller.noKKController,
                controller.noKKFocusNode,
                Icons.assignment_ind,
                context,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Telepon",
                controller.phoneController,
                controller.phoneFocusNode,
                Icons.phone,
                context,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Username",
                controller.usernameController,
                controller.usernameFocusNode,
                Icons.account_circle,
                context,
              ),
              const SizedBox(height: 20),
              Obx(() => _buildPasswordField(
                    "Password",
                    controller.passwordController,
                    controller.passwordFocusNode,
                    context,
                  )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: AppResponsive.height(context, 7),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () => controller.register(),
                  child: Text("Register", style: AppTextStyle.buttonText),
                ),
              ),
              SizedBox(height: AppResponsive.height(context, 2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController textController,
      FocusNode focusNode, IconData icon, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.black,
          width: 1.5,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: AppResponsive.width(context, 4)),
      child: Row(
        children: [
          Icon(icon,
              color: AppColors.textSecondary,
              size: AppResponsive.width(context, 6)),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: hint,
                labelStyle: AppTextStyle.bodyTextBlack,
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppResponsive.height(context, 2)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController textController,
      FocusNode focusNode, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.black,
          width: 1.5,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: AppResponsive.width(context, 4)),
      child: Row(
        children: [
          Icon(Icons.lock,
              color: AppColors.textSecondary,
              size: AppResponsive.width(context, 6)),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: hint,
                labelStyle: AppTextStyle.bodyTextBlack,
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppResponsive.height(context, 2)),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
