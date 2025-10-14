import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/utils/api_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/desktop_homepage.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    clearFields();
  }

  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      String dealerName = userNameController.text.trim();
      String contactNumber = phoneNumberController.text.trim();
      String password = passwordController.text.trim();
      final requestBody = {
        "userName": dealerName,
        "phoneNumber": contactNumber,
        "password": password,
      };

      final response = await ApiService.post(
        endpoint: AppUrls.login,
        body: requestBody,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final user = data['user'];
        final userRole = user['userType'];
        final userId = user['id'];
        final approvalStatus = user['approvalStatus'];

        if (approvalStatus == 'Approved') {
          await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);
        }

        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userKey,
          jsonEncode(user),
        );

        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userRoleKey,
          userRole,
        );

        await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);

        if (userRole == AppConstants.roles.admin) {
          Get.offAll(
            () => ResponsiveLayout(
              mobile: DesktopHomepage(),
              desktop: DesktopHomepage(),
            ),
          );
        } else {
          ToastWidget.show(
            context: Get.context!,
            title: "You are not authorized to visit this site.",
            type: ToastType.error,
          );
        }
      } else {
        debugPrint("Failed: $data");
        ToastWidget.show(
          context: Get.context!,
          title: data['message'] ?? "Failed to login",
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint("Error: $error");
      ToastWidget.show(
        context: Get.context!,
        title: "Error during login. Please try again.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required.";
    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "At least one uppercase letter required.";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "At least one lowercase letter required.";
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return "At least one special character required.";
    }
    return null;
  }

  // Clear fields
  void clearFields() {
    userNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    obsecureText.value = true;
  }
}
