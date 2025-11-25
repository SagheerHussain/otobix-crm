import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_customers_page.dart';
import 'package:otobix_crm/admin/admin_desktop_customers_page.dart';
import 'package:otobix_crm/admin/admin_desktop_kam_page.dart';
import 'package:otobix_crm/admin/admin_kam_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/admin/admin_home.dart';
import 'package:otobix_crm/admin/admin_profile_page.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // final BottomNavigationController getxController = Get.put(
  //   BottomNavigationController(),
  // );
  RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    AdminHome(),
    ResponsiveLayout(
        mobile: AdminCustomersPage(), desktop: AdminDesktopCustomersPage()),
    const AdminProfilePage(),
    ResponsiveLayout(mobile: AdminKamPage(), desktop: AdminDesktopKamPage()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          currentIndex: currentIndex.value,
          onTap: (index) {
            currentIndex.value = index;
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.home, size: 20),
              title: Text("Home", style: TextStyle(fontSize: 14)),
              selectedColor: AppColors.green,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person_3, size: 20),
              title: Text("Customers", style: TextStyle(fontSize: 14)),
              selectedColor: AppColors.grey,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle, size: 20),
              title: Text("Profile", style: TextStyle(fontSize: 14)),
              selectedColor: AppColors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person_2, size: 20),
              title: Text("KAMs", style: TextStyle(fontSize: 14)),
              selectedColor: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }
}
