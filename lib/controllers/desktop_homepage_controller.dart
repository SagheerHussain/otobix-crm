import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/controllers/desktop_bid_history_controller.dart';
import 'package:otobix_crm/controllers/desktop_cars_controller.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/login_page.dart';
import 'package:sidebarx/sidebarx.dart';

class DesktopHomepageController extends GetxController {
  final SidebarXController sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );

  // 🔎 Global search text (all screens can read this)
  final RxString searchText = ''.obs;

  // 🔎 Controller for the TextField so we can clear UI text
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // 🔄 Whenever sidebar tab changes → clear search everywhere
    sidebarController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Clear global value
    searchText.value = '';

    // Clear TextField visually
    searchController.clear();

    // Clear Bid History API search (if controller is alive)
    if (Get.isRegistered<DesktopBidHistoryController>()) {
      Get.find<DesktopBidHistoryController>().setSearch('');
    }

    // 🔍 Clear Cars API search too (if controller exists)
    if (Get.isRegistered<DesktopCarsController>()) {
      Get.find<DesktopCarsController>().setSearch('');
    }
  }

  void setSearch(String v) => searchText.value = v;

  // 🔍 called when user presses Enter in the search field
  void onSearchSubmitted(String v) {
    searchText.value = v;

    switch (sidebarController.selectedIndex) {
      case 1: // Bid History tab
        if (Get.isRegistered<DesktopBidHistoryController>()) {
          Get.find<DesktopBidHistoryController>().setSearch(v);
        }
        break;

      case 2: // Cars tab
        if (Get.isRegistered<DesktopCarsController>()) {
          Get.find<DesktopCarsController>().setSearch(v);
        }
        break;

      default:
        // by default do nothing → search submit is optional
        break;
    }
  }

  Future<Map<String, String>> loadUserFromPrefs() async {
    final userName =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userNameKey);
    final userEmail =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userEmailKey);
    final userPhone =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userPhoneKey);

    return {
      'name': userName ?? 'Admin',
      'email': userEmail ?? 'N/A',
      'phone': userPhone ?? 'N/A',
    };
  }

  Future<void> logout() async {
    await SharedPrefsHelper.clearAll();
    Get.offAll(() => LoginPage());
  }
}
