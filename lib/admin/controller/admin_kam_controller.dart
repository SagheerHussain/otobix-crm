import 'dart:convert';
import 'dart:math' as math;
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
  final error = RxnString();

  // Data
  final kams = <KamModel>[].obs;

  // Pagination (frontend only)
  final page = 1.obs;
  final limit = 20.obs; // rows per page
  final totalPages = 1.obs;

  // Form controllers for Add KAM
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

        // reset pagination
        page.value = 1;
        _recalculateTotalPagesForBaseList();
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

  void _recalculateTotalPagesForBaseList() {
    final totalCount = kams.length;
    final pages = (totalCount / limit.value).ceil();
    totalPages.value = pages == 0 ? 1 : pages;
    if (page.value > totalPages.value) page.value = totalPages.value;
  }

  // Filter + paginate
  List<KamModel> getPagedKams({required String query}) {
    final q = query.trim().toLowerCase();

    // 1) filter
    List<KamModel> base = kams;
    if (q.isNotEmpty) {
      base = base.where((k) {
        return k.name.toLowerCase().contains(q) ||
            k.email.toLowerCase().contains(q) ||
            k.phoneNumber.toLowerCase().contains(q) ||
            k.region.toLowerCase().contains(q);
      }).toList();
    }

    // 2) recalc pages based on filtered list
    final totalCount = base.length;
    final pages = (totalCount / limit.value).ceil();
    totalPages.value = pages == 0 ? 1 : pages;
    if (page.value > totalPages.value) page.value = totalPages.value;
    if (page.value < 1) page.value = 1;

    // 3) slice for current page
    final startIndex = (page.value - 1) * limit.value;
    if (startIndex >= totalCount) return [];

    final endIndex = math.min(startIndex + limit.value, totalCount);
    return base.sublist(startIndex, endIndex);
  }

  // Pagination actions
  void nextPage() {
    if (page.value < totalPages.value) {
      page.value++;
    }
  }

  void prevPage() {
    if (page.value > 1) {
      page.value--;
    }
  }

  void goToPage(int p) {
    if (p < 1 || p > totalPages.value) return;
    page.value = p;
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
          type: ToastType.error);

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
            type: ToastType.success);

        return true;
      } else {
        ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Failed to create KAM',
            type: ToastType.error);
        return false;
      }
    } catch (e) {
      debugPrint('Create KAM error: $e');
      ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error creating KAM',
          type: ToastType.error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
