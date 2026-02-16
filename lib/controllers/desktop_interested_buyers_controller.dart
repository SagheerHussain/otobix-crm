import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/interested_buyers_model.dart';

import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class DesktopInterestedBuyersController extends GetxController {
  RxBool isPageLoading = false.obs;
  RxList<InterestedBuyersModel> interestedBuyersList =
      <InterestedBuyersModel>[].obs;

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
    fetchInterestedBuyersList();
  }

  Future<void> fetchInterestedBuyersList() async {
    isPageLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint:
            '${AppUrls.getInterestedBuyersList}?page=${currentPage.value}&limit=$pageLimit',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        final List<dynamic> fetchedList =
            (responseBody['data'] ?? []) as List<dynamic>;
        interestedBuyersList.value = fetchedList
            .map<InterestedBuyersModel>((item) =>
                InterestedBuyersModel.fromJson(item as Map<String, dynamic>))
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
          subtitle: 'Failed to fetch interested buyers',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("fetchInterestedBuyersList Error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching interested buyers',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  void nextPage() {
    if (hasNext.value) {
      currentPage.value++;
      fetchInterestedBuyersList();
    }
  }

  void prevPage() {
    if (hasPrev.value) {
      currentPage.value--;
      fetchInterestedBuyersList();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      fetchInterestedBuyersList();
    }
  }
}
