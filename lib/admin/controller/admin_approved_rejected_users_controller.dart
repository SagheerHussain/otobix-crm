// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_crm/network/api_service.dart';
// import 'package:otobix_crm/utils/app_urls.dart';
// import 'package:otobix_crm/widgets/toast_widget.dart';

// class AdminApprovedRejectedUsersController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxInt pendingUsersLength = 0.obs;
//   RxInt approvedUsersLength = 0.obs;
//   RxInt rejectedUsersLength = 0.obs;

//   final TextEditingController searchController = TextEditingController();

//   final RxString searchQuery = ''.obs;

//   @override
//   onInit() {
//     super.onInit();
//     fetchUsersLength();
//   }

//   Future<void> fetchUsersLength() async {
//     isLoading.value = true;

//     try {
//       final response = await ApiService.get(endpoint: AppUrls.usersLength);

//       // Check for valid JSON response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         approvedUsersLength.value = data['approvedUsersLength'] ?? 0;
//         rejectedUsersLength.value = data['rejectedUsersLength'] ?? 0;
//       }
//     } catch (e) {
//       debugPrint("Error fetching users length: $e");
//       ToastWidget.show(
//         context: Get.context!,
//         title: "Error fetching users length",
//         type: ToastType.error,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
