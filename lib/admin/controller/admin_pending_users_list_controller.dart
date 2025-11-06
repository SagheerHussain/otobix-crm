import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/user_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/Network/socket_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminPendingUsersListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserModel> usersList = <UserModel>[].obs;
  RxList<UserModel> filteredUsersList = <UserModel>[].obs;

  TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  @override
  onInit() {
    super.onInit();
    fetchPendingUsersList();
    filteredUsersList.value = usersList;
    listenToUpdatedUsersList();
  }

  // Fetch Pending Users List

  Future<void> fetchPendingUsersList() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(endpoint: AppUrls.pendingUsersList);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> usersJson = data['users'] ?? [];

        usersList.value =
            usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        debugPrint("Unexpected response format: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Unexpected response. Please try again.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error fetching users",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserStatus({
    required String userId,
    required String approvalStatus,
    String? comment,
  }) async {
    isLoading.value = true;

    try {
      final body = {
        "approvalStatus": approvalStatus,
        if (comment != null) "comment": comment,
      };

      final response = await ApiService.put(
        endpoint: AppUrls.updateUserStatus(userId),
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User status updated successfully.",
          type: ToastType.success,
        );

        // fetchPendingUsersList();
      } else {
        debugPrint("Failed to update user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to update user status.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error updating user",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveUser(String userId) async {
    isLoading.value = true;

    try {
      final body = {"approvalStatus": "Approved"};

      final response = await ApiService.put(
        endpoint: AppUrls.updateUserStatus(userId),
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User approved successfully.",
          type: ToastType.success,
        );

        // fetchPendingUsersList();
      } else {
        debugPrint("Failed to approve user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to approve user.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error approving user",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Listen to updated users list
  void listenToUpdatedUsersList() {
    SocketService.instance.joinRoom(SocketEvents.adminHomeRoom);
    SocketService.instance.on(SocketEvents.updatedAdminHomeUsers, (data) {
      final List<dynamic> pendingUsersList = data['pendingUsersList'] ?? [];

      filteredUsersList.value =
          pendingUsersList.map((user) => UserModel.fromJson(user)).toList();
    });
  }
}
