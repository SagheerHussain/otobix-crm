import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/telecallings_model.dart';

import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class DesktopTelecallingsController extends GetxController {
  RxBool isPageLoading = false.obs;
  RxList<TelecallingModel> telecallingsList = <TelecallingModel>[].obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt total = 0.obs;
  RxBool hasNext = false.obs;
  RxBool hasPrev = false.obs;

  final int pageLimit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchTelecallingsList();
  }

  Future<void> fetchTelecallingsList() async {
    isPageLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint:
            '${AppUrls.getTelecallingsList}?page=${currentPage.value}&limit=$pageLimit',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        final List<dynamic> fetchedList =
            (responseBody['data'] ?? []) as List<dynamic>;
        telecallingsList.value = fetchedList
            .map<TelecallingModel>((item) =>
                TelecallingModel.fromJson(item as Map<String, dynamic>))
            .toList();

        final pagination =
            (responseBody['pagination'] ?? {}) as Map<String, dynamic>;
        total.value = (pagination['total'] ?? 0) as int;
        totalPages.value = (pagination['totalPages'] ?? 1) as int;

        final cur = (pagination['currentPage'] ?? currentPage.value) as int;
        currentPage.value = cur;

        hasNext.value = currentPage.value < totalPages.value;
        hasPrev.value = currentPage.value > 1;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to fetch telecallings',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("fetchTelecallingsList Error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching telecallings',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  void nextPage() {
    if (hasNext.value) {
      currentPage.value++;
      fetchTelecallingsList();
    }
  }

  void prevPage() {
    if (hasPrev.value) {
      currentPage.value--;
      fetchTelecallingsList();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      fetchTelecallingsList();
    }
  }
}
