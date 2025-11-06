import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/network/socket_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'dart:convert';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminCarAuctionTimerController extends GetxController {
  final RxList<CarsListModel> cars = <CarsListModel>[].obs;
  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchCars();
    listenToAuctionTimeUpdate();
  }

  // Fetch cars
  Future<void> fetchCars() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getCarsList(
          auctionStatus: AppConstants.auctionStatuses.all,
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cars.value = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(id: car['id'], data: car),
          ),
        );
      } else {
        cars.clear();
      }
    } catch (e) {
      cars.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Update auction fields
  // void updateAuctionFields({
  //   required String carId,
  //   required DateTime newStartTime,
  //   required int newDuration,
  // }) {
  //   final index = cars.indexWhere((c) => c.id == carId);
  //   if (index != -1) {
  //     cars[index].auctionStartTime = newStartTime;
  //     cars[index].auctionDuration = newDuration;
  //   }
  // }

  // Update auction time
  Future<void> updateAuctionTime({
    required String carId,
    DateTime? newStartTime,
    int? newDuration,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'carId': carId,
        if (newStartTime != null)
          'auctionStartTime': newStartTime.toUtc().toIso8601String(),
        if (newDuration != null) 'auctionDuration': newDuration,
      };

      final response = await ApiService.post(
        endpoint: AppUrls.updateCarAuctionTime,
        body: body,
      );

      if (response.statusCode == 200) {
        // Update local model too
        final index = cars.indexWhere((c) => c.id == carId);
        if (index != -1) {
          if (newStartTime != null) {
            cars[index].auctionStartTime = newStartTime;
          }
          if (newDuration != null) {
            cars[index].auctionDuration = newDuration;
          }
          cars.refresh(); // <— notify Obx rebuilds bound to cars
          update();
        }
        final ctx = Get.overlayContext ?? Get.context;
        if (ctx != null) {
          ToastWidget.show(
            context: ctx,
            title: 'Auction time updated successfully',
            type: ToastType.success,
          );
        }
      } else {
        final ctx = Get.overlayContext ?? Get.context;
        if (ctx != null) {
          ToastWidget.show(
            context: ctx,
            title: 'Failed to update auction time',
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx != null) {
        ToastWidget.show(
          context: ctx,
          title: 'Failed to update auction time',
          type: ToastType.error,
        );
      }
    }
  }

  // Listen to auction time update
  void listenToAuctionTimeUpdate() {
    SocketService.instance.joinRoom(SocketEvents.auctionTimerRoom);
    SocketService.instance.on(SocketEvents.auctionTimerUpdated, (data) {
      final carId = data['carId'].toString();
      final index = cars.indexWhere((c) => c.id == carId);
      if (index == -1) return;

      if (data['auctionStartTime'] != null) {
        cars[index].auctionStartTime = DateTime.parse(data['auctionStartTime']);
      }
      if (data['auctionEndTime'] != null) {
        cars[index].auctionEndTime = DateTime.parse(data['auctionEndTime']);
      }
      if (data['auctionDuration'] != null) {
        cars[index].auctionDuration = int.parse(
          data['auctionDuration'].toString(),
        );
      }
      cars.refresh();
      update();
    });
  }
}
