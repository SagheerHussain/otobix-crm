import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_dashboard.dart';
import 'package:otobix_crm/admin/admin_desktop_dashboard.dart';
import 'package:otobix_crm/network/socket_service.dart';
import 'package:otobix_crm/services/check_user_role_service.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/views/desktop_homepage.dart';
import 'package:otobix_crm/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firstScreen = await loadInitialData();

  runApp(MyApp(firstScreen: firstScreen));
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;

  const MyApp({super.key, required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.white,
        canvasColor: AppColors.white,
        // dialogTheme: const DialogTheme(backgroundColor: AppColors.white),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.white,
          brightness: Brightness.light,
        ),
      ),
      home: firstScreen,
    );
  }
}

// Load Initial Data
Future<Widget> loadInitialData() async {
  await SharedPrefsHelper.init();

  // Setup role service for checking user role
  await Get.putAsync<CheckUserRoleService>(
      () async => await CheckUserRoleService().init());

  SocketService.instance.initSocket(AppUrls.socketBaseUrl);

  final token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
  final userRole =
      await SharedPrefsHelper.getString(SharedPrefsHelper.userRoleKey);

  Widget firstScreen;

  if (token != null && token.isNotEmpty) {
    if (userRole == AppConstants.roles.admin) {
      // Admin
      firstScreen = ResponsiveLayout(
        mobile: AdminDashboard(),
        desktop: AdminDesktopDashboard(),
      );
    } else if (userRole == AppConstants.roles.salesManager) {
      // Sales Manager
      firstScreen = ResponsiveLayout(
        mobile: DesktopHomepage(),
        desktop: DesktopHomepage(),
      );
    } else if (userRole == AppConstants.roles.retailer) {
      // Retailer
      firstScreen = ResponsiveLayout(
        mobile: DesktopHomepage(),
        desktop: DesktopHomepage(),
      );
    } else {
      // Login
      firstScreen = LoginPage();
    }
  } else {
    firstScreen = LoginPage();
  }

  return firstScreen;
}
