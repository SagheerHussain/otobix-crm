import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/user_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/network/socket_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminApprovedUsersListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingUpdateUserThroughAdmin = false.obs;
  RxBool isAssignKamLoading = false.obs;
  RxList<UserModel> approvedUsersList = <UserModel>[].obs;

  final formKey = GlobalKey<FormState>();

  final obscurePasswordText = true.obs;

  @override
  onInit() {
    super.onInit();
    fetchApprovedUsersList();
    listenToUpdatedUsersList();
  }

  // Fetch Approved Users List
  Future<void> fetchApprovedUsersList() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.approvedUsersList,
      );

      // Check for valid JSON response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> usersJson = data['users'] ?? [];

        approvedUsersList.value =
            usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        debugPrint("Error fetching approved users: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error fetching approved users: ${response.statusCode}",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error fetching approved users: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error fetching approved users",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update User Through Admin
  Future<void> updateUserThroughAdmin({
    required String userId,
    required String status,
    // required String password,
  }) async {
    isLoadingUpdateUserThroughAdmin.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.updateUserThroughAdmin(userId),
        body: {
          // 'password': password,
          'approvalStatus': status,
        },
      );

      // Check for valid JSON response
      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User updated successfully",
          type: ToastType.success,
        );
      } else if (response.statusCode == 404) {
        ToastWidget.show(
          context: Get.context!,
          title: "User not found",
          type: ToastType.error,
        );
      } else {
        debugPrint("Error updating user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error updating user.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error updating user: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error updating user.",
        type: ToastType.error,
      );
    } finally {
      isLoadingUpdateUserThroughAdmin.value = false;
    }
  }

  // Listen to updated users list
  void listenToUpdatedUsersList() {
    SocketService.instance.joinRoom(SocketEvents.adminHomeRoom);
    SocketService.instance.on(SocketEvents.updatedAdminHomeUsers, (data) {
      final List<dynamic> usersList = data['approvedUsersList'] ?? [];

      approvedUsersList.value =
          usersList.map((user) => UserModel.fromJson(user)).toList();
    });
  }

  // Assign / Unassign KAM to a dealer
  Future<void> assignKamToDealer({
    required String dealerId,
    String? kamId, // null or empty => unassign
  }) async {
    isAssignKamLoading.value = true;

    try {
      final body = <String, dynamic>{
        'dealerId': dealerId,
      };

      // If kamId is provided and not empty, include it.
      // If omitted, backend will unassign.
      if (kamId != null && kamId.isNotEmpty) {
        body['kamId'] = kamId;
      }

      final response = await ApiService.post(
        endpoint: AppUrls.assignKamToDealer,
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: (kamId == null || kamId.isEmpty)
              ? "KAM unassigned successfully"
              : "KAM assigned successfully",
          type: ToastType.success,
        );

        // If you don't fully trust sockets / want immediate UI update:
        // await fetchApprovedUsersList();
      } else if (response.statusCode == 404) {
        ToastWidget.show(
          context: Get.context!,
          title: "Dealer or KAM not found",
          type: ToastType.error,
        );
      } else {
        debugPrint("Error assigning KAM: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error assigning KAM.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error assigning KAM: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error assigning KAM.",
        type: ToastType.error,
      );
    } finally {
      isAssignKamLoading.value = false;
    }
  }
}
