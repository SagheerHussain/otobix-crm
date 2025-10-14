import 'package:get/get.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/desktop_homepage.dart';
import 'package:otobix_crm/views/login_page.dart';

class SplashController extends GetxController {
  String? token;
  String? userType;

  @override
  void onInit() {
    super.onInit();
    checkToken();
  }

  void checkToken() async {
    token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
    userType = await SharedPrefsHelper.getString(SharedPrefsHelper.userRoleKey);

    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        if (userType == AppConstants.roles.admin) {
          Get.offAll(
            () => ResponsiveLayout(
              mobile: DesktopHomepage(),
              desktop: DesktopHomepage(),
            ),
          );
        } else {
          Get.offAll(() => LoginPage());
        }
      } else {
        Get.offAll(() => LoginPage());
      }
    });
  }
}
