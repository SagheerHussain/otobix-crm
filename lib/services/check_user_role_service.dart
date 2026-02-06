import 'package:get/get.dart';
import 'package:otobix_crm/controllers/desktop_bid_history_controller.dart';
import 'package:otobix_crm/controllers/desktop_cars_controller.dart';
import 'package:otobix_crm/controllers/desktop_homepage_controller.dart';
import 'package:otobix_crm/controllers/login_controller.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/retailer_desktop_cep_history_page.dart';

class CheckUserRoleService extends GetxService {
  final RxnString _role = RxnString(); // null until loaded

  String? get role => _role.value;
  bool get isReady => _role.value != null;

  bool get isSalesManager => _role.value == AppConstants.roles.salesManager;

  Future<CheckUserRoleService> init() async {
    _role.value =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userRoleKey) ?? '';
    return this;
  }

  // optional: call this after login/logout when role changes
  Future<void> refresh() async {
    _role.value =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userRoleKey) ?? '';

    if (Get.isRegistered<DesktopHomepageController>()) {
      Get.delete<DesktopHomepageController>(force: true);
    }
    if (Get.isRegistered<DesktopBidHistoryController>()) {
      Get.delete<DesktopBidHistoryController>(force: true);
    }
    if (Get.isRegistered<RetailerDesktopCepHistoryPage>()) {
      Get.delete<RetailerDesktopCepHistoryPage>(force: true);
    }
    if (Get.isRegistered<DesktopCarsController>()) {
      Get.delete<DesktopCarsController>(force: true);
    }
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>(force: true);
    }
  }
}
