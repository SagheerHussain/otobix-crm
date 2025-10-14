import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/controllers/splash_controller.dart';
import 'package:otobix_crm/utils/app_images.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController splashController = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AppImages.logo, height: 300)),
    );
  }
}
