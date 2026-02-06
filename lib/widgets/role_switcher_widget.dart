import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/services/check_user_role_service.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class RoleSwitcherWidget extends StatelessWidget {
  final Widget Function(bool isSalesManager) builder;
  final Widget loading;

  const RoleSwitcherWidget({
    super.key,
    required this.builder,
    this.loading = const Center(
        child: CircularProgressIndicator(
      color: AppColors.green,
    )),
  });

  @override
  Widget build(BuildContext context) {
    final roleService = Get.find<CheckUserRoleService>();

    return Obx(() {
      if (!roleService.isReady) return loading;
      return builder(roleService.isSalesManager);
    });
  }
}
