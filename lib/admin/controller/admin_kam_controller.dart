import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/kam_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminKamController extends GetxController {
  // Loading & error
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs; // NEW for delete button state (if needed)
  final error = RxnString();

  // Data
  final kams = <KamModel>[].obs;

  // Form controllers for Add/Edit KAM
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final regionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchKamsList();
  }

  // Fetch all KAMs from backend
  Future<void> fetchKamsList() async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await ApiService.get(endpoint: AppUrls.getKamsList);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = (body['data'] ?? []) as List;

        final kamList = list
            .map((e) => KamModel.fromJson(json: e as Map<String, dynamic>))
            .toList();

        kams.assignAll(kamList);
      } else {
        error.value =
            'Failed to fetch KAMs (status ${response.statusCode.toString()})';
      }
    } catch (err) {
      error.value = 'Failed to fetch KAMs';
      debugPrint('Failed to fetch KAMs: $err');
    } finally {
      isLoading.value = false;
    }
  }

  // Create KAM -> POST /kams/create
  Future<bool> createKam() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final region = regionController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || region.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Validation',
        subtitle: 'All required fields must be filled',
        type: ToastType.error,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final resp = await ApiService.post(
        endpoint: AppUrls.createKam,
        body: {
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'region': region,
        },
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        // Clear form
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        regionController.clear();

        // Reload list
        await fetchKamsList();
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'KAM created successfully',
          type: ToastType.success,
        );

        return true;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to create KAM',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Create KAM error: $e');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error creating KAM',
        type: ToastType.error,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // NEW: Update KAM -> PUT /kams/update
  Future<bool> updateKam(KamModel kam) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final region = regionController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || region.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Validation',
        subtitle: 'All required fields must be filled',
        type: ToastType.error,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final resp = await ApiService.put(
        endpoint: AppUrls.updateKam,
        body: {
          'id': kam.id,
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'region': region,
        },
      );

      if (resp.statusCode == 200) {
        // Optional: clear controllers
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        regionController.clear();

        await fetchKamsList();
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'KAM updated successfully',
          type: ToastType.success,
        );
        return true;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to update KAM',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Update KAM error: $e');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error updating KAM',
        type: ToastType.error,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // NEW: Delete KAM -> DELETE /kams/delete
  Future<bool> deleteKam(String id) async {
    isDeleting.value = true;
    try {
      final resp = await ApiService.post(
        endpoint: AppUrls.deleteKam,
        body: {'id': id},
      );

      if (resp.statusCode == 200) {
        await fetchKamsList();
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'KAM deleted successfully',
          type: ToastType.success,
        );
        return true;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to delete KAM',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Delete KAM error: $e');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error deleting KAM',
        type: ToastType.error,
      );
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}
