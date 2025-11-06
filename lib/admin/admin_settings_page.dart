import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';
import 'package:otobix_crm/admin/admin_upload_policies_page.dart';
import 'package:otobix_crm/admin/admin_upload_terms_page.dart';
import 'package:otobix_crm/admin/admin_upload_user_guide_page.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 16, color: AppColors.green),
        ),
        backgroundColor: AppColors.grey.withValues(alpha: .1),
        iconTheme: const IconThemeData(color: AppColors.green),
      ),
      body: Column(
        children: [
          // SizedBox(height: 20),
          // _buildSearchBar(context),
          SizedBox(height: 30),

          Expanded(
            child: TabBarWidget(
              titles: ['Terms', 'Policies', 'User Guide'],
              counts: [0, 0, 0],
              screens: [
                AdminUploadTermsPage(),
                AdminUploadPoliciesPage(),
                AdminUploadUserGuidePage(),
              ],
              titleSize: 9,
              countSize: 7,
              spaceFromSides: 10,
              tabsHeight: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchBar(BuildContext context) {
  //   return SizedBox(
  //     height: 35,
  //     child: Row(
  //       children: [
  //         Flexible(
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 15, right: 7),
  //             child: TextFormField(
  //               // controller: getxController.searchController,
  //               keyboardType: TextInputType.text,
  //               style: TextStyle(fontSize: 12),
  //               decoration: InputDecoration(
  //                 hintText: 'Search...',
  //                 hintStyle: TextStyle(
  //                   color: AppColors.grey.withValues(alpha: .5),
  //                   fontSize: 12,
  //                 ),
  //                 prefixIcon: const Icon(
  //                   Icons.search,
  //                   color: Colors.grey,
  //                   size: 20,
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(100),
  //                   borderSide: BorderSide(color: AppColors.black),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(100),
  //                   borderSide: BorderSide(color: AppColors.green, width: 2),
  //                 ),
  //                 contentPadding: const EdgeInsets.symmetric(
  //                   vertical: 3,
  //                   horizontal: 10,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         // GestureDetector(
  //         //   onTap: () => Get.to(() => UserNotificationsPage()),
  //         //   child: Badge.count(
  //         //     count: homeController.unreadNotificationsCount.value,
  //         //     child: Icon(
  //         //       Icons.notifications_outlined,
  //         //       size: 25,
  //         //       color: AppColors.grey,
  //         //     ),
  //         //   ),
  //         // ),
  //         SizedBox(width: 15),
  //       ],
  //     ),
  //   );
  // }
}
