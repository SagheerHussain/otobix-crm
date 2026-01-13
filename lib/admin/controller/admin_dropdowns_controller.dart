import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/dropdowns_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminDropdownsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isAddDropdownLoading = false.obs;
  final RxBool isDeleteDropdownLoading = false.obs;
  final RxList<DropdownsModel> dropdownsList = <DropdownsModel>[].obs;

  // For form handling
  final TextEditingController dropdownNameController = TextEditingController();
  final RxList<String> dropdownNames = <String>[].obs;
  final RxList<String> dropdownValues = <String>[].obs;
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newValueController = TextEditingController();
  final RxBool isEditing = false.obs;
  final RxString editingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownsList();
  }

  @override
  void onClose() {
    dropdownNameController.dispose();
    newNameController.dispose();
    newValueController.dispose();
    super.onClose();
  }

  // Fetch all Dropdowns from backend
  Future<void> fetchDropdownsList() async {
    isLoading.value = true;

    try {
      final response =
          await ApiService.get(endpoint: AppUrls.getAllDropdownsList);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = (body['data'] ?? []) as List;

        final List<DropdownsModel> fetchedDropdowns = list
            .map((e) => DropdownsModel.fromJson(e as Map<String, dynamic>))
            .toList();

        dropdownsList.assignAll(fetchedDropdowns);
      } else {
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to fetch dropdowns',
            type: ToastType.error);
      }
    } catch (err) {
      debugPrint('Failed to fetch Dropdowns: $err');
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to fetch dropdowns',
          type: ToastType.error);
    } finally {
      isLoading.value = false;
    }
  }

  // Add new dropdown
  Future<void> addNewDropdown() async {
    if (dropdownNames.isEmpty || dropdownValues.isEmpty) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Please add at least one dropdown name and value',
          type: ToastType.error);
      return;
    }

    isAddDropdownLoading.value = true;

    try {
      final response =
          await ApiService.post(endpoint: AppUrls.addOrUpdateDropdown, body: {
        'dropdownNames': dropdownNames.toList(),
        'dropdownValues': dropdownValues.toList(),
      });

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Dropdown added successfully',
          type: ToastType.success,
        );
        resetForm();
        fetchDropdownsList();
        Get.back();
      } else {
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to add dropdown',
            type: ToastType.error);
      }
    } catch (err) {
      debugPrint('Failed to add dropdown: $err');
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error occurred while adding dropdown',
          type: ToastType.error);
    } finally {
      isAddDropdownLoading.value = false;
    }
  }

  // Update existing dropdown
  Future<void> updateDropdown() async {
    if (dropdownNameController.text.trim().isEmpty || dropdownValues.isEmpty) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Please enter dropdown name and at least one value',
          type: ToastType.error);
      return;
    }

    isAddDropdownLoading.value = true;

    try {
      final response =
          await ApiService.post(endpoint: AppUrls.addOrUpdateDropdown, body: {
        'dropdownId': editingId.value,
        'dropdownNames': [dropdownNameController.text.trim()],
        'dropdownValues': dropdownValues.toList(),
      });

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Dropdown updated successfully',
          type: ToastType.success,
        );
        resetForm();
        fetchDropdownsList();
        Get.back();
      } else if (response.statusCode == 400) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: responseBody['message'] ?? 'Failed to update dropdown',
          type: ToastType.error,
        );
      } else {
        debugPrint('Failed to update dropdown: ${response.body}');
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to update dropdown',
            type: ToastType.error);
      }
    } catch (err) {
      debugPrint('Failed to update dropdown: $err');
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error occurred while updating dropdown',
          type: ToastType.error);
    } finally {
      isAddDropdownLoading.value = false;
    }
  }

  // Delete dropdown
  Future<void> deleteDropdown(String dropdownId, String dropdownName) async {
    isDeleteDropdownLoading.value = true;

    try {
      final response = await ApiService.delete(
        endpoint: AppUrls.deleteDropdown,
        body: {
          'dropdownId': dropdownId,
        },
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Dropdown "$dropdownName" deleted successfully',
          type: ToastType.success,
        );
        fetchDropdownsList();
      } else {
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to delete dropdown',
            type: ToastType.error);
      }
    } catch (err) {
      debugPrint('Failed to delete dropdown: $err');
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error occurred while deleting dropdown',
          type: ToastType.error);
    } finally {
      isDeleteDropdownLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    dropdownNameController.clear();
    dropdownNames.clear();
    dropdownValues.clear();
    newNameController.clear();
    newValueController.clear();
    isEditing.value = false;
    editingId.value = '';
  }

  // Set values for editing
  void setForEditing(DropdownsModel dropdown) {
    isEditing.value = true;
    editingId.value = dropdown.id ?? '';
    dropdownNameController.text = dropdown.dropdownName;
    dropdownNames.assignAll([dropdown.dropdownName]);
    dropdownValues.assignAll(dropdown.dropdownValues);
  }

  // Add new name to dropdown names list
  void addNewName() {
    if (newNameController.text.trim().isNotEmpty) {
      dropdownNames.add(newNameController.text.trim());
      newNameController.clear();
    }
  }

  // Remove name from dropdown names list
  void removeName(int index) {
    if (index >= 0 && index < dropdownNames.length) {
      dropdownNames.removeAt(index);
    }
  }

  // Add new value to dropdown values list
  void addNewValue() {
    if (newValueController.text.trim().isNotEmpty) {
      dropdownValues.add(newValueController.text.trim());
      newValueController.clear();
    }
  }

  // Remove value from dropdown values list
  void removeValue(int index) {
    if (index >= 0 && index < dropdownValues.length) {
      dropdownValues.removeAt(index);
    }
  }
}
