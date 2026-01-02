import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/app_updates_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminAppUpdatesController extends GetxController {
  final isLoading = false.obs;
  final appUpdatesList = <AppUpdatesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppUpdates();
  }

// Fetch app updates from API
  Future<void> fetchAppUpdates() async {
    try {
      isLoading.value = true;

      final res = await ApiService.get(endpoint: AppUrls.getAppUpdatesList);

      if (res.statusCode != 200) {
        showErrorToast('Fetch failed (${res.statusCode})');
        return;
      }

      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (decoded["data"] ?? []) as List;

      appUpdatesList.value =
          list.map((e) => AppUpdatesModel.fromJson(e)).toList();

      // debugPrint("Fetched ${appUpdatesList.length} app updates");
    } catch (e) {
      debugPrint("Fetch error: $e");
      showErrorToast('Error fetching app updates');
    } finally {
      isLoading.value = false;
    }
  }

// Add app update
  Future<void> addAppUpdates(AppUpdatesModel payload) async {
    isLoading.value = true;
    try {
      final res = await ApiService.post(
          endpoint: AppUrls.addAppUpdates, body: payload.toJson());

      debugPrint("Add failed: ${res.statusCode} - ${res.body}");
      if (res.statusCode == 400) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final message = decoded["message"] ?? "Unknown error";
        showErrorToast(message);
        return;
      }

      if (res.statusCode != 200) {
        showErrorToast('Failed to add app update');
        return;
      }

      showSuccessToast('Added successfully');

      await fetchAppUpdates();
    } catch (e) {
      debugPrint("Add error: $e");
      showErrorToast('Error adding app update');
    } finally {
      isLoading.value = false;
    }
  }

// Update app update
  Future<void> updateAppUpdates(String id, AppUpdatesModel payload) async {
    isLoading.value = true;
    try {
      final res = await ApiService.put(
          endpoint: AppUrls.updateAppUpdates,
          body: {...payload.toJson(), "id": id});

      if (res.statusCode != 200) {
        showErrorToast('Failed to update app update');
        return;
      }

      showSuccessToast('Updated successfully');
      await fetchAppUpdates();
    } catch (e) {
      debugPrint("Update error: $e");
      showErrorToast('Error updating app update');
    } finally {
      isLoading.value = false;
    }
  }

// Delete app update
  Future<void> deleteAppUpdates(String id) async {
    try {
      isLoading.value = true;

      final res = await ApiService.delete(
          endpoint: AppUrls.deleteAppUpdates, body: {"id": id});

      if (res.statusCode != 200) {
        showErrorToast('Failed to delete app update');
        return;
      }

      showSuccessToast('Deleted successfully');
      appUpdatesList.removeWhere((e) => e.id == id);
    } catch (e) {
      debugPrint("Delete error: $e");
      showErrorToast('Error deleting app update');
    } finally {
      isLoading.value = false;
    }
  }

// Show error toast
  void showErrorToast(String message) {
    if (Get.context != null) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error",
        subtitle: message,
        type: ToastType.error,
      );
    }
  }

  // Show success toast
  void showSuccessToast(String message) {
    if (Get.context != null) {
      ToastWidget.show(
        context: Get.context!,
        title: "Success",
        subtitle: message,
        type: ToastType.success,
      );
    }
  }
}
