import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/Network/socket_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminHomeController extends GetxController {
  // loading
  RxBool isLoading = false.obs;
  RxBool isLoadingUsersLength = false.obs;

  // search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Selected roles for filtering.
  /// Default to ["All"].
  final RxList<String> selectedRoles = <String>['All'].obs;

  // tabs counters
  RxInt pendingUsersLength = 0.obs;
  RxInt approvedUsersLength = 0.obs;
  RxInt rejectedUsersLength = 0.obs;

  // roles list used in UI
  final List<String> roles = [
    'All',
    AppConstants.roles.dealer,
    AppConstants.roles.customer,
    AppConstants.roles.salesManager,
  ];

  // For desktop ui tab bar
  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersLength();
    listenToUpdatedUsersLengths();
  }

  // fetch users length
  Future<void> fetchUsersLength() async {
    isLoadingUsersLength.value = true;
    try {
      final response = await ApiService.get(endpoint: AppUrls.usersLength);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pendingUsersLength.value = data['pendingUsersLength'] ?? 0;
        approvedUsersLength.value = data['approvedUsersLength'] ?? 0;
        rejectedUsersLength.value = data['rejectedUsersLength'] ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching users length: $e");
      if (Get.context != null) {
        ToastWidget.show(
          context: Get.context!,
          title: "Error fetching users length",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingUsersLength.value = false;
    }
  }

  /// Enforce the "All" exclusivity rule and never leave empty.
  void applyRoleSelection(List<String> picked) {
    // If nothing picked, default to All.
    if (picked.isEmpty) {
      selectedRoles.assignAll(['All']);
      return;
    }

    // If All is picked (alone or with others), keep only All.
    if (picked.contains('All')) {
      selectedRoles.assignAll(['All']);
      return;
    }

    // Otherwise keep only the specific roles (ensure All is not included)
    selectedRoles.assignAll(picked.where((r) => r != 'All'));
  }

  /// Helper for consumers: does this role pass current filter?
  bool roleMatches(String userRole) {
    final sel = selectedRoles;
    if (sel.contains('All')) return true;
    return sel.contains(userRole);
  }

  // Listen to updated users lengths
  void listenToUpdatedUsersLengths() {
    SocketService.instance.joinRoom(SocketEvents.adminHomeRoom);
    SocketService.instance.on(SocketEvents.updatedAdminHomeUsers, (data) {
      final List<dynamic> approvedUsersList = data['approvedUsersList'] ?? [];
      final List<dynamic> rejectedUsersList = data['rejectedUsersList'] ?? [];
      final List<dynamic> pendingUsersList = data['pendingUsersList'] ?? [];

      approvedUsersLength.value = approvedUsersList.length;
      rejectedUsersLength.value = rejectedUsersList.length;
      pendingUsersLength.value = pendingUsersList.length;
    });
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_crm/network/api_service.dart';
// import 'package:otobix_crm/utils/app_urls.dart';
// import 'package:otobix_crm/widgets/toast_widget.dart';

// class AdminHomeController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool isLoadingUsersLength = false.obs;

//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;

//   RxString selectedRole = 'All'.obs;

//   RxInt pendingUsersLength = 0.obs;
//   RxInt approvedUsersLength = 0.obs;
//   RxInt rejectedUsersLength = 0.obs;

//   @override
//   onInit() {
//     super.onInit();
//     fetchUsersLength();
//   }

//   // fetch users length
//   Future<void> fetchUsersLength() async {
//     isLoadingUsersLength.value = true;

//     try {
//       final response = await ApiService.get(endpoint: AppUrls.usersLength);

//       // Check for valid JSON response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         pendingUsersLength.value = data['pendingUsersLength'] ?? 0;
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
//       isLoadingUsersLength.value = false;
//     }
//   }
// }
