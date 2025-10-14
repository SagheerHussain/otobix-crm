import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/login_page.dart';
import 'package:sidebarx/sidebarx.dart';

class DesktopHomepageController extends GetxController {
  final SidebarXController sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );

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
