import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_app_updates_page.dart';
import 'package:otobix_crm/admin/admin_car_margins_page.dart';
import 'package:otobix_crm/admin/admin_desktop_app_updates_page.dart';
import 'package:otobix_crm/admin/admin_desktop_car_margins_page.dart';
import 'package:otobix_crm/admin/admin_desktop_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_desktop_dropdowns_page.dart';
import 'package:otobix_crm/admin/admin_desktop_edit_profile_page.dart';
import 'package:otobix_crm/admin/admin_desktop_settings_page.dart';
import 'package:otobix_crm/admin/admin_dropdowns_page.dart';
import 'package:otobix_crm/admin/edit_account_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/admin/admin_cars_list_page.dart';
import 'package:otobix_crm/admin/admin_settings_page.dart';
import 'package:otobix_crm/admin/controller/admin_profile_controller.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';

class AdminDesktopProfilePage extends StatefulWidget {
  const AdminDesktopProfilePage({super.key});

  @override
  State<AdminDesktopProfilePage> createState() =>
      _AdminDesktopProfilePageState();
}

class _AdminDesktopProfilePageState extends State<AdminDesktopProfilePage> {
  final AdminProfileController adminProfileController = Get.put(
    AdminProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile Information",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Update your profile information",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  adminProfileController.username.value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  adminProfileController.useremail.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Obx(() {
                              final imageUrl =
                                  adminProfileController.imageUrl.value;
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Icon(Icons.person,
                                          size: 40, color: AppColors.blue)
                                      : null,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Header Section
              // Container(
              //   width: double.infinity,
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [
              //         AppColors.green.withOpacity(0.8),
              //         AppColors.blue.withOpacity(0.8)
              //       ],
              //     ),
              //     borderRadius: const BorderRadius.only(
              //       bottomLeft: Radius.circular(24),
              //       bottomRight: Radius.circular(24),
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       Stack(
              //         children: [
              //           Obx(() {
              //             final imageUrl =
              //                 adminProfileController.imageUrl.value;
              //             return Container(
              //               width: 100,
              //               height: 100,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 border: Border.all(color: Colors.white, width: 3),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black.withOpacity(0.1),
              //                     blurRadius: 8,
              //                     offset: const Offset(0, 4),
              //                   ),
              //                 ],
              //               ),
              //               child: CircleAvatar(
              //                 backgroundColor: Colors.white,
              //                 backgroundImage: imageUrl.isNotEmpty
              //                     ? NetworkImage(imageUrl)
              //                     : null,
              //                 child: imageUrl.isEmpty
              //                     ? Icon(Icons.person,
              //                         size: 40, color: AppColors.blue)
              //                     : null,
              //               ),
              //             );
              //           }),
              //           Positioned(
              //             bottom: 0,
              //             right: 0,
              //             child: Container(
              //               width: 28,
              //               height: 28,
              //               decoration: BoxDecoration(
              //                 color: AppColors.green,
              //                 shape: BoxShape.circle,
              //                 border: Border.all(color: Colors.white, width: 2),
              //               ),
              //               child:
              //                   Icon(Icons.edit, color: Colors.white, size: 14),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 16),
              //       Text(
              //         adminProfileController.username.value,
              //         style: const TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //       const SizedBox(height: 4),
              //       Text(
              //         adminProfileController.useremail.value,
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Colors.white.withOpacity(0.9),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Options Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Edit Profile Card
                    _buildProfileCard(
                      icon: Icons.edit_outlined,
                      title: "Edit Profile",
                      subtitle: "Update your personal information",
                      color: AppColors.green,
                      onTap: () {
                        Get.to(ResponsiveLayout(
                          mobile: EditProfileScreen(),
                          desktop: EditDesktopProfileScreen(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Cars List Card
                    _buildProfileCard(
                      icon: Icons.directions_car_outlined,
                      title: "Cars List",
                      subtitle: "View and manage all cars",
                      color: AppColors.blue,
                      onTap: () {
                        Get.to(ResponsiveLayout(
                          mobile: AdminCarsListPage(),
                          desktop: AdminDesktopCarsListPage(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // App Updates Card
                    _buildProfileCard(
                      icon: Icons.update,
                      title: "App Updates",
                      subtitle: "View and manage app updates",
                      color: AppColors.black,
                      onTap: () {
                        Get.to(ResponsiveLayout(
                          mobile: AdminAppUpdatesPage(),
                          desktop: AdminDesktopAppUpdatesPage(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Car Margins Card
                    _buildProfileCard(
                      icon: Icons.percent,
                      title: "Car Margins",
                      subtitle: "View and manage car margins",
                      color: Colors.deepOrange,
                      onTap: () {
                        Get.to(ResponsiveLayout(
                          mobile: AdminCarMarginsPage(),
                          desktop: AdminDesktopCarMarginsPage(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dropdowns Card
                    _buildProfileCard(
                      icon: Icons.list,
                      title: "Dropdowns",
                      subtitle: "View and manage dropdowns",
                      color: AppColors.blue,
                      onTap: () {
                        Get.to(ResponsiveLayout(
                          mobile: AdminDropdownsPage(),
                          desktop: AdminDesktopDropdownsPage(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Settings Card
                    _buildProfileCard(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      subtitle: "Update terms and privacy policy",
                      color: Colors.orange,
                      onTap: () {
                        Get.to(const ResponsiveLayout(
                          mobile: AdminSettingsPage(),
                          desktop: AdminDesktopSettingsPage(),
                        ));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Logout Card
                    _buildProfileCard(
                      icon: Icons.logout_outlined,
                      title: "Logout",
                      subtitle: "Sign out of your account",
                      color: Colors.red,
                      onTap: () {
                        adminProfileController.logout();
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isLogout
                ? Border.all(color: Colors.red.withOpacity(0.2))
                : null,
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
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isLogout ? Colors.red : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isLogout ? Colors.red : Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
