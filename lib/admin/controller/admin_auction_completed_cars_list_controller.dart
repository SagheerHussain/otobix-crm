import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/network/socket_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminAuctionCompletedCarsListController extends GetxController {
  RxInt auctionCompletedCarsCount = 0.obs;
  List<CarsListModel> auctionCompletedCarsList = [];
  RxBool isLoading = false.obs;

  final RxList<CarsListModel> filteredAuctionCompletedCarsList =
      <CarsListModel>[].obs;

  final reasonText = ''.obs;
  final isRemoveButtonLoading = false.obs;
  final reasontextController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await fetchAuctionCompletedCarsList();
    _listenAuctionCompletedCarsSectionRealtime();
  }

  // Live Cars List
  Future<void> fetchAuctionCompletedCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.liveAuctionEnded,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        auctionCompletedCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        auctionCompletedCarsCount.value = auctionCompletedCarsList.length;

        filteredAuctionCompletedCarsList.assignAll(auctionCompletedCarsList);
      } else {
        filteredAuctionCompletedCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredAuctionCompletedCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Listen to upcoming cars section realtime
  void _listenAuctionCompletedCarsSectionRealtime() {
    SocketService.instance.joinRoom(
      SocketEvents.auctionCompletedCarsSectionRoom,
    );

    SocketService.instance.on(SocketEvents.auctionCompletedCarsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'removed') {
        final String id = '${data['id']}';

        // remove from list
        filteredAuctionCompletedCarsList.removeWhere((c) => c.id == id);

        // update count
        auctionCompletedCarsCount.value =
            filteredAuctionCompletedCarsList.length;
        return;
      }

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );
        final incoming = CarsListModel.fromJson(id: id, data: carJson);

        final idx = filteredAuctionCompletedCarsList.indexWhere(
          (c) => c.id == id,
        );
        if (idx == -1) {
          filteredAuctionCompletedCarsList.add(incoming);
        } else {
          // replace model (no model timers to cancel anymore)
          filteredAuctionCompletedCarsList[idx] = incoming;
        }

        // update count
        auctionCompletedCarsCount.value =
            filteredAuctionCompletedCarsList.length;
        return;
      }
    });
  }

  Future<void> moveCarToOtobuy({
    required String carId,
    required int? oneClickPrice,
  }) async {
    try {
      if (oneClickPrice == null || oneClickPrice <= 0) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Missing price',
          subtitle: 'Please select or enter a valid one-click price.',
          type: ToastType.error,
        );
        return;
      }

      final body = {'carId': carId, 'oneClickPrice': oneClickPrice};

      final response = await ApiService.post(
        endpoint: AppUrls.moveCarToOtobuy,
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Moved to Otobuy',
          subtitle:
              'Car moved to otobuy at Rs. ${NumberFormat.decimalPattern('en_IN').format(oneClickPrice.round())}.',
          type: ToastType.success,
        );
        Get.back(); // close sheet
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to move to otobuy',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: 'Error moving to otobuy',
        type: ToastType.error,
      );
    }
  }

  // Remove Car
  Future<void> removeCar({required String carId}) async {
    isRemoveButtonLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

      final response = await ApiService.post(
        endpoint: AppUrls.removeCar,
        body: {
          'carId': carId,
          'reasonOfRemoval': reasonText.value,
          'removedBy': userId,
        },
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Car removed successfully',
          type: ToastType.success,
        );
        Get.back();
      } else {
        debugPrint('Failed to remove car ${response.body}');
      }
    } catch (error) {
      debugPrint('Error removing car: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error removing car',
        type: ToastType.error,
      );
    } finally {
      // optional: clear UI state
      reasontextController.clear();
      reasonText.value = '';
      isRemoveButtonLoading.value = false;
    }
  }

  @override
  void onClose() {
    //
    super.onClose();
  }
}
