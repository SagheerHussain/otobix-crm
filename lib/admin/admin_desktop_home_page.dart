import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_approved_users_list_page.dart';
import 'package:otobix_crm/admin/admin_rejected_users_list_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_images.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/admin/controller/admin_home_controller.dart';
import 'package:otobix_crm/admin/controller/admin_pending_users_list_page.dart';

class AdminDesktopHomePage extends StatelessWidget {
  AdminDesktopHomePage({super.key});

  final AdminHomeController getxController = Get.put(AdminHomeController());

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Management",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage and review user applications",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                _buildStatsCards(),
              ],
            ),

            SizedBox(height: 32),

            // Search and Filter Section
            Container(
              padding: EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDesktopSearchBar(),
                  ),
                  SizedBox(width: 16),
                  _buildDesktopFilterButton(),
                  // SizedBox(width: 12),
                  // _buildExportButton(),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Tabs Section
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
                    // Custom Tab Bar for Desktop
                    _buildDesktopTabBar(),

                    // Tab Content
                    Expanded(
                      child: Obx(
                        () => IndexedStack(
                          index: getxController.currentTabIndex.value,
                          children: [
                            AdminPendingUsersListPage(
                              searchQuery: getxController.searchQuery,
                              selectedRoles: getxController.selectedRoles,
                            ),
                            AdminApprovedUsersListPage(
                              searchQuery: getxController.searchQuery,
                              selectedRoles: getxController.selectedRoles,
                            ),
                            AdminRejectedUsersListPage(
                              searchQuery: getxController.searchQuery,
                              selectedRoles: getxController.selectedRoles,
                            ),
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

  // Desktop Stats Cards
  Widget _buildStatsCards() {
    return Obx(() => Row(
          children: [
            _buildStatCard(
              count: getxController.pendingUsersLength.value,
              label: "Pending",
              color: Colors.orange,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              count: getxController.approvedUsersLength.value,
              label: "Approved",
              color: AppColors.green,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              count: getxController.rejectedUsersLength.value,
              label: "Rejected",
              color: Colors.red,
            ),
          ],
        ));
  }

  Widget _buildStatCard(
      {required int count, required String label, required Color color}) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16),
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
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Search Bar
  Widget _buildDesktopSearchBar() {
    return Container(
      height: 48,
      child: TextFormField(
        controller: getxController.searchController,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search users by name, email, or role...',
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
          getxController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }

  // Desktop Filter Button
  Widget _buildDesktopFilterButton() {
    return Obx(() => Container(
          height: 48,
          child: OutlinedButton.icon(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: getxController.selectedRoles.length > 1 ||
                      (getxController.selectedRoles.length == 1 &&
                          !getxController.selectedRoles.contains('All'))
                  ? AppColors.green
                  : AppColors.grey,
            ),
            label: Text(
              'Filter',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: getxController.selectedRoles.length > 1 ||
                        (getxController.selectedRoles.length == 1 &&
                            !getxController.selectedRoles.contains('All'))
                    ? AppColors.green
                    : AppColors.grey,
              ),
            ),
            onPressed: () {
              _buildDesktopRoleFilterDialog();
            },
          ),
        ));
  }

  // Desktop Tab Bar
  Widget _buildDesktopTabBar() {
    return Obx(() => Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              _buildDesktopTab(
                  'Pending', getxController.pendingUsersLength.value, 0),
              SizedBox(width: 24),
              _buildDesktopTab(
                  'Approved', getxController.approvedUsersLength.value, 1),
              SizedBox(width: 24),
              _buildDesktopTab(
                  'Rejected', getxController.rejectedUsersLength.value, 2),
            ],
          ),
        ));
  }

  Widget _buildDesktopTab(String title, int count, int index) {
    final isSelected = getxController.currentTabIndex.value == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          getxController.currentTabIndex.value = index;
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
              color: isSelected ? AppColors.green : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.green : Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            ],
          ),
        ),
      ),
    );
  }

  // Desktop Filter Dialog
  void _buildDesktopRoleFilterDialog() {
    final roles = getxController.roles;
    final RxList<String> tempSelected = RxList<String>.from(
      getxController.selectedRoles,
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Obx(() => Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter Users by Role",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (tempSelected.length > 1 ||
                            (tempSelected.length == 1 &&
                                !tempSelected.contains('All')))
                          TextButton(
                            onPressed: () {
                              tempSelected.assignAll(['All']);
                            },
                            child: Text(
                              'Clear All',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: roles.map((role) {
                        final isSelected = tempSelected.contains(role);
                        return FilterChip(
                          label: Text(role),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (role == 'All') {
                              tempSelected.assignAll(['All']);
                              return;
                            }
                            if (selected) {
                              tempSelected.remove('All');
                              tempSelected.add(role);
                            } else {
                              tempSelected.remove(role);
                            }
                            if (tempSelected.isEmpty) {
                              tempSelected.assignAll(['All']);
                            }
                          },
                          selectedColor: AppColors.green.withOpacity(0.1),
                          checkmarkColor: AppColors.green,
                          showCheckmark: true,
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected ? AppColors.green : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              getxController.applyRoleSelection(
                                List<String>.from(tempSelected),
                              );
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Apply Filters',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  // Mobile Search Bar (existing)
  Widget _buildSearchBar() {
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
    // Your existing mobile filter dialog code
    final roles = getxController.roles;
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
                        if (role == 'All') {
                          tempSelected.assignAll(['All']);
                          return;
                        }
                        if (selected) {
                          tempSelected.remove('All');
                          tempSelected.add(role);
                        } else {
                          tempSelected.remove(role);
                        }
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
