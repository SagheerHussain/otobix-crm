import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_desktop_live_cars_list_page.dart';
import 'package:otobix_crm/admin/controller/tab_bar_buttons_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/widgets/tab_bar_buttons_widget.dart';
import 'package:otobix_crm/admin/admin_auction_completed_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_live_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_oto_buy_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_upcoming_cars_list_page.dart';
import 'package:otobix_crm/admin/controller/admin_auction_completed_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_oto_buy_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_upcoming_cars_list_controller.dart';

class AdminCarsListPage extends StatelessWidget {
  AdminCarsListPage({super.key});

  final AdminCarsListController mainController = Get.put(
    AdminCarsListController(),
  );
  final AdminUpcomingCarsListController upcomingController = Get.put(
    AdminUpcomingCarsListController(),
  );
  final AdminLiveCarsListController liveController = Get.put(
    AdminLiveCarsListController(),
  );
  final AdminAuctionCompletedCarsListController auctionCompletedController =
      Get.put(AdminAuctionCompletedCarsListController());
  final AdminOtoBuyCarsListController otoBuyController = Get.put(
    AdminOtoBuyCarsListController(),
  );

  final tabBarController = Get.put(
    TabBarButtonsController(tabLength: 4, initialIndex: 1),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // TabBar Screens / Sections
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
              child: TabBarView(
                controller: tabBarController.tabController,
                children: [
                  AdminUpcomingCarsListPage(),
                  ResponsiveLayout(
                    mobile: AdminLiveCarsListPage(),
                    desktop: AdminDesktopLiveCarsListPage(),
                  ),
                  AdminAuctionCompletedCarsListPage(),
                  AdminOtoBuyCarsListPage(),
                ],
              ),
            ),

            Material(
              // elevation: 4,
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(20),
              //   bottomRight: Radius.circular(20),
              // ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),

                    // Search bar + city filter
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Expanded(child: _buildSearchBar(context)),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // TabBar Buttons
                    Obx(
                      () => TabBarButtonsWidget(
                        titles: ['Upcoming', 'Live', 'Completed', 'OtoBuy'],

                        counts: [
                          upcomingController.upcomingCarsCount.value,
                          liveController.liveCarsCount.value,
                          auctionCompletedController
                              .auctionCompletedCarsCount.value,
                          otoBuyController.otoBuyCarsCount.value,
                        ],
                        controller: tabBarController.tabController,
                        selectedIndex: tabBarController.selectedIndex,

                        // titleSize: 10,
                        titleSize: 11,
                        countSize: 7,
                        tabsHeight: 30,
                        spaceFromSides: 15,
                      ),
                    ),

                    // const SizedBox(height: 15),

                    // Filter and Sort buttons
                    // _buildFilterAndSortButtons(),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        // body: Column(
        //   children: [
        //     const SizedBox(height: 20),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 18.0),
        //       child: Row(children: [Flexible(child: _buildSearchBar(context))]),
        //     ),
        //     SizedBox(height: 20),
        //     Obx(
        //       () => Expanded(
        //         child: TabBarWidget(
        //           titles: ['Upcoming', 'Live', 'Completed Auctions', 'OtoBuy'],
        //           counts: [
        //             upcomingController.upcomingCarsCount.value,
        //             liveController.liveCarsCount.value,
        //             liveController.liveCarsCount.value,
        //             otoBuyController.otoBuyCarsCount.value,
        //           ],
        //           screens: [
        //             AdminUpcomingCarsListPage(),
        //             AdminLiveCarsListPage(),
        //             AdminLiveCarsListPage(),
        //             AdminOtoBuyCarsListPage(),
        //           ],
        //           titleSize: 10,
        //           countSize: 8,
        //           spaceFromSides: 20,
        //           tabsHeight: 30,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: mainController.searchController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 12),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search cars...',
            hintStyle: TextStyle(
              color: AppColors.grey.withValues(alpha: .5),
              fontSize: 12,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: AppColors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
          ),
          onChanged: (value) {
            mainController.searchQuery.value = value.toLowerCase();
          },
        ),
      ),
    );
  }
}
