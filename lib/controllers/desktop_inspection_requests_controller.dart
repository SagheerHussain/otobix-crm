import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/inspection_requests_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class DesktopInspectionRequestsController extends GetxController {
  RxBool isPageLoading = false.obs;
  RxList<InspectionRequestsModel> inspectionRequestsList =
      <InspectionRequestsModel>[].obs;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt total = 0.obs;
  RxBool hasNext = false.obs;
  RxBool hasPrev = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInspectionRequestsList();
  }

  // Fetch inspection requests
  Future<void> fetchInspectionRequestsList() async {
    isPageLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint:
            '${AppUrls.getInspectionRequestsList}?page=${currentPage.value}&limit=10',
      );

      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Log fetched data to check
        debugPrint("Fetched Data: ${responseBody['data']}");

        final fetchedList = responseBody['data'];
        inspectionRequestsList.value = fetchedList
            .map<InspectionRequestsModel>(
                (item) => InspectionRequestsModel.fromJson(item))
            .toList();

        final pagination = responseBody['pagination'];
        total.value = pagination['total'];
        totalPages.value = pagination['totalPages'];
        hasNext.value = pagination['currentPage'] < pagination['totalPages'];
        hasPrev.value = pagination['currentPage'] > 1;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to fetch inspection requests',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching inspection requests',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  // Pagination controls
  void nextPage() {
    if (hasNext.value) {
      currentPage.value++;
      fetchInspectionRequestsList();
    }
  }

  void prevPage() {
    if (hasPrev.value) {
      currentPage.value--;
      fetchInspectionRequestsList();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      fetchInspectionRequestsList();
    }
  }
}
