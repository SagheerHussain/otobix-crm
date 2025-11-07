import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_desktop_live_cars_list_page.dart';
import 'package:otobix_crm/admin/controller/tab_bar_buttons_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/admin/admin_auction_completed_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_live_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_oto_buy_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_upcoming_cars_list_page.dart';
import 'package:otobix_crm/admin/controller/admin_auction_completed_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_oto_buy_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_upcoming_cars_list_controller.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';

class AdminDesktopCarsListPage extends StatelessWidget {
  AdminDesktopCarsListPage({super.key});

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
    return _buildDesktopLayout();
  }

  // Desktop Layout
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildDesktopHeader(),

            // SizedBox(height: 24),

            // // Stats Cards
            // _buildStatsCards(),

            SizedBox(height: 32),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search and Filter Bar
                    _buildDesktopSearchFilterBar(),

                    // Desktop Tabs
                    _buildDesktopTabs(),

                    // Content Area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: TabBarView(
                          controller: tabBarController.tabController,
                          children: [
                            _buildDesktopPageContainer(
                                AdminUpcomingCarsListPage()),
                            _buildDesktopPageContainer(ResponsiveLayout(
                              mobile: AdminLiveCarsListPage(),
                              desktop: AdminDesktopLiveCarsListPage(),
                            )),
                            _buildDesktopPageContainer(
                                AdminAuctionCompletedCarsListPage()),
                            _buildDesktopPageContainer(
                                AdminOtoBuyCarsListPage()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: Colors.grey[600]),
              ),
            ),
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Car Management",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Manage all cars across different auction stages",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Obx(() => Row(
          children: [
            _buildStatCard(
              count: upcomingController.upcomingCarsCount.value,
              label: "Upcoming Cars",
              icon: Icons.schedule_outlined,
              color: Colors.orange,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              count: liveController.liveCarsCount.value,
              label: "Live Auctions",
              icon: Icons.live_tv_outlined,
              color: Colors.red,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              count: auctionCompletedController.auctionCompletedCarsCount.value,
              label: "Completed",
              icon: Icons.check_circle_outline,
              color: AppColors.green,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              count: otoBuyController.otoBuyCarsCount.value,
              label: "OtoBuy Cars",
              icon: Icons.shopping_cart_outlined,
              color: AppColors.blue,
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSearchFilterBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildDesktopSearchBar(),
          ),
          // SizedBox(width: 16),
          // _buildFilterButton(),
          // SizedBox(width: 12),
          // _buildSortButton(),
          // SizedBox(width: 12),
          // _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildDesktopSearchBar() {
    return Container(
      height: 48,
      child: TextFormField(
        controller: mainController.searchController,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search cars by model, brand, VIN, or description...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        onChanged: (value) {
          mainController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      height: 48,
      child: OutlinedButton.icon(
        icon: Icon(Icons.filter_alt_outlined, size: 18),
        label: Text('Filters'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Add filter functionality
        },
      ),
    );
  }

  Widget _buildSortButton() {
    return Container(
      height: 48,
      child: OutlinedButton.icon(
        icon: Icon(Icons.sort, size: 18),
        label: Text('Sort'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Add sort functionality
        },
      ),
    );
  }

  Widget _buildExportButton() {
    return Container(
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(Icons.download, size: 18),
        label: Text('Export'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Add export functionality
        },
      ),
    );
  }

  Widget _buildDesktopTabs() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              _buildDesktopTab(
                  'Upcoming',
                  upcomingController.upcomingCarsCount.value,
                  0,
                  Icons.schedule_outlined,
                  Colors.orange),
              SizedBox(width: 16),
              _buildDesktopTab('Live', liveController.liveCarsCount.value, 1,
                  Icons.live_tv_outlined, AppColors.red),
              SizedBox(width: 16),
              _buildDesktopTab(
                  'Completed',
                  auctionCompletedController.auctionCompletedCarsCount.value,
                  2,
                  Icons.check_circle_outline,
                  AppColors.green),
              SizedBox(width: 16),
              _buildDesktopTab('OtoBuy', otoBuyController.otoBuyCarsCount.value,
                  3, Icons.shopping_cart_outlined, AppColors.blue),
            ],
          ),
        ));
  }

  Widget _buildDesktopTab(
      String title, int count, int index, IconData icon, Color color) {
    final isSelected = tabBarController.selectedIndex.value == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            tabBarController.tabController.animateTo(index);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.green.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.green : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.green : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.green : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopPageContainer(Widget child) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }

  // Mobile Search Bar (existing)
  Widget _buildSearchBar() {
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
