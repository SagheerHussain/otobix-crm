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
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminUpcomingCarsListController extends GetxController {
  RxInt upcomingCarsCount = 0.obs;
  List<CarsListModel> upcomingCarsList = [];
  RxBool isLoading = false.obs;
  RxBool isSetExpectedPriceLoading = false.obs;

  // Countdown state
  final RxMap<String, String> remainingTimes = <String, String>{}.obs;
  final Map<String, Timer> _timers = {};

  final RxList<CarsListModel> filteredUpcomingCarsList = <CarsListModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUpcomingCarsList();
    _listenUpcomingCarsSectionRealtime();
  }

  // Live Cars List
  Future<void> fetchUpcomingCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.upcoming,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        upcomingCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        upcomingCarsCount.value = upcomingCarsList.length;

        // filteredUpcomingCarsList.value = upcomingCarsList;
        // setupCountdowns(upcomingCarsList);

        filteredUpcomingCarsList.assignAll(upcomingCarsList);
        // setupCountdowns(filteredUpcomingCarsList);
        setupCountdowns(filteredUpcomingCarsList.toList());
      } else {
        filteredUpcomingCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredUpcomingCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Single entry-point: wire countdowns to the given cars list.
  /// - Cancels timers for cars that disappeared
  /// - (Re)starts timers for provided cars
  /// - Formats "15h : 22m : 44s"
  void setupCountdowns(List<CarsListModel> carsInput) {
    // ✅ snapshot so iteration is safe even if the RxList changes
    final cars = List<CarsListModel>.from(carsInput);

    // 1) Cancel timers that are no longer needed
    final newIds = cars.map((c) => c.id).toSet();
    final toRemove = _timers.keys.where((id) => !newIds.contains(id)).toList();

    for (final id in toRemove) {
      _timers[id]?.cancel();
      _timers.remove(id);
      remainingTimes.remove(id);
    }

    String fmt(Duration d) {
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(d.inHours)}h : ${two(d.inMinutes % 60)}m : ${two(d.inSeconds % 60)}s';
    }

    void startFor(CarsListModel car) {
      _timers[car.id]?.cancel();

      final until = car.upcomingUntil;
      if (until == null) {
        remainingTimes[car.id] = 'N/A';
        return;
      }

      void tick() {
        final diff = until.difference(DateTime.now());

        if (diff.inSeconds <= 0) {
          remainingTimes[car.id] = '00h : 00m : 00s';

          _timers[car.id]?.cancel();
          _timers.remove(car.id);
          remainingTimes.remove(car.id);

          // ✅ Defer list mutation so it never clashes with any current loop/build
          Future.microtask(() {
            filteredUpcomingCarsList.removeWhere((c) => c.id == car.id);
            upcomingCarsCount.value = filteredUpcomingCarsList.length;
          });

          return;
        }

        remainingTimes[car.id] = fmt(diff);
      }

      tick(); // prime immediately
      _timers[car.id] =
          Timer.periodic(const Duration(seconds: 1), (_) => tick());
    }

    // 2) Start timers safely using the snapshot
    for (final car in cars) {
      startFor(car);
    }
  }

  // void setupCountdowns1(List<CarsListModel> cars) {
  //   // 1) Cancel timers that are no longer needed
  //   final newIds = cars.map((c) => c.id).toSet();
  //   final toRemove = _timers.keys.where((id) => !newIds.contains(id)).toList();
  //   for (final id in toRemove) {
  //     _timers[id]?.cancel();
  //     _timers.remove(id);
  //     remainingTimes.remove(id);
  //   }

  //   // Local helpers (kept inside this single function)
  //   String fmt(Duration d) {
  //     String two(int n) => n.toString().padLeft(2, '0');
  //     return '${two(d.inHours)}h : ${two(d.inMinutes % 60)}m : ${two(d.inSeconds % 60)}s';
  //   }

  //   void startFor(CarsListModel car) {
  //     // Cancel previous timer for this car (if any)
  //     _timers[car.id]?.cancel();

  //     final until = car.upcomingUntil;
  //     if (until == null) {
  //       remainingTimes[car.id] = 'N/A';
  //       return;
  //     }

  //     void tick() {
  //       final diff = until.difference(DateTime.now());
  //       if (diff.isNegative || diff.inSeconds <= 0) {
  //         remainingTimes[car.id] = '00h : 00m : 00s';
  //         _timers[car.id]?.cancel();
  //         _timers.remove(car.id);

  //         // Remove the car from the list when timer becomes less than zero
  //         remainingTimes.remove(car.id);
  //         filteredUpcomingCarsList.removeWhere((c) => c.id == car.id);
  //         upcomingCarsCount.value = filteredUpcomingCarsList.length;

  //         return;
  //       }
  //       remainingTimes[car.id] = fmt(diff);
  //     }

  //     // Prime immediately, then every second
  //     tick();
  //     _timers[car.id] = Timer.periodic(
  //       const Duration(seconds: 1),
  //       (_) => tick(),
  //     );
  //   }

  //   // 2) Ensure every given car has an active timer
  //   for (final car in cars) {
  //     startFor(car);
  //   }
  // }

  // Listen to upcoming cars section realtime
  void _listenUpcomingCarsSectionRealtime() {
    SocketService.instance.joinRoom(SocketEvents.upcomingBidsSectionRoom);

    SocketService.instance.on(SocketEvents.upcomingBidsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'removed') {
        final String id = '${data['id']}';

        // cancel controller-owned timer & remove readable time
        _timers[id]?.cancel();
        _timers.remove(id);
        remainingTimes.remove(id);

        // remove from list
        filteredUpcomingCarsList.value =
            filteredUpcomingCarsList.where((c) => c.id != id).toList();

        // update count
        upcomingCarsCount.value = filteredUpcomingCarsList.length;
        return;
      }

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );
        final incoming = CarsListModel.fromJson(id: id, data: carJson);

        final idx = filteredUpcomingCarsList.indexWhere((c) => c.id == id);
        if (idx == -1) {
          filteredUpcomingCarsList.add(incoming);
        } else {
          // replace model (no model timers to cancel anymore)
          filteredUpcomingCarsList[idx] = incoming;
        }

        // refresh all timers via the single entry-point
        // setupCountdowns(filteredUpcomingCarsList);
        setupCountdowns(filteredUpcomingCarsList.toList());

        // update count
        upcomingCarsCount.value = filteredUpcomingCarsList.length;
        return;
      }
    });
  }

  // Get initial price for expected price button
  double getInitialPriceForExpectedPriceButton(CarsListModel car) {
    final double finalPrice = car.customerExpectedPrice.value != 0
        ? car.customerExpectedPrice.value
        : car.priceDiscovery;
    return finalPrice;
  }

  // Check which (pd/expected) price is this for expected price button
  bool canIncreasePriceUpto150Percent(CarsListModel car) {
    final bool type = car.customerExpectedPrice.value != 0 ? false : true;
    return type;
  }

  // Set customer expected price
  Future<void> setCustomerExpectedPrice({
    required String carId,
    required double customerExpectedPrice,
  }) async {
    if (customerExpectedPrice <= 0) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Enter a valid amount',
        type: ToastType.error,
      );
      return;
    }

    isSetExpectedPriceLoading.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.setCustomerExpectedPrice,
        body: {'carId': carId, 'customerExpectedPrice': customerExpectedPrice},
      );

      if (response.statusCode == 200) {
        Get.back();
        await Get.find<AdminUpcomingCarsListController>()
            .fetchUpcomingCarsList();
        ToastWidget.show(
          context: Get.context!,
          title:
              'Successfully updated expected price to Rs. ${NumberFormat.decimalPattern('en_IN').format(customerExpectedPrice)}/-',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to update expected price ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to update expected price',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error updating expected price',
        type: ToastType.error,
      );
    } finally {
      isSetExpectedPriceLoading.value = false;
    }
  }

  @override
  void onClose() {
    // stop all timers and clear remaining times via the same single function
    setupCountdowns(const []);
    super.onClose();
  }
}
