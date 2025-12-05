import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_car_banners_page.dart';
import 'package:otobix_crm/admin/admin_desktop_car_banners_page.dart';
import 'package:otobix_crm/admin/admin_car_dropdown_management_page.dart';
import 'package:otobix_crm/admin/admin_desktop_car_dropdown_management_page.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';

class AdminCustomersController extends GetxController {
  // Customer Summary
  final RxInt totalCustomersLength = 0.obs;
  final RxInt activeCustomersLength = 0.obs;
  final RxInt thisMonthCustomersLength = 0.obs;
  final RxInt carMakeModelVariantDropdownsLength = 0.obs;
  final RxInt bannersLength = 0.obs;

  // Customer cards data
  final RxList<CustomerCard> customerCards = <CustomerCard>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomersSummary(); // Fetch the data when the controller is initialized
  }

  // Fetch Customers Summary
  Future<void> fetchCustomersSummary() async {
    try {
      final response =
          await ApiService.get(endpoint: AppUrls.getCustomersSummary);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalCustomersLength.value = data['totalCustomersLength'] ?? 0;
        activeCustomersLength.value = data['activeCustomersLength'] ?? 0;
        thisMonthCustomersLength.value = data['thisMonthCustomersLength'] ?? 0;
        carMakeModelVariantDropdownsLength.value =
            data['carMakeModelVariantDropdownsLength'] ?? 0;
        bannersLength.value = data['bannersLength'] ?? 0;

        // Update customer cards after fetching data
        customerCards.clear(); // Clear existing cards before adding new ones
        customerCards.addAll([
          CustomerCard(
            title: 'Car Dropdown Management',
            description: 'View and manage car dropdowns',
            icon: Icons.directions_car_outlined,
            route: ResponsiveLayout(
              mobile: AdminCarDropdownManagementPage(),
              desktop: AdminDesktopCarDropdownManagementPage(),
            ),
            color: AppColors.blue,
            count: carMakeModelVariantDropdownsLength.value,
            countLable: 'dropdowns',
          ),
          CustomerCard(
            title: 'Banners',
            description: 'View and manage Car Banners',
            icon: Icons.photo_library_outlined,
            route: ResponsiveLayout(
              mobile: AdminCarBannersPage(),
              desktop: AdminDesktopCarBannersPage(),
            ),
            color: AppColors.red,
            // count: bannersLength.value,
            count: 2,
            countLable: 'banners',
          ),
          // CustomerCard(
          //   title: 'Active Customers',
          //   description: 'Customers who are active',
          //   icon: Icons.verified_user_outlined,
          //   route: AdminCarDropdownManagementPage(),
          //   color: AppColors.green,
          //   count: activeCustomersLength.value,
          // ),
          // CustomerCard(
          //   title: 'New Customers',
          //   description: 'Customers who registered this month',
          //   icon: Icons.person_add_alt_1_outlined,
          //   route: AdminCarDropdownManagementPage(),
          //   color: AppColors.red,
          //   count: thisMonthCustomersLength.value,
          // ),
        ]);
      } else {
        debugPrint(response.body);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

// Customer card class
class CustomerCard {
  final String title;
  final String description;
  final IconData icon;
  final Widget route;
  final Color color;
  final int count;
  final String countLable;

  CustomerCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
    required this.count,
    required this.countLable,
  });
}
