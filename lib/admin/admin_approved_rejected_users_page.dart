// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_crm/utils/app_colors.dart';
// import 'package:otobix_crm/Views/Dealer%20Panel/admin_approved_users_list_page.dart';
// import 'package:otobix_crm/Views/Dealer%20Panel/admin_rejected_users_list_page.dart';
// import 'package:otobix_crm/widgets/tab_bar_widget.dart';
// import 'package:otobix_crm/admin/controller/admin_approved_rejected_users_controller.dart';

// class AdminApprovedRejectedUsersPage extends StatelessWidget {
//   AdminApprovedRejectedUsersPage({super.key});

//   final AdminApprovedRejectedUsersController getxController = Get.put(
//     AdminApprovedRejectedUsersController(),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           children: [
//             _buildSearchBar(context),
//             SizedBox(height: 20),
//             Obx(
//               () => Expanded(
//                 child: TabBarWidget(
//                   titles: ['Approved Users', 'Rejected Users'],
//                   counts: [
//                     getxController.approvedUsersLength.value,
//                     getxController.rejectedUsersLength.value,
//                   ],
//                   screens: [
//                     AdminApprovedUsersListPage(
//                       searchQuery: getxController.searchQuery,
//                     ),
//                     AdminRejectedUsersListPage(
//                       searchQuery: getxController.searchQuery,
//                     ),
//                   ],
//                   titleSize: 10,
//                   countSize: 8,
//                   spaceFromSides: 20,
//                   tabsHeight: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Search Bar
//   Widget _buildSearchBar(BuildContext context) {
//     return SizedBox(
//       height: 35,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: TextFormField(
//           controller: getxController.searchController,
//           keyboardType: TextInputType.text,
//           style: TextStyle(fontSize: 12),
//           decoration: InputDecoration(
//             isDense: true,

//             hintText: 'Search...',
//             hintStyle: TextStyle(
//               color: AppColors.grey.withValues(alpha: .5),
//               fontSize: 12,
//             ),
//             prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(100),
//               borderSide: BorderSide(color: AppColors.black),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(100),
//               borderSide: BorderSide(color: AppColors.green, width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 0,
//               horizontal: 10,
//             ),
//           ),
//           onChanged: (value) {
//             getxController.searchQuery.value = value.toLowerCase();
//           },
//         ),
//       ),
//     );
//   }
// }
