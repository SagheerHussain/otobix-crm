import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_oto_buy_cars_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_upcoming_cars_list_controller.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class SetVariableMarginWidgetController extends GetxController {
  RxBool isSetVariableMarginLoading = false.obs;
  RxDouble highestBid = 0.0.obs; // always remains same
  RxDouble customerExpectedPrice = 0.0.obs; // always  remains same
  RxDouble variableMargin = 0.0.obs;
  RxDouble priceDiscovery = 0.0.obs; // always  remains same

  RxDouble initialAdjustedHighestBidShownToCustomer =
      0.0.obs; // always  remains same

  RxDouble customerExpectedPriceShownToDealer = 0.0.obs; // always  remains same

  RxDouble newAdjustedHighestBidShownToCustomer = 0.0.obs;

// For initial show with margin adjusted
  void calculateHighestBidShownToCustomerInitially() {
    initialAdjustedHighestBidShownToCustomer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: highestBid.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToPrevious1000: true,
    );
  }

  // For new changed margin
  void calculateHighestBidShownToCustomerOnMarginChange() {
    newAdjustedHighestBidShownToCustomer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: highestBid.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToPrevious1000: true,
    );
  }

// Customer Expected Price Shown To Dealer
  void calculateCustomerExpectedPriceShownToDealer() {
    customerExpectedPriceShownToDealer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: customerExpectedPrice.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToNext1000: true,
      increaseMargin: true,
    );
  }

  // Set variable margin
  Future<void> setVariableMargin(
      {required String carId, required String userId}) async {
    isSetVariableMarginLoading.value = true;

    try {
      final response = await ApiService.post(
        endpoint: AppUrls.setVariableMargin,
        body: {
          'carId': carId,
          'userId': userId,
          'variableMargin': variableMargin.value,
          'bidAmount': highestBid.value
        },
      );

      if (response.statusCode == 200) {
        Get.back();
        await Get.find<AdminUpcomingCarsListController>()
            .fetchUpcomingCarsList();
        await Get.find<AdminLiveCarsListController>().fetchLiveBidsCarsList();
        await Get.find<AdminOtoBuyCarsListController>().fetchOtoBuyCarsList();
        ToastWidget.show(
            context: Get.context!,
            title: 'Variable Margin Set',
            subtitle: 'Variable margin has been updated successfully',
            type: ToastType.success);
      } else if (response.statusCode == 400) {
        final message = jsonDecode(response.body)['message'];

        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: message ?? 'Failed to set variable margin',
          type: ToastType.error,
        );
      } else {
        debugPrint('Failed to set variable margin ${response.body}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to set variable margin',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error setting variable margin: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error setting variable margin',
        type: ToastType.error,
      );
    } finally {
      isSetVariableMarginLoading.value = false;
    }
  }
}
