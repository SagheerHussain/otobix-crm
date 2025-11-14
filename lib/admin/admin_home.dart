import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_approved_users_list_page.dart';
import 'package:otobix_crm/admin/admin_desktop_approved_users_list_page.dart';
import 'package:otobix_crm/admin/admin_desktop_rejected_users_list_page.dart';
import 'package:otobix_crm/admin/admin_rejected_users_list_page.dart';
import 'package:otobix_crm/admin/controller/admin_desktop_pending_users_list_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_images.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';
import 'package:otobix_crm/admin/controller/admin_home_controller.dart';
import 'package:otobix_crm/admin/controller/admin_pending_users_list_page.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final AdminHomeController getxController = Get.put(AdminHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: AppColors.grey.withValues(alpha: .1),
        elevation: 0,
        foregroundColor: AppColors.green,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Flexible(child: _buildSearchBar(context)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _buildRoleFilterDialog();
                  },
                  child: Image.asset(
                    AppImages.filterIcon,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => Expanded(
              child: TabBarWidget(
                titles: ['Pending', 'Approved', 'Rejected'],
                counts: [
                  getxController.pendingUsersLength.value,
                  getxController.approvedUsersLength.value,
                  getxController.rejectedUsersLength.value,
                ],
                screens: [
                  ResponsiveLayout(
                      mobile: AdminPendingUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      ),
                      desktop: AdminDesktopPendingUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      )),
                  ResponsiveLayout(
                      mobile: AdminApprovedUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      ),
                      desktop: AdminDesktopApprovedUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      )),
                  ResponsiveLayout(
                      mobile: AdminRejectedUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      ),
                      desktop: AdminDesktopRejectedUsersListPage(
                        searchQuery: getxController.searchQuery,
                        selectedRoles: getxController.selectedRoles,
                      )),
                ],
                titleSize: 10,
                countSize: 8,
                spaceFromSides: 20,
                tabsHeight: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: getxController.searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search users...',
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
          getxController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }

  void _buildRoleFilterDialog() {
    // final roles = [
    //   'All',
    //   UserModel.dealer,
    //   UserModel.customer,
    //   UserModel.salesManager,
    // ];
    // final RxList<String> tempSelected = <String>[].obs;

    final roles = getxController.roles;
    // Start with current selection so UI shows existing state
    final RxList<String> tempSelected = RxList<String>.from(
      getxController.selectedRoles,
    );

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Filter by Role",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Divider(),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: roles.map((role) {
                    final isSelected = tempSelected.contains(role);
                    return FilterChip(
                      label: Text(role),
                      selected: isSelected,
                      onSelected: (selected) {
                        // if (selected) {
                        //   tempSelected.add(role);
                        // } else {
                        //   tempSelected.remove(role);
                        // }

                        if (role == 'All') {
                          // If All tapped, keep only All
                          tempSelected.assignAll(['All']);
                          return;
                        }

                        // Non-All role toggled
                        if (selected) {
                          // Add role, and ensure All is removed
                          tempSelected.remove('All');
                          tempSelected.add(role);
                        } else {
                          tempSelected.remove(role);
                        }

                        // If user cleared all, fallback to All
                        if (tempSelected.isEmpty) {
                          tempSelected.assignAll(['All']);
                        }
                      },
                      selectedColor: AppColors.green.withValues(alpha: 0.1),
                      checkmarkColor: AppColors.green,
                      showCheckmark: true,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: role == 'All' ? 10 : 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.green : AppColors.black,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'Cancel',
                        isLoading: false.obs,
                        height: 30,
                        elevation: 3,
                        fontSize: 10,
                        backgroundColor: AppColors.red,
                        onTap: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ButtonWidget(
                        text: 'Apply',
                        isLoading: false.obs,
                        height: 30,
                        elevation: 3,
                        fontSize: 10,
                        onTap: () {
                          // Commit selection to controller (enforces rules again)
                          getxController.applyRoleSelection(
                            List<String>.from(tempSelected),
                          );
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
