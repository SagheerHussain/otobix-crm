// lib/Controllers/Admin/admin_car_dropdown_management_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class CarDropdown {
  String id;
  String fullName;
  String make;
  String model;
  String variant;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  CarDropdown({
    required this.id,
    required this.fullName,
    required this.make,
    required this.model,
    required this.variant,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarDropdown.fromJson(Map<String, dynamic> json) {
    return CarDropdown(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      variant: json['variant'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class AdminCarDropdownManagementController extends GetxController {
  static AdminCarDropdownManagementController get instance => Get.find();

  // Observables
  var isLoading = false.obs;
  var dropdownsList = <CarDropdown>[].obs;
  var selectedDropdown = Rx<CarDropdown?>(null);
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var itemsPerPage = 10.obs;

  // Form controllers
  var makeController = TextEditingController();
  var modelController = TextEditingController();
  var variantController = TextEditingController();
  var isActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownsList();
  }

  @override
  void onClose() {
    makeController.dispose();
    modelController.dispose();
    variantController.dispose();
    super.onClose();
  }

  // Fetch dropdowns list
  Future<void> fetchDropdownsList({int page = 1}) async {
    try {
      isLoading(true);

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': itemsPerPage.value.toString(),
      };

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      final uri = Uri.parse(AppUrls.getCarDropdownsList)
          .replace(queryParameters: queryParams);

      final response = await ApiService.get(endpoint: uri.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final List<dynamic> dropdownsData = data['data'];
          dropdownsList.assignAll(
              dropdownsData.map((item) => CarDropdown.fromJson(item)).toList());

          currentPage.value = data['pagination']['currentPage'] ?? 1;
          totalPages.value = data['pagination']['totalPages'] ?? 1;
        } else {
          ToastWidget.show(
              context: Get.context!,
              title: 'Error',
              subtitle: data['message'] ?? 'Failed to fetch dropdowns',
              type: ToastType.error);
        }
      } else {
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to fetch dropdowns: ${response.statusCode}',
            type: ToastType.error);
      }
    } catch (error) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to fetch dropdowns: $error',
          type: ToastType.error);
    } finally {
      isLoading(false);
    }
  }

  // Add new dropdown
  Future<bool> addDropdown() async {
    try {
      isLoading(true);

      final response =
          await ApiService.post(endpoint: AppUrls.addCarDropdown, body: {
        'make': makeController.text.trim(),
        'model': modelController.text.trim(),
        'variant': variantController.text.trim(),
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          ToastWidget.show(
              context: Get.context!,
              title: 'Success',
              subtitle: 'Dropdown added successfully',
              type: ToastType.success);
          clearForm();
          fetchDropdownsList();
          return true;
        }
      }

      final errorData = json.decode(response.body);
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: errorData['message'] ?? 'Failed to add dropdown',
          type: ToastType.error);
      return false;
    } catch (error) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to add dropdown: $error',
          type: ToastType.error);
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Edit dropdown
  Future<bool> editDropdown(String id) async {
    try {
      isLoading(true);

      final response =
          await ApiService.put(endpoint: AppUrls.editCarDropdown, body: {
        'dropdownId': id,
        'make': makeController.text.trim(),
        'model': modelController.text.trim(),
        'variant': variantController.text.trim(),
        'isActive': isActive.value,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          ToastWidget.show(
              context: Get.context!,
              title: 'Success',
              subtitle: 'Dropdown updated successfully',
              type: ToastType.success);
          clearForm();
          fetchDropdownsList();
          return true;
        }
      }

      final errorData = json.decode(response.body);
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: errorData['message'] ?? 'Failed to update dropdown',
          type: ToastType.error);
      return false;
    } catch (error) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to update dropdown: $error',
          type: ToastType.error);
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete dropdown
  Future<bool> deleteDropdown(String id) async {
    try {
      final response =
          await ApiService.delete(endpoint: AppUrls.deleteCarDropdown, body: {
        'dropdownId': id,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          ToastWidget.show(
              context: Get.context!,
              title: 'Success',
              subtitle: 'Dropdown deleted successfully',
              type: ToastType.success);
          fetchDropdownsList();
          return true;
        }
      }

      final errorData = json.decode(response.body);
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: errorData['message'] ?? 'Failed to delete dropdown',
          type: ToastType.error);
      return false;
    } catch (error) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to delete dropdown: $error',
          type: ToastType.error);
      return false;
    }
  }

  // Toggle dropdown status
  Future<void> toggleDropdownStatus(String id) async {
    try {
      final response = await ApiService.put(
        endpoint: AppUrls.toggleCarDropdownStatus,
        body: {'dropdownId': id},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          ToastWidget.show(
              context: Get.context!,
              title: 'Success',
              subtitle: data['message'] ?? 'Status updated successfully',
              type: ToastType.success);
          fetchDropdownsList();
        }
      }
    } catch (error) {
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to toggle status: $error',
          type: ToastType.error);
    }
  }

  // Load dropdown data for editing
  void loadDropdownForEdit(CarDropdown dropdown) {
    selectedDropdown.value = dropdown;
    makeController.text = dropdown.make;
    modelController.text = dropdown.model;
    variantController.text = dropdown.variant;
    isActive.value = dropdown.isActive;
  }

  // Clear form
  void clearForm() {
    makeController.clear();
    modelController.clear();
    variantController.clear();
    isActive.value = true;
    selectedDropdown.value = null;
  }

  // Search dropdowns
  void searchDropdowns(String query) {
    searchQuery.value = query;
    fetchDropdownsList(page: 1);
  }
}
