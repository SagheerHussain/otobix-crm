import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_desktop_homepage_banners_page.dart';
import 'package:otobix_crm/admin/admin_desktop_sell_my_car_banners_page.dart';
import 'package:otobix_crm/admin/admin_homepage_banners_page.dart';
import 'package:otobix_crm/admin/admin_sell_my_car_banners_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';

class AdminCarBannersController extends GetxController {
  final bannerCategories = <BannerCardModel>[
    BannerCardModel(
      id: 1,
      title: 'Homepage Banners',
      description: 'Manage homepage banners',
      icon: Icons.home,
      color: AppColors.green,
      route: ResponsiveLayout(
          mobile: AdminHomepageBannersPage(),
          desktop: AdminDesktopHomepageBannersPage()),
    ),
    BannerCardModel(
      id: 2,
      title: 'Sell My Car Banners',
      description: 'Manage sell my car banners',
      icon: Icons.sell,
      color: AppColors.red,
      route: ResponsiveLayout(
          mobile: AdminSellMyCarBannersPage(),
          desktop: AdminDesktopSellMyCarBannersPage()),
    ),
  ].obs;
}

class BannerCardModel {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget route;

  BannerCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}
